import requests
from bs4 import BeautifulSoup
import pdfplumber
import time
from datetime import datetime, timedelta
import re
import psycopg2
from psycopg2.extras import DictCursor
from urllib.parse import urlparse, urljoin
import os
import json
import logging
import traceback

# Configure logging for GCP Cloud Functions / Cloud Run
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    force=True
)

# --- Database Connection ---
from ..extensions import db

def get_db_connection():
    """Returns a new database connection from the SQLAlchemy engine."""
    return db.engine.raw_connection()

# --- Scraper Type Specific URL Finders ---

def find_agenda_urls_legistar(base_url, municipality_name, config=None):
    """Finds agenda URLs for Legistar sites (like Killeen)."""
    agenda_links = []
    try:
        response = requests.get(base_url, timeout=30)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, "html.parser")
        current_date = datetime.now()
        one_year_ago = current_date - timedelta(days=365) 

        rows = soup.select("#ctl00_ContentPlaceHolder1_gridCalendar_ctl00 > tbody > tr.rgRow, #ctl00_ContentPlaceHolder1_gridCalendar_ctl00 > tbody > tr.rgAltRow")
        if not rows: 
            rows = soup.select("table[id*='gridCalendar'] tr[class*='rgRow'], table[id*='gridCalendar'] tr[class*='rgAltRow']")

        for row in rows:
            date_cell = row.find("td", class_="rgSorted") or row.select_one("td:first-child") 
            if not date_cell: continue
            date_str = date_cell.get_text(strip=True)
            try:
                meeting_date = datetime.strptime(date_str, "%m/%d/%Y")
                if not (one_year_ago <= meeting_date <= current_date): continue
            except ValueError:
                logging.warning(f"Could not parse date '{date_str}' for {municipality_name}.")
                continue

            agenda_link_tag = row.find("a", href=re.compile(r"View\.ashx\?M=A|MeetingDetail\.aspx", re.I))
            if not agenda_link_tag:
                 agenda_link_tag = row.find("a", text=re.compile(r"Agenda", re.I))

            if agenda_link_tag and agenda_link_tag.has_attr('href'):
                href = agenda_link_tag['href']
                full_url = urljoin(base_url, href)
                if "View.ashx?M=A" in href: 
                     agenda_links.append({'url': full_url, 'date': meeting_date.strftime("%Y-%m-%d")})
                
        logging.info(f"Found {len(agenda_links)} potential agenda URLs for {municipality_name} (Legistar).")
        deduplicated_links = [dict(t) for t in {tuple(d.items()) for d in agenda_links}]
        return deduplicated_links
    except requests.exceptions.RequestException as e:
        logging.error(f"Error fetching Legistar page {base_url} for {municipality_name}: {e}")
    except Exception as e:
        logging.error(f"Error parsing Legistar page for {municipality_name}: {e}")
    return []

def find_agenda_urls_municode(base_url, municipality_name, config=None):
    """Finds agenda URLs for Municode sites (e.g., Bartlett, Morgan's Point Resort)."""
    agenda_links = []
    try:
        response = requests.get(base_url, timeout=30)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, "html.parser")
        
        possible_links = soup.find_all("a", href=True)
        
        for link_tag in possible_links:
            href = link_tag['href']
            link_text = link_tag.get_text(strip=True).lower()
            is_agenda_link = False
            if "mccmeetings.blob.core.usgovcloudapi.net" in href and "agenda" in href.lower(): is_agenda_link = True
            elif ("fileattachments" in href and "agenda" in href.lower()) or "agenda" in link_text: is_agenda_link = True
            elif "GeneratedItems/ExportSingle" in href: is_agenda_link = True

            if is_agenda_link:
                full_url = urljoin(base_url, href)
                date_text_element = None
                parent_element = link_tag.parent
                for _ in range(4): 
                    if not parent_element: break
                    if parent_element.name == 'tr':
                        first_cell = parent_element.find(['td', 'th'])
                        if first_cell: date_text_element = first_cell; break 
                    elif parent_element.name in ['div', 'p', 'span']:
                         date_text_element = parent_element
                         direct_date_match = re.search(r'(\d{1,2}/\d{1,2}/\d{2,4})|([A-Za-z]+\s+\d{1,2},?\s+\d{4})', parent_element.get_text(strip=True))
                         if direct_date_match: break
                    parent_element = parent_element.parent
                
                meeting_date_str = None
                if date_text_element:
                    date_text_content = date_text_element.get_text(strip=True)
                    date_match = re.search(r'(\d{1,2}/\d{1,2}/\d{2,4})', date_text_content)
                    if date_match:
                        date_str_found = date_match.group(1)
                        try:
                            parsed_date = datetime.strptime(date_str_found, "%m/%d/%Y") if len(date_str_found.split('/')[-1]) == 4 else datetime.strptime(date_str_found, "%m/%d/%y")
                            meeting_date_str = parsed_date.strftime("%Y-%m-%d")
                        except ValueError: logging.warning(f"Could not parse date (pattern 1) '{date_str_found}' for {municipality_name} in '{date_text_content}'")
                    if not meeting_date_str:
                        date_match_month = re.search(r'([A-Za-z]+)\s+(\d{1,2}),?\s+(\d{4})', date_text_content)
                        if date_match_month:
                            try: parsed_date = datetime.strptime(date_match_month.group(0), "%B %d, %Y"); meeting_date_str = parsed_date.strftime("%Y-%m-%d")
                            except ValueError:
                                try: parsed_date = datetime.strptime(date_match_month.group(0), "%b %d, %Y"); meeting_date_str = parsed_date.strftime("%Y-%m-%d")
                                except ValueError: logging.warning(f"Could not parse date (pattern 2) '{date_match_month.group(0)}' for {municipality_name} in '{date_text_content}'")
                    if not meeting_date_str:
                        date_match_iso = re.search(r'(\d{4}-\d{1,2}-\d{1,2})', date_text_content)
                        if date_match_iso:
                             try: parsed_date = datetime.strptime(date_match_iso.group(1), "%Y-%m-%d"); meeting_date_str = parsed_date.strftime("%Y-%m-%d")
                             except ValueError: logging.warning(f"Could not parse date (pattern 3) '{date_match_iso.group(1)}' for {municipality_name} in '{date_text_content}'")
                if meeting_date_str:
                    parsed_dt = datetime.strptime(meeting_date_str, "%Y-%m-%d")
                    one_year_ago = datetime.now() - timedelta(days=365); current_date = datetime.now()
                    if one_year_ago <= parsed_dt <= current_date: agenda_links.append({'url': full_url, 'date': meeting_date_str})
                else: logging.warning(f"Could not reliably extract date for agenda link: {full_url} for {municipality_name}")
        logging.info(f"Found {len(agenda_links)} potential agenda URLs for {municipality_name} (Municode).")
        deduplicated_links = [dict(t) for t in {tuple(d.items()) for d in agenda_links}]
        return deduplicated_links
    except requests.exceptions.RequestException as e: logging.error(f"Error fetching Municode page {base_url} for {municipality_name}: {e}")
    except Exception as e: logging.error(f"Error parsing Municode page for {municipality_name}: {e}\n{traceback.format_exc()}")
    return []

