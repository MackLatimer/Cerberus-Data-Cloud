#!/bin/sh
set -e

CAMPAIGNS="emmons blair cox gauntt mintz tice leudeke tulloch whitson"
INDEX_FILE="web/index.html"
INDEX_FILE_BACKUP="${INDEX_FILE}.bak"

# Backup original index.html
if [ -f "$INDEX_FILE" ]; then
  cp "$INDEX_FILE" "$INDEX_FILE_BACKUP"
fi

# Restore backup on exit
trap 'mv -f "$INDEX_FILE_BACKUP" "$INDEX_FILE"' EXIT HUP INT QUIT PIPE TERM

for campaign in $CAMPAIGNS
do
  echo "Building campaign: $campaign"
  CONFIG_FILE="assets/${campaign}_config.json"
  cp "$CONFIG_FILE" "assets/default_config.json"

  if [ -f "$CONFIG_FILE" ]; then
    SITE_TITLE=$(jq -r '.content.siteTitle' "$CONFIG_FILE")
    echo "Site title: $SITE_TITLE"

    # Restore original index.html for modification
    cp "$INDEX_FILE_BACKUP" "$INDEX_FILE"
    
    # Replace title
    sed -i "s|<title>.*</title>|<title>$SITE_TITLE</title>|" "$INDEX_FILE"
  fi

  flutter build web --release
  npx firebase-tools deploy --only "hosting:${campaign}" --project "cerberus-data-cloud"
done

echo "All campaigns built and deployed."