def find_agenda_urls_civicplus(base_url, municipality_name, config=None):
    """Finds agenda URLs for CivicPlus sites (e.g., Salado)."""
    agenda_links = []
    try:
        response = requests.get(base_url, timeout=30)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, "html.parser")
        possible_links = soup.find_all("a", href=True)
        for link_tag in possible_links:
            href = link_tag['href']
            link_text = link_tag.get_text(strip=True)
            is_agenda_link = False
            if ("/sites/default/files/fileattachments/" in href and href.lower().endswith('.pdf')):
                if "agenda" in href.lower() or "packet" in href.lower() or "agenda" in link_text.lower() or "packet" in link_text.lower(): is_agenda_link = True
            elif "/AgendaCenter/ViewFile/" in href:
                 if "agenda" in link_text.lower() or "packet" in link_text.lower() or "_agenda_" in href.lower() or "_packet_" in href.lower(): is_agenda_link = True
            elif href.lower().endswith('.pdf') and ("agenda" in link_text.lower() or "packet" in link_text.lower()): is_agenda_link = True

            if is_agenda_link:
                full_url = urljoin(base_url, href)
                meeting_date_str = None; date_text_content = None; current_element = link_tag
                for _ in range(4): 
                    if not current_element: break
                    if current_element.name == 'tr':
                        cells = current_element.find_all(['td', 'th'])
                        for cell in cells:
                            cell_text = cell.get_text(strip=True)
                            date_match = re.search(r'(\d{1,2}/\d{1,2}/\d{2,4})|([A-Za-z]+\s+\d{1,2},?\s+\d{4})|(\d{1,2}-\d{1,2}-\d{2,4})', cell_text)
                            if date_match: date_text_content = date_match.group(0); break
                        if date_text_content: break 
                    if not date_text_content:
                        texts_to_check = [link_text]
                        if current_element.parent: texts_to_check.append(current_element.parent.get_text(strip=True))
                        for text_sample in texts_to_check:
                            date_match = re.search(r'(\d{1,2}/\d{1,2}/\d{2,4})|([A-Za-z]+\s+\d{1,2},?\s+\d{4})|(\d{4}-\d{1,2}-\d{1,2})', text_sample)
                            if date_match: date_text_content = date_match.group(0); break
                        if date_text_content: break
                    current_element = current_element.parent if current_element.parent else None
                if date_text_content:
                    try:
                        clean_date_str = date_text_content.replace('-', '/'); clean_date_str = re.sub(r'(\d+)(st|nd|rd|th)', r' ', clean_date_str)
                        parsed_date_obj = None
                        if re.match(r'\d{1,2}/\d{1,2}/\d{4}', clean_date_str): parsed_date_obj = datetime.strptime(clean_date_str, "%m/%d/%Y")
                        elif re.match(r'\d{1,2}/\d{1,2}/\d{2}', clean_date_str): parsed_date_obj = datetime.strptime(clean_date_str, "%m/%d/%y")
                        elif re.match(r'[A-Za-z]+\s+\d{1,2},?\s+\d{4}', clean_date_str):
                            try: parsed_date_obj = datetime.strptime(clean_date_str.replace(',', ''), "%B %d %Y")
                            except ValueError: parsed_date_obj = datetime.strptime(clean_date_str.replace(',', ''), "%b %d %Y")
                        elif re.match(r'\d{4}/\d{1,2}/\d{1,2}', clean_date_str): parsed_date_obj = datetime.strptime(clean_date_str, "%Y/%m/%d")
                        if parsed_date_obj: meeting_date_str = parsed_date_obj.strftime("%Y-%m-%d")
                        else: logging.warning(f"Date format not recognized in '{date_text_content}' for {municipality_name}")
                    except ValueError as ve: logging.warning(f"Date parsing failed for '{date_text_content}' for {municipality_name}: {ve}")
                if meeting_date_str:
                    parsed_dt = datetime.strptime(meeting_date_str, "%Y-%m-%d")
                    one_year_ago = datetime.now() - timedelta(days=365); current_date_limit = datetime.now() + timedelta(days=7) 
                    if one_year_ago <= parsed_dt <= current_date_limit: agenda_links.append({'url': full_url, 'date': meeting_date_str})
                else: logging.warning(f"Could not extract date for agenda link: {full_url} (text: {link_text}) for {municipality_name}")
        logging.info(f"Found {len(agenda_links)} potential agenda URLs for {municipality_name} (CivicPlus).")
        deduplicated_links = [dict(t) for t in {tuple(d.items()) for d in agenda_links}]
        return deduplicated_links
    except requests.exceptions.RequestException as e: logging.error(f"Error fetching CivicPlus page {base_url} for {municipality_name}: {e}")
    except Exception as e: logging.error(f"Error parsing CivicPlus page for {municipality_name}: {e}\n{traceback.format_exc()}")
    return []

def find_agenda_urls_wordpress(base_url, municipality_name, config=None):
    """Finds agenda URLs for WordPress sites (e.g., Little River-Academy, Rogers)."""
    agenda_links = []
    try:
        response = requests.get(base_url, timeout=30)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, "html.parser")
        possible_links = soup.find_all("a", href=True)
        for link_tag in possible_links:
            href = link_tag['href']
            link_text = link_tag.get_text(strip=True)
            if not href.lower().endswith('.pdf') and not "agenda" in href.lower() and not "minutes" in href.lower():
                if not ("agenda" in link_text.lower() or "hearing" in link_text.lower()): continue
            if any(skip_text in href.lower() for skip_text in ['logo', 'advertisement', 'event-calendar', 'newsletter']): continue
            if any(skip_text in link_text.lower() for skip_text in ['minutes', 'newsletter', 'calendar']):
                 if "agenda" not in link_text.lower() and "hearing" not in link_text.lower(): continue
            full_url = urljoin(base_url, href); meeting_date_str = None; found_date_text = None
            date_patterns = [r'(\d{1,2}[-/]\d{1,2}[-/]\d{2,4})', r'([A-Za-z]+\s+\d{1,2}(?:st|nd|rd|th)?,?\s+\d{4})', r'(\d{4}-\d{1,2}-\d{1,2})']
            for pattern in date_patterns:
                date_match = re.search(pattern, link_text)
                if date_match: found_date_text = date_match.group(1); break
            if not found_date_text:
                parent_element = link_tag.parent
                for _ in range(3): 
                    if not parent_element: break
                    parent_text = parent_element.get_text(strip=True)
                    for pattern in date_patterns:
                        date_match = re.search(pattern, parent_text)
                        if date_match: found_date_text = date_match.group(1); break
                    if found_date_text: break
                    parent_element = parent_element.parent
            if found_date_text:
                try:
                    parsed_date_obj = None
                    if re.match(r'\d{1,2}[-/]\d{1,2}[-/]\d{4}', found_date_text): parsed_date_obj = datetime.strptime(re.sub(r'[-/]', '/', found_date_text), "%m/%d/%Y")
                    elif re.match(r'\d{1,2}[-/]\d{1,2}[-/]\d{2}', found_date_text): parsed_date_obj = datetime.strptime(re.sub(r'[-/]', '/', found_date_text), "%m/%d/%y")
                    elif re.match(r'[A-Za-z]+\s+\d{1,2}(?:st|nd|rd|th)?,?\s+\d{4}', found_date_text):
                        clean_date_text = re.sub(r'(\d+)(st|nd|rd|th)', r' ', found_date_text)
                        try: parsed_date_obj = datetime.strptime(clean_date_text, "%B %d, %Y")
                        except ValueError: parsed_date_obj = datetime.strptime(clean_date_text, "%b %d, %Y")
                    elif re.match(r'\d{4}-\d{1,2}-\d{1,2}', found_date_text): parsed_date_obj = datetime.strptime(found_date_text, "%Y-%m-%d")
                    else: raise ValueError("Date format not recognized by initial patterns")
                    meeting_date_str = parsed_date_obj.strftime("%Y-%m-%d")
                except ValueError as ve: logging.warning(f"Could not parse date from extracted text '{found_date_text}' for {municipality_name} (URL: {full_url}): {ve}")
            if meeting_date_str:
                parsed_dt = datetime.strptime(meeting_date_str, "%Y-%m-%d")
                one_year_ago = datetime.now() - timedelta(days=365); current_date = datetime.now()
                if one_year_ago <= parsed_dt <= current_date : 
                    if "agenda" in link_text.lower() or "hearing" in link_text.lower() or "agenda" in full_url.lower():
                        agenda_links.append({'url': full_url, 'date': meeting_date_str})
            else: logging.warning(f"Could not extract date for potential agenda link: {link_text} ({full_url}) for {municipality_name}")
        logging.info(f"Found {len(agenda_links)} potential agenda URLs for {municipality_name} (WordPress).")
        deduplicated_links = [dict(t) for t in {tuple(d.items()) for d in agenda_links}]
        return deduplicated_links
    except requests.exceptions.RequestException as e: logging.error(f"Error fetching WordPress page {base_url} for {municipality_name}: {e}")
    except Exception as e: logging.error(f"Error parsing WordPress page for {municipality_name}: {e}\n{traceback.format_exc()}")
    return []

def find_agenda_urls_revize(base_url, municipality_name, config=None):
    """Finds agenda URLs for Revize sites (e.g., Belton)."""
    agenda_links = []
    # Example Belton URL: https://www.beltontexas.gov/government/city_council/city_council_agendas_and_minutes.php
    # Links are typically in tables, grouped by year, directly linking to PDFs.
    # PDF URLs often look like: /Agendas%20&%20Minutes/2024%20City%20Council%20Agenda,%20Packets,%20Minutes/Agenda%20-%20121024.pdf
    # Or sometimes paths like /document_center/....

    try:
        response = requests.get(base_url, timeout=30)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, "html.parser")
        
        # Revize sites often list documents in tables or within sections for years.
        # We need to find links that are explicitly for "Agenda" or "Packet".
        
        # The Belton site has tables for each year, e.g., a <table> directly following a <h2>2024</h2>
        # Other Revize sites might have a slightly different structure, so we try to be a bit flexible.
        
        current_year_from_system = datetime.now().year
        years_to_check = [str(current_year_from_system), str(current_year_from_system - 1)] # Current and previous year

        for year_str in years_to_check:
            year_header = soup.find(['h1', 'h2', 'h3', 'h4', 'h5', 'strong'], text=re.compile(r' ' + year_str + r' '))
            if not year_header:
                logging.info(f"No section found for year {year_str} for {municipality_name} on {base_url}")
                continue

            logging.info(f"Processing year {year_str} for {municipality_name}")
            # Assume the table of links immediately follows the year header or is a sibling.
            # This might need adjustment if the structure is more nested.
            current_element = year_header
            # Try to find the table that is a sibling or near sibling to the year header
            table_found = None
            for _ in range(5): # Look at next few siblings
                current_element = current_element.find_next_sibling()
                if not current_element: break
                if current_element.name == 'table':
                    table_found = current_element
                    break
                # Sometimes links are just in a list or div after the header
                if not table_found and current_element.find_all('a', href=True):
                     table_found = current_element # Treat this container as the "table"
                     break
            
            if not table_found:
                logging.warning(f"Could not find a table/link container for year {year_str} for {municipality_name}")
                continue

            rows = table_found.find_all(['tr', 'li']) # Common elements for listing items

            for row_idx, row in enumerate(rows):
                cells = row.find_all(['td', 'th']) if row.name == 'tr' else [row] # If it's a list item, treat the item itself as a cell
                
                date_cell_text = None
                link_container_cells = cells # Where to search for links

                if cells:
                    # Attempt to find a cell that explicitly contains a date.
                    # Revize date formats can vary: "December 9", "Nov 25", "10/28" (needs year context)
                    # The first cell is often the date or a description containing the date.
                    date_cell_text = cells[0].get_text(strip=True)
                    if len(cells) > 1: # If more cells, links might be in subsequent cells
                        link_container_cells = cells[1:]


                meeting_date_str = None
                parsed_date_obj = None

                if date_cell_text:
                    date_patterns = [
                        r'([A-Za-z]+)\s+(\d{1,2}),?\s+(' + year_str + r')',  # Month Day, YEAR (from context)
                        r'([A-Za-z]+)\s+(\d{1,2})',                         # Month Day (year_context needed)
                        r'(\d{1,2}/\d{1,2})',                              # MM/DD (year_context needed)
                        r'(\d{1,2}/\d{1,2}/\d{2,4})'                        # MM/DD/YYYY or MM/DD/YY
                    ]
                    for pattern in date_patterns:
                        date_match = re.search(pattern, date_cell_text)
                        if date_match:
                            extracted_date_part = date_match.group(0)
                            try:
                                if len(date_match.groups()) == 3 and date_match.group(3) == year_str : # Month Day, YEAR
                                    parsed_date_obj = datetime.strptime(extracted_date_part.replace(',', ''), f"%B %d {year_str}")
                                elif len(date_match.groups()) == 2 and pattern == r'([A-Za-z]+)\s+(\d{1,2})': # Month Day
                                    parsed_date_obj = datetime.strptime(f"{extracted_date_part} {year_str}", "%B %d %Y")
                                elif len(date_match.groups()) == 2 and pattern == r'(\d{1,2}/\d{1,2})': # MM/DD
                                     parsed_date_obj = datetime.strptime(f"{extracted_date_part}/{year_str[-2:]}", "%m/%d/%y") # Use last two digits of year
                                elif len(extracted_date_part.split('/')) == 3: # MM/DD/YYYY or MM/DD/YY
                                    if len(extracted_date_part.split('/')[-1]) == 2:
                                        parsed_date_obj = datetime.strptime(extracted_date_part, "%m/%d/%y")
                                    else:
                                        parsed_date_obj = datetime.strptime(extracted_date_part, "%m/%d/%Y")
                                if parsed_date_obj:
                                    # Ensure the parsed year is the one we are currently processing or makes sense
                                    if str(parsed_date_obj.year) != year_str and len(extracted_date_part.split('/')) !=3 : # If year not in text, ensure it matches context
                                        if len(extracted_date_part.split('/')) == 2 or len(extracted_date_part.split(' ')) == 2 : # like MM/DD or Month Day
                                            parsed_date_obj = parsed_date_obj.replace(year=int(year_str))
                                        else: # Date string had year but it does not match context year, likely wrong row
                                            logging.debug(f"Date year mismatch for {municipality_name}: context {year_str}, parsed {parsed_date_obj.year} from '{extracted_date_part}'")
                                            parsed_date_obj = None # Discard if year context doesn't make sense
                                            
                                if parsed_date_obj:
                                    meeting_date_str = parsed_date_obj.strftime("%Y-%m-%d")
                                    break 
                            except ValueError as ve:
                                logging.debug(f"Date parse failed for '{extracted_date_part}' for {municipality_name}: {ve}")
                                continue
                
                if not meeting_date_str:
                    # logging.warning(f"Could not parse date for row in {municipality_name}, year {year_str}. Row text: {row.get_text(strip=True,separator='|')[:100]}")
                    continue # Skip row if no date found

                # Filter by date (e.g., last year)
                parsed_dt = datetime.strptime(meeting_date_str, "%Y-%m-%d")
                one_year_ago = datetime.now() - timedelta(days=365)
                current_date_limit = datetime.now() + timedelta(days=7) # Allow for slightly future posted agendas
                if not (one_year_ago <= parsed_dt <= current_date_limit):
                    continue

                for cell_for_links in link_container_cells: # Search for links in remaining cells or the row itself
                    link_tags = cell_for_links.find_all("a", href=True)
                    for link_tag in link_tags:
                        href = link_tag['href']
                        link_text_lower = link_tag.get_text(strip=True).lower()

                        is_target_doc = False
                        # Revize links often contain "docid=" or are direct PDFs.
                        # Or /document_center/ and agenda/packet in text
                        if href.lower().endswith('.pdf') and ('agenda' in link_text_lower or 'packet' in link_text_lower or 'agenda' in href.lower() or 'packet' in href.lower()):
                            is_target_doc = True
                        elif "docid=" in href.lower() and ('agenda' in link_text_lower or 'packet' in link_text_lower):
                            is_target_doc = True
                        elif "document_center" in href.lower() and ('agenda' in link_text_lower or 'packet' in link_text_lower):
                            is_target_doc = True

                        if is_target_doc:
                            full_url = urljoin(base_url, href)
                            agenda_links.append({'url': full_url, 'date': meeting_date_str})

        logging.info(f"Found {len(agenda_links)} potential agenda URLs for {municipality_name} (Revize).")
        deduplicated_links = [dict(t) for t in {tuple(d.items()) for d in agenda_links}]
        return deduplicated_links

    except requests.exceptions.RequestException as e:
        logging.error(f"Error fetching Revize page {base_url} for {municipality_name}: {e}")
    except Exception as e:
        logging.error(f"Error parsing Revize page for {municipality_name}: {e}\n{traceback.format_exc()}")
    return []

def find_agenda_urls_municipal_one(base_url, municipality_name, config=None):
    """Finds agenda URLs for MunicipalOne sites (e.g., Troy)."""
    # Example Troy URL: https://www.cityoftroy.us/boards/meetings/30
    # Links are usually like: /apps/boards/meetings/viewdoc/agenda.ashx?meetingid=XXXX
    # The base_url provided might already be specific to a board (like City Council id=30)
    # Or it could be a more general page listing different boards.
    # This scraper assumes `base_url` leads to a page listing meetings for a specific board.
    
    agenda_links = []
    try:
        response = requests.get(base_url, timeout=30)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, "html.parser")

        # MunicipalOne typically lists meetings in a table or a series of divs.
        # Each meeting usually has a clear date and links to Agenda, Packet, Minutes.
        # The links often use .ashx handlers.

        # First, find links to different years, as data is often paginated or sectioned by year.
        # Example: <a href="/apps/boards/meetings/default.aspx?boardid=30&year=2024">2024 Meetings</a>
        year_links = []
        current_year = datetime.now().year
        year_links.append(base_url) # Current page (likely current year)
        
        # Look for links that explicitly navigate to other years for the same board
        board_id_match = re.search(r'boardid=(\d+)', base_url, re.I)
        if board_id_match:
            board_id = board_id_match.group(1)
            for year_tag in soup.find_all("a", href=re.compile(r'/apps/boards/meetings/default\.aspx\?boardid=' + board_id + r'&year=(\d{4})', re.I)):
                year_links.append(urljoin(base_url, year_tag['href']))
        else: # If no boardid in base_url, try a more generic year link search (less reliable)
             for year_tag in soup.find_all("a", href=re.compile(r'year=(\d{4})', re.I)):
                year_links.append(urljoin(base_url, year_tag['href']))
        
        # Deduplicate year_links
        processed_year_urls = set()
        
        for year_page_url in year_links:
            if year_page_url in processed_year_urls:
                continue
            processed_year_urls.add(year_page_url)

            logging.info(f"Processing year page: {year_page_url} for {municipality_name}")
            if year_page_url != base_url: # Fetch if it's a different year page
                try:
                    year_response = requests.get(year_page_url, timeout=30)
                    year_response.raise_for_status()
                    year_soup = BeautifulSoup(year_response.text, "html.parser")
                except requests.exceptions.RequestException as e:
                    logging.error(f"Error fetching year page {year_page_url} for {municipality_name}: {e}")
                    continue
            else:
                year_soup = soup # Use already fetched soup for the base_url

            # Find meeting entries - MunicipalOne often uses tables with class "meetings縞模様" or divs
            # Looking for rows or divs containing meeting details.
            # Troy uses: <div class="meeting">
            #   <div class="meetingdate">May 12, 2025 6:00 PM</div>
            #   <div class="meetingdescription">Regular Meeting</div>
            #   <div class="meetingdocuments">
            #       <a href="/apps/boards/meetings/viewdoc/agenda.ashx?meetingid=5867">...picture_as_pdf Agenda</a>
            #       <a href="/apps/boards/meetings/viewdoc/packet.ashx?meetingid=5867">...picture_as_pdf Packet</a>
            
            meeting_blocks = year_soup.select("div.meeting, tr.meetingrow") # Add other selectors if needed
            if not meeting_blocks: meeting_blocks = year_soup.find_all("div", class_=re.compile(r"meeting", re.I))


            for block in meeting_blocks:
                date_tag = block.find(class_=re.compile(r"meetingdate|datecolumn", re.I))
                if not date_tag: continue

                date_text = date_tag.get_text(strip=True)
                meeting_date_str = None
                # Example: May 12, 2025 6:00 PM
                date_match = re.search(r'([A-Za-z]+\s+\d{1,2},?\s+\d{4})', date_text)
                if date_match:
                    try:
                        parsed_date = datetime.strptime(date_match.group(1).replace(',', ''), "%B %d %Y")
                        meeting_date_str = parsed_date.strftime("%Y-%m-%d")
                    except ValueError:
                        try:
                            parsed_date = datetime.strptime(date_match.group(1).replace(',', ''), "%b %d %Y")
                            meeting_date_str = parsed_date.strftime("%Y-%m-%d")
                        except ValueError:
                            logging.warning(f"Could not parse date '{date_match.group(1)}' for {municipality_name}")
                            continue # Skip if date cannot be parsed
                
                if not meeting_date_str: continue

                # Filter by date (e.g., last year)
                parsed_dt = datetime.strptime(meeting_date_str, "%Y-%m-%d")
                one_year_ago = datetime.now() - timedelta(days=365)
                current_date_limit = datetime.now() + timedelta(days=7)
                if not (one_year_ago <= parsed_dt <= current_date_limit):
                    continue
                
                # Find agenda and packet links within this block
                doc_links_container = block.find(class_=re.compile(r"meetingdocuments|linkscolumn", re.I))
                if not doc_links_container: doc_links_container = block # Search within the whole block

                found_agenda_for_date = False
                for link_tag_doc in doc_links_container.find_all("a", href=True):
                    href_doc = link_tag_doc['href']
                    link_text_doc = link_tag_doc.get_text(strip=True).lower()

                    if "agenda.ashx" in href_doc.lower() or ("agenda" in link_text_doc and href_doc.lower().endswith('.pdf')):
                        full_url = urljoin(year_page_url, href_doc) # Use year_page_url as base
                        agenda_links.append({'url': full_url, 'date': meeting_date_str})
                        found_agenda_for_date = True
                        break # Found main agenda, prefer this. Add packet if separate logic needed.
                
                # Optionally, look for "packet" if no "agenda" link was found or if packets are always desired
                if not found_agenda_for_date: # Or if you always want packets too
                    for link_tag_doc in doc_links_container.find_all("a", href=True):
                        href_doc = link_tag_doc['href']
                        link_text_doc = link_tag_doc.get_text(strip=True).lower()
                        if "packet.ashx" in href_doc.lower() or ("packet" in link_text_doc and href_doc.lower().endswith('.pdf')):
                            full_url = urljoin(year_page_url, href_doc)
                            # Avoid adding if it's the same date and we already have an agenda (unless URLs differ)
                            # This simple append and deduplicate later is fine.
                            agenda_links.append({'url': full_url, 'date': meeting_date_str})
                            break


        logging.info(f"Found {len(agenda_links)} potential agenda/packet URLs for {municipality_name} (MunicipalOne).")
        deduplicated_links = [dict(t) for t in {tuple(d.items()) for d in agenda_links}]
        return deduplicated_links

    except requests.exceptions.RequestException as e:
        logging.error(f"Error fetching MunicipalOne page {base_url} for {municipality_name}: {e}")
    except Exception as e:
        logging.error(f"Error parsing MunicipalOne page for {municipality_name}: {e}\n{traceback.format_exc()}")
    return []
    
def find_agenda_urls_eztask_titanium(base_url, municipality_name, config=None):
    """Finds agenda URLs for ezTaskTitanium sites (e.g., Nolanville)."""
    # Example Nolanville URL: https://www.nolanvilletx.gov/page/city.agendas_minutes
    # Agendas are often grouped by year under tabs/accordions.
    # Links can be to a 'page/open/...' URL that then serves the PDF.

    agenda_links = []
    try:
        response = requests.get(base_url, timeout=30)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, "html.parser")

        # ezTaskTitanium sites often use specific panel/tab structures for years.
        # Example: <div class="panel panel-default"> <div class="panel-heading"> <h4 class="panel-title"><a ... href="#collapse2024">2024</a></h4> </div> ... </div>
        # Or content might be loaded, so look for year headers directly.
        
        current_year = datetime.now().year
        years_to_check = [str(current_year), str(current_year - 1)] # Current and previous year

        for year_str in years_to_check:
            # Find a header for the year (e.g., <h2>2024</h2> or a tab link)
            # This is a bit generic; specific config might be needed if structure varies wildly.
            year_header_tag = soup.find(['h1','h2','h3','h4','h5','a'], text=re.compile(r' ' + year_str + r' '))
            
            if not year_header_tag:
                logging.info(f"No section/header found for year {year_str} for {municipality_name} on {base_url}")
                continue

            logging.info(f"Processing year {year_str} for {municipality_name}")
            
            # Find the container of links associated with this year.
            # It could be the parent of the header, a sibling, or a target of an href (for tabs).
            content_container = None
            if year_header_tag.name == 'a' and year_header_tag.has_attr('href') and year_header_tag['href'].startswith('#'):
                # Tab-like structure, find the target div
                target_id = year_header_tag['href'][1:]
                content_container = soup.find(id=target_id)
            
            if not content_container: # If not a tab, assume links are near the header
                # Try to find a common parent or a sibling list/div that contains the links
                parent = year_header_tag.parent
                for _ in range(3): # Look up a few parents
                    if parent.find_all("a", href=True, text=re.compile(r'agenda|packet', re.I)):
                        content_container = parent
                        break
                    if parent.parent: parent = parent.parent
                    else: break
                if not content_container: content_container = year_header_tag.find_next_sibling()

            if not content_container:
                logging.warning(f"Could not identify link container for year {year_str} for {municipality_name}")
                content_container = soup # Fallback to whole page if no container found

            possible_links = content_container.find_all("a", href=True)

            for link_tag in possible_links:
                href = link_tag['href']
                link_text = link_tag.get_text(strip=True)

                # ezTaskTitanium links often look like: /page/open/DOC_ID/0/Meeting%20Agenda%20Date
                # Or direct PDFs.
                is_agenda_link = False
                if "/page/open/" in href and ("agenda" in link_text.lower() or "packet" in link_text.lower()):
                    is_agenda_link = True
                elif href.lower().endswith('.pdf') and ("agenda" in link_text.lower() or "packet" in link_text.lower() or "agenda" in href.lower()):
                    is_agenda_link = True
                
                if is_agenda_link:
                    full_url = urljoin(base_url, href)
                    meeting_date_str = None

                    # Attempt to extract date from link text
                    # Example: "Regular Council Meeting Agenda May 15th, 2025"
                    date_patterns = [
                        r'([A-Za-z]+\s+\d{1,2}(?:st|nd|rd|th)?,?\s+' + year_str + r')', # Month Day(th), YEAR (from context)
                        r'(\d{1,2}[-/]\d{1,2}[-/]' + year_str[2:] + r')', # MM/DD/YY (year from context)
                        r'(\d{1,2}[-/]\d{1,2}[-/]\d{4})', # MM/DD/YYYY
                        r'(' + year_str + r'-\d{1,2}-\d{1,2})' # YYYY-MM-DD
                    ]
                    found_date_text = None
                    for pattern in date_patterns:
                        date_match = re.search(pattern, link_text, re.I)
                        if date_match:
                            found_date_text = date_match.group(1)
                            break
                    
                    if found_date_text:
                        try:
                            parsed_date_obj = None
                            # Try common formats based on the matched pattern
                            if re.match(r'[A-Za-z]+\s+\d{1,2}(?:st|nd|rd|th)?,?\s+\d{4}', found_date_text, re.I):
                                clean_dt_str = re.sub(r'(\d+)(st|nd|rd|th)', r' ', found_date_text.replace(',', ''))
                                try: parsed_date_obj = datetime.strptime(clean_dt_str, "%B %d %Y")
                                except ValueError: parsed_date_obj = datetime.strptime(clean_dt_str, "%b %d %Y")
                            elif re.match(r'\d{1,2}[-/]\d{1,2}[-/]\d{2,4}', found_date_text):
                                parts = re.split(r'[-/]', found_date_text)
                                if len(parts[-1]) == 2: parsed_date_obj = datetime.strptime(found_date_text, "%m/%d/%y")
                                else: parsed_date_obj = datetime.strptime(found_date_text, "%m/%d/%Y")
                            elif re.match(r'\d{4}-\d{1,2}-\d{1,2}', found_date_text):
                                parsed_date_obj = datetime.strptime(found_date_text, "%Y-%m-%d")

                            if parsed_date_obj:
                                meeting_date_str = parsed_date_obj.strftime("%Y-%m-%d")
                        except ValueError as ve:
                            logging.warning(f"Date parse failed for '{found_date_text}' for {municipality_name}: {ve}")
                    
                    if meeting_date_str:
                        parsed_dt = datetime.strptime(meeting_date_str, "%Y-%m-%d")
                        one_year_ago = datetime.now() - timedelta(days=365)
                        current_date_limit = datetime.now() + timedelta(days=7)
                        if one_year_ago <= parsed_dt <= current_date_limit:
                            agenda_links.append({'url': full_url, 'date': meeting_date_str})
                    else:
                        logging.warning(f"Could not extract date for agenda: {link_text} ({full_url}) in {municipality_name}")

        logging.info(f"Found {len(agenda_links)} potential agenda URLs for {municipality_name} (ezTaskTitanium).")
        deduplicated_links = [dict(t) for t in {tuple(d.items()) for d in agenda_links}]
        return deduplicated_links

    except requests.exceptions.RequestException as e:
        logging.error(f"Error fetching ezTaskTitanium page {base_url} for {municipality_name}: {e}")
    except Exception as e:
        logging.error(f"Error parsing ezTaskTitanium page for {municipality_name}: {e}\n{traceback.format_exc()}")
    return []
def find_agenda_urls_custom_js(base_url, municipality_name, config=None):
    logging.warning(f"CustomJS scraper for {municipality_name} (e.g., Harker Heights) requires browser automation and is not supported by this basic scraper.")
    return []
def find_agenda_urls_robots_blocked(base_url, municipality_name, config=None):
    logging.warning(f"Scraping for {municipality_name} ({base_url}) is disallowed by robots.txt. Skipping.")
    return []
def find_agenda_urls_municipalimpact(base_url, municipality_name, config=None):
    """Finds agenda URLs for MunicipalImpact sites (e.g., Holland)."""
    # Example Holland URL: https://www.cityofholland.org/agendas
    # Links are typically under headings for years, e.g., "2024 City Council Meeting Agendas"
    # PDFs are often in a "/documents/DOC_ID/filename.pdf?timestamp" format

    agenda_links = []
    try:
        response = requests.get(base_url, timeout=30)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, "html.parser")

        current_year = datetime.now().year
        years_to_check = [str(current_year), str(current_year - 1)] # Current and previous year

        for year_str in years_to_check:
            # Find headers for the year, e.g., <h3>2024 City Council Meeting Agendas</h3>
            # Or any element containing the year and "Agendas"
            year_header_candidates = soup.find_all(['h1','h2','h3','h4','h5','p','strong'], 
                                                   text=re.compile(r' ' + year_str + r' .*(Agenda|Meeting)', re.I))
            
            if not year_header_candidates:
                logging.info(f"No section/header found for year {year_str} for {municipality_name} on {base_url}")
                continue

            for year_header_tag in year_header_candidates:
                logging.info(f"Processing year section for {year_str} under header: '{year_header_tag.get_text(strip=True)}' for {municipality_name}")
                
                # Find the list or container of links that follows this header.
                # This often involves looking at siblings or the parent's next siblings.
                container = year_header_tag.find_next_sibling()
                ul_dl_ol_found = False
                if container:
                    if container.name in ['ul', 'dl', 'ol']: # Check if it's a list directly
                        ul_dl_ol_found = True
                    else: # Check if it contains a list
                        list_in_container = container.find(['ul', 'dl', 'ol'])
                        if list_in_container:
                            container = list_in_container
                            ul_dl_ol_found = True
                
                if not container or not ul_dl_ol_found : # If no list found, try searching links more broadly from header's parent
                    container = year_header_tag.parent 
                    if not container: continue # Should not happen if header exists

                possible_links = container.find_all("a", href=True)

                for link_tag in possible_links:
                    href = link_tag['href']
                    link_text = link_tag.get_text(strip=True)

                    # Filter for PDF links that seem like agendas
                    # MunicipalImpact links often contain "/documents/" and end in .pdf
                    if not (href.lower().endswith('.pdf') and ("/documents/" in href.lower() or "agenda" in link_text.lower())):
                        continue
                    
                    # Further filter out common non-agenda PDFs if possible
                    if any(skip_text in href.lower() for skip_text in ['logo', 'event-calendar', 'newsletter']):
                        continue
                    if any(skip_text in link_text.lower() for skip_text in ['minutes', 'newsletter', 'calendar']) and not ("agenda" in link_text.lower() or "hearing" in link_text.lower()):
                        continue

                    full_url = urljoin(base_url, href)
                    meeting_date_str = None

                    # Date extraction: Holland has dates like "05-12-2025 Regular City Council Meeting Agenda" in link text
                    date_patterns = [
                        r'(\d{1,2}-\d{1,2}-\d{4})',  # MM-DD-YYYY (primary for Holland in link text)
                        r'(\d{1,2}/\d{1,2}/\d{2,4})',  # MM/DD/YYYY or MM/DD/YY
                        r'([A-Za-z]+\s+\d{1,2},?\s+\d{4})' # Month Day, Year
                    ]
                    
                    found_date_text = None
                    for pattern in date_patterns:
                        date_match = re.search(pattern, link_text)
                        if date_match:
                            found_date_text = date_match.group(1)
                            break
                    
                    if found_date_text:
                        try:
                            parsed_date_obj = None
                            if re.match(r'\d{1,2}-\d{1,2}-\d{4}', found_date_text): 
                                parsed_date_obj = datetime.strptime(found_date_text, "%m-%d-%Y")
                            elif re.match(r'\d{1,2}/\d{1,2}/\d{4}', found_date_text): 
                                parsed_date_obj = datetime.strptime(found_date_text, "%m/%d/%Y")
                            elif re.match(r'\d{1,2}/\d{1,2}/\d{2}', found_date_text): 
                                parsed_date_obj = datetime.strptime(found_date_text, "%m/%d/%y")
                            elif re.match(r'[A-Za-z]+\s+\d{1,2},?\s+\d{4}', found_date_text):
                                clean_dt_str = re.sub(r'(\d+)(st|nd|rd|th)', r' ', found_date_text.replace(',', ''))
                                try: parsed_date_obj = datetime.strptime(clean_dt_str, "%B %d %Y")
                                except ValueError: parsed_date_obj = datetime.strptime(clean_dt_str, "%b %d %Y")
                            
                            if parsed_date_obj:
                                meeting_date_str = parsed_date_obj.strftime("%Y-%m-%d")
                        except ValueError as ve:
                            logging.warning(f"Date parse failed for '{found_date_text}' for {municipality_name}: {ve}")
                    
                    if meeting_date_str:
                        parsed_dt = datetime.strptime(meeting_date_str, "%Y-%m-%d")
                        one_year_ago = datetime.now() - timedelta(days=365)
                        current_date_limit = datetime.now() + timedelta(days=7)
                        if one_year_ago <= parsed_dt <= current_date_limit:
                            if "agenda" in link_text.lower() or "hearing" in link_text.lower(): # Extra check on link text
                                agenda_links.append({'url': full_url, 'date': meeting_date_str})
                    else:
                        logging.warning(f"Could not extract date for agenda: {link_text} ({full_url}) in {municipality_name}")

        logging.info(f"Found {len(agenda_links)} potential agenda URLs for {municipality_name} (MunicipalImpact).")
        deduplicated_links = [dict(t) for t in {tuple(d.items()) for d in agenda_links}]
        return deduplicated_links

    except requests.exceptions.RequestException as e:
        logging.error(f"Error fetching MunicipalImpact page {base_url} for {municipality_name}: {e}")
    except Exception as e:
        logging.error(f"Error parsing MunicipalImpact page for {municipality_name}: {e}\n{traceback.format_exc()}")
    return []

SCRAPER_DISPATCH = {
    'Legistar': find_agenda_urls_legistar,
    'Municode': find_agenda_urls_municode,
    'CivicPlus': find_agenda_urls_civicplus,
    'WordPress': find_agenda_urls_wordpress,
    'Revize': find_agenda_urls_revize, 
    'MunicipalOne': find_agenda_urls_municipal_one, 
    'ezTaskTitanium': find_agenda_urls_eztask_titanium, 
    'CustomJS': find_agenda_urls_custom_js, 
    'RobotsBlocked': find_agenda_urls_robots_blocked,
    'MunicipalImpact': find_agenda_urls_municipalimpact, # Added for Holland
}

# --- PDF Parsing ---
def download_and_parse_agenda(pdf_url, municipality_name, config_json=None):
    """Downloads a PDF agenda, parses it, and extracts items."""
    items = []
    config = {}
    if isinstance(config_json, str): 
        try: config = json.loads(config_json)
        except json.JSONDecodeError: logging.warning(f"Could not parse config JSON for {municipality_name}: {config_json}")
    elif isinstance(config_json, dict): config = config_json
    try:
        response = requests.get(pdf_url, timeout=30); response.raise_for_status()
        import io; pdf_file = io.BytesIO(response.content)
        with pdfplumber.open(pdf_file) as pdf:
            full_text_lines = []
            for page_num, page in enumerate(pdf.pages):
                page_text = page.extract_text()
                if page_text: full_text_lines.extend(page_text.split('\n'))
                else: logging.warning(f"Page {page_num + 1} of {pdf_url} for {municipality_name} had no extractable text.")
            text_content = '\n'.join(full_text_lines)
        if not text_content.strip(): logging.warning(f"No text content extracted from PDF: {pdf_url} for {municipality_name}"); return []
        start_marker_regex = config.get('pdf_start_marker', r'(Presentations|Consent Agenda|Regular Session|Items for Discussion at Workshop|Approval of Minutes)')
        end_marker_regex = config.get('pdf_end_marker', r'Adjournment')
        item_prefix_regex_str = config.get('item_prefix_regex', r'^((\d+\.)?\s*([A-Za-z]+)-\d{2}-\d{2,3}\s+(.*))')
        default_known_headings = ["Presentations", "Discussion Items", "Consent Agenda", "Public Hearings","Executive Session", "Items for Discussion at Workshop", "Approval of Minutes", "Agenda Items","New Business", "Old Business", "Resolutions", "Ordinances"]
        known_headings = config.get('known_headings', default_known_headings)
        text_to_parse = text_content
        start_match = re.search(start_marker_regex, text_to_parse, re.IGNORECASE)
        if start_match: text_to_parse = text_to_parse[start_match.start():]
        end_match = re.search(end_marker_regex, text_to_parse, re.IGNORECASE)
        if end_match: text_to_parse = text_to_parse[:end_match.start()]
        def is_heading_func(line_text, headings_list):
            line_clean = ' '.join(line_text.strip().split()).lower()
            for heading_text in headings_list:
                if heading_text.lower() in line_clean: return heading_text 
            return None
        current_heading = "General"; current_item_details = None; parsed_lines = text_to_parse.split('\n')
        for line_text in parsed_lines:
            line_text = line_text.strip();
            if not line_text: continue
            heading = is_heading_func(line_text, known_headings)
            if heading:
                if current_item_details: 
                    desc = ' '.join(current_item_details['lines']).strip(); desc = re.split(r'Attachments:', desc, flags=re.IGNORECASE)[0].strip()
                    if desc: items.append((current_item_details['heading'], current_item_details['file_prefix'], desc))
                    current_item_details = None
                current_heading = heading; continue 
            item_match = None
            if item_prefix_regex_str: 
                try: item_match = re.match(item_prefix_regex_str, line_text)
                except re.error as re_err: logging.warning(f"Invalid item_prefix_regex '{item_prefix_regex_str}' for {municipality_name}: {re_err}"); item_prefix_regex_str = None 
            if item_match:
                if current_item_details: 
                    desc = ' '.join(current_item_details['lines']).strip(); desc = re.split(r'Attachments:', desc, flags=re.IGNORECASE)[0].strip()
                    if desc: items.append((current_item_details['heading'], current_item_details['file_prefix'], desc))
                file_prefix = item_match.group(3) if len(item_match.groups()) >= 3 and item_match.group(3) else None
                description_start = item_match.group(4).strip() if len(item_match.groups()) >= 4 and item_match.group(4) else line_text
                current_item_details = {'file_prefix': file_prefix, 'lines': [description_start], 'heading': current_heading}
            elif current_item_details: current_item_details['lines'].append(line_text)
        if current_item_details: 
            desc = ' '.join(current_item_details['lines']).strip(); desc = re.split(r'Attachments:', desc, flags=re.IGNORECASE)[0].strip()
            if desc: items.append((current_item_details['heading'], current_item_details['file_prefix'], desc))
        logging.info(f"Parsed {len(items)} items from {pdf_url} for {municipality_name}.")
    except requests.exceptions.RequestException as e: logging.error(f"Error downloading PDF {pdf_url} for {municipality_name}: {e}")
    except pdfplumber.pdfminer.pdfdocument.PDFEncryptionError as e: logging.error(f"PDFEncryptionError for {pdf_url} ({municipality_name}): {e}.")
    except Exception as e: logging.error(f"Error parsing PDF {pdf_url} for {municipality_name}: {e}\n{traceback.format_exc()}")
    return items

# --- Categorization ---
PRIORITY_ORDER = ["Minutes", "Zoning", "Taxes", "Grants", "Contracts", "Budget", "Regulations", "Plans", "Parks", "Personnel", "Elections", "Litigation", "Recognition", "EDC", "Government Policy", "Intergovernmental", "ETJ", "AAR", "Audit", "Judicial", "Bylaws", "City Charter", "Infrastructure", "Public Safety", "Community Development", "Information Only", "Utilities", "Public Hearings"]
CATEGORIES = {
    "Minutes": ["minutes", "consider minutes"], "Zoning": ["rezone", "zoning", "land use", "PUD", "planned unit development", "plat", "subdivision"],
    "Taxes": [r"\btax\b", "levy", "assessment", "exemption", "tax rate", "ad valorem", "bond", "tax-exempt", "millage"],
    "Grants": ["grant", "funding request", "funding update", "allocation", "award", "subsidy", "ARPA", "consider funding"],
    "Contracts": ["authorizing", "request for proposal", "RFP", "bid", "contract", "agreement", "lease", "purchase", "procurement", r"amount of \$", r"amount not to exceed \$", "change order", "selecting", "MOU", "memorandum of understanding", "professional services"],
    "Budget": ["budget", "financial report", "investment report", "fiscal", "revenue", "expense", "CIP", "capital improvement program", "appropriation", "fund balance", "transfer of funds"],
    "Regulations": ["rules", "regulations", "ordinance", "code", "standard", "amending chapter", "policy", "resolution"], 
    "Plans": ["comprehensive plan", "strategic plan", "master plan", "thoroughfare plan", "conservation plan", "program", "study", "action plan"],
    "Parks": ["park", "golf", "recreation", "trail", "playground", "library", "community center"],
    "Personnel": ["appointment", "resignation", "appointing", "nominating", "pay increase", "hiring", "evaluation", "commission", "board", "electing", "employee", "staff", "salary", "compensation", "benefits"],
    "Elections": ["election", "recall", "ballot", "vote", "canvassing", "polling place"],
    "Litigation": ["litigation", "v\.", "lawsuit", "legal action", "settlement", "claim", "attorney general"],
    "Recognition": ["recognition", "award", "recognizing", "certificate", "oath of office", "proclamation", "commendation", "presentation to"],
    "EDC": ["economic development corporation", "EDC", "KEDC", "MEDC", "development agreement"], 
    "Government Policy": ["policy", "protocol", "governance", "standards", "legislative priorities", "meeting schedule", "city council workshops", "rules of procedure", "code of conduct"],
    "Intergovernmental": ["district", "alliance", "interlocal", "intergovernmental agreement", "county", "state", "federal"],
    "ETJ": ["extraterritorial jurisdiction", "ETJ", "release from", "annexation"], "AAR": ["after action review", "AAR"],
    "Audit": ["audit", "auditing", "auditor", "annual financial report", "AFR", "CAFR"], "Judicial": ["judge", "court", "judicial", "municipal court", "magistrate"],
    "Bylaws": ["bylaws", "rules of procedure", "charter amendments"], "City Charter": ["city charter", "charter review", "charter amendment"],
    "Infrastructure": ["infrastructure", "construction", "improvement project", "reconstruction", "road", "street", "bridge", "sewer", "water line", "drainage", "sidewalk", "transportation", "traffic", "signal", "public works project"],
    "Public Safety": ["police", "fire", "emergency", "safety", "crime", "law enforcement", "fire department", "EMS", "disaster", "emergency management", "ambulance"],
    "Community Development": ["development", "housing", "community", "revitalization", "neighborhood", "CDBG"],
    "Information Only": ["presentation", "update", "briefing", "report", "overview", "discussion", "workshop item", "status report", "receive report"],
    "Utilities": ["fee schedule", "water rate", "sewer rate", "utility", "solid waste", "electricity", "gas", "franchise agreement"],
    "Public Hearings": ["public hearing"] 
}
def categorize_item(item_description, categories_map, priority_list):
    item_lower = item_description.lower()
    for category_name in priority_list:
        keywords = categories_map.get(category_name, [])
        for keyword_pattern in keywords:
            try:
                if re.search(keyword_pattern, item_lower):
                    if category_name == "Taxes" and "election" in item_lower and not any(k in item_lower for k in ["tax rate", "levy"]): continue
                    if category_name == "Grants" and any(k in item_lower for k in ["contract", "procurement", "purchase"]) and "grant" not in item_lower: continue
                    if category_name == "Budget" and any(k in item_lower for k in ["audit", "judge", "court"]): continue
                    return category_name 
            except re.error as e: logging.warning(f"Regex error for keyword '{keyword_pattern}' in category '{category_name}': {e}")
    return "Other"

# --- Database Storage ---
def get_or_create_agenda_record(conn, municipality_id, meeting_date_str, pdf_url_str):
    with conn.cursor() as cur:
        cur.execute("SELECT id FROM agendas WHERE municipality_id = %s AND date = %s AND pdf_url = %s", (municipality_id, meeting_date_str, pdf_url_str))
        result = cur.fetchone()
        if result: agenda_id = result['id']; logging.info(f"Found existing agenda ID: {agenda_id} for mun_id {municipality_id}, date {meeting_date_str}"); return agenda_id, False
        else:
            cur.execute("INSERT INTO agendas (municipality_id, date, pdf_url) VALUES (%s, %s, %s) RETURNING id", (municipality_id, meeting_date_str, pdf_url_str))
            agenda_id = cur.fetchone()['id']; conn.commit(); logging.info(f"Created new agenda ID: {agenda_id} for mun_id {municipality_id}, date {meeting_date_str}"); return agenda_id, True
def store_agenda_items(conn, agenda_id, parsed_items):
    items_added_count = 0
    with conn.cursor() as cur:
        for heading, file_prefix, description in parsed_items:
            if not description: logging.warning(f"Skipping item with empty description for agenda_id {agenda_id}, heading '{heading}'"); continue
            category = categorize_item(description, CATEGORIES, PRIORITY_ORDER)
            try:
                cur.execute("INSERT INTO agenda_items (agenda_id, heading, file_prefix, item_text, category) VALUES (%s, %s, %s, %s, %s) ON CONFLICT ON CONSTRAINT unique_agenda_item_text DO NOTHING", (agenda_id, heading, file_prefix, description, category))
                if cur.rowcount > 0: items_added_count +=1
            except psycopg2.Error as e: logging.error(f"DB error storing item for agenda_id {agenda_id}: '{description[:100]}...'. Error: {e}"); conn.rollback()
            else: conn.commit() 
    logging.info(f"Added {items_added_count} new items for agenda_id {agenda_id}.")

# --- Main Processing Logic ---
def process_municipality_agendas(db_conn, municipality_record):
    mun_id = municipality_record['id']; mun_name = municipality_record['name']; base_url = municipality_record['agenda_url']
    scraper_type = municipality_record['scraper_type']; config = municipality_record['config'] 
    logging.info(f"Processing agendas for {mun_name} (ID: {mun_id}, Type: {scraper_type})...")
    scraper_function = SCRAPER_DISPATCH.get(scraper_type)
    if not scraper_function: logging.error(f"No scraper function for type '{scraper_type}' for {mun_name}."); return
    agenda_url_infos = scraper_function(base_url, mun_name, config)
    if not agenda_url_infos: logging.info(f"No new agenda URLs found for {mun_name}."); return
    for agenda_info in agenda_url_infos:
        pdf_url = agenda_info['url']; meeting_date = agenda_info['date'] 
        try:
            agenda_id, is_new_agenda = get_or_create_agenda_record(db_conn, mun_id, meeting_date, pdf_url)
            if is_new_agenda: 
                logging.info(f"Processing new agenda: {pdf_url} for {mun_name} on {meeting_date}")
                parsed_items = download_and_parse_agenda(pdf_url, mun_name, config)
                if parsed_items: store_agenda_items(db_conn, agenda_id, parsed_items)
                else: logging.info(f"No items parsed from {pdf_url} for {mun_name}.")
            else: logging.info(f"Agenda {pdf_url} for {mun_name} on {meeting_date} already processed.")
        except Exception as e:
            logging.error(f"Error processing agenda {pdf_url} for {mun_name}: {e}\n{traceback.format_exc()}")
            try: db_conn.rollback()
            except psycopg2.InterfaceError: pass
    try:
        with db_conn.cursor() as cur: cur.execute("UPDATE municipalities SET last_scraped_at = %s WHERE id = %s", (datetime.now(), mun_id))
        db_conn.commit()
    except Exception as e: logging.error(f"Error updating last_scraped_at for {mun_name}: {e}"); db_conn.rollback()

def main_scraper_job(event=None, context=None): 
    if event or context: logging.info(f"Cloud Function triggered. Event: {event}, Context: {context}")
    logging.info("Starting main scraper job..."); db_conn = None
    try:
        db_conn = get_db_connection()
        with db_conn.cursor() as cur:
            cur.execute("SELECT id, name, agenda_url, scraper_type, config FROM municipalities WHERE is_active = TRUE AND (last_scraped_at IS NULL OR last_scraped_at < NOW() - INTERVAL '23 hours')")
            active_municipalities = cur.fetchall()
        if not active_municipalities: logging.info("No active municipalities found or recently scraped."); return
        for municipality_record in active_municipalities:
            process_municipality_agendas(db_conn, municipality_record)
            time.sleep(2) 
    except Exception as e: logging.error(f"Critical error in main_scraper_job: {e}\n{traceback.format_exc()}")
    finally:
        if db_conn: db_conn.close(); logging.info("Database connection closed.")
    logging.info("Main scraper job finished.")

if __name__ == "__main__":
    logging.info("Running scraper.py directly for local testing.")
    main_scraper_job()
