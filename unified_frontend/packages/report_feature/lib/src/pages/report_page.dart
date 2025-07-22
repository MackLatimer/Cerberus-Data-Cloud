import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' show min; // For substring
import 'package:intl/intl.dart'; // For date formatting
import 'package:url_launcher/url_launcher.dart'; // For PDF links
import 'package:report_feature/src/models/agenda_item.dart';
import 'package:shared_ui/shared_ui.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<AgendaItem> _agendaItems = [];
  bool _isLoading = true;
  String? _error;

  // Search and filter state variables
  String _searchKeyword = '';
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  String? _selectedHeading;
  String? _selectedMunicipality;
  String? _selectedCategory;

  // Data for dropdowns
  List<String> _headings = [];
  List<String> _municipalities = [];
  List<String> _categories = [];

  // Loading states for dropdown data
  bool _isLoadingHeadings = false;
  bool _isLoadingMunicipalities = false;
  bool _isLoadingCategories = false;

  // Error states for dropdown data
  String? _errorHeadings;
  String? _errorMunicipalities;
  String? _errorCategories;

  // Email subscription state variables
  final _emailController = TextEditingController();
  bool _isSubscribing = false;

  // ExpansionTile states
  bool _isFilterExpanded = false;
  bool _isSubscribeExpanded = false;

// ...

  // Base URL for the local api.py.
  final String _apiBaseUrl = apiBaseUrl;
  final String _searchEndpoint = '/search';

  @override
  void initState() {
    super.initState();
    _fetchReportData();
    _fetchHeadings();
    _fetchMunicipalities();
    _fetchCategories();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String? urlString) async {
    if (urlString == null || urlString.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF URL is not available.')),
      );
      return;
    }
    final Uri uri = Uri.parse(urlString);
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $urlString')),
      );
    }
  }

  Future<void> _fetchReportData() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _agendaItems = []; // Clear previous items
    });

    Map<String, String> queryParams = {};

    // Add search keyword
    if (_searchKeyword.isNotEmpty) {
      queryParams['keyword'] = _searchKeyword;
    }

    // Add selected start date
    if (_selectedStartDate != null) {
      queryParams['start_date'] = DateFormat('yyyy-MM-dd').format(_selectedStartDate!);
    }

    // Add selected end date
    if (_selectedEndDate != null) {
      queryParams['end_date'] = DateFormat('yyyy-MM-dd').format(_selectedEndDate!);
    }

    // Add selected heading
    if (_selectedHeading != null && _selectedHeading!.isNotEmpty) {
      queryParams['heading'] = _selectedHeading!;
    }

    // Add selected municipality
    if (_selectedMunicipality != null && _selectedMunicipality!.isNotEmpty) {
      queryParams['municipality'] = _selectedMunicipality!;
    }

    // Add selected category
    if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
      queryParams['category'] = _selectedCategory!;
    }

    try {
      // If running Flutter Web and api.py (Flask) backend shows CORS errors,
      // ensure the Flutter app's origin (e.g., http://localhost:PORT_FLUTTER_IS_USING)
      // is included in the `origins` list for CORS in `api.py`.
      // Example: origins=["http://localhost:8080", "http://localhost:PORT_FLUTTER_IS_USING"]
      // Or, run Flutter on an allowed port if specified in api.py's CORS setup (e.g. 8080)

      Uri uri = Uri.parse('$_apiBaseUrl$_searchEndpoint').replace(queryParameters: queryParams.isEmpty ? null : queryParams);
      // print('Fetching data from URI: $uri'); // For debugging

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          _agendaItems = jsonData.map((item) => AgendaItem.fromJson(item)).toList();
          _error = null;
        });
      } else {
        setState(() {
          _error = 'Failed to load agenda items. Status code: ${response.statusCode}. Response: ${response.body}. URI: $uri';
        });
      }
    } catch (e) {
      setState(() {
        // It's good practice to also log the URI that caused the error for easier debugging.
        // However, queryParams might contain sensitive info depending on the app, so be cautious.
        // For this example, we'll assume it's okay for debugging.
        Uri constructedUri = Uri.parse('$_apiBaseUrl$_searchEndpoint').replace(queryParameters: queryParams.isEmpty ? null : queryParams);
        _error = 'Failed to connect to the server. Please check your connection and ensure the local backend (api.py) is running. URI: $constructedUri. Details: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchHeadings() async {
    setState(() {
      _isLoadingHeadings = true;
      _errorHeadings = null;
    });
    try {
      final response = await http.get(Uri.parse('$_apiBaseUrl/headings'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          _headings = jsonData.cast<String>().toList();
          _errorHeadings = null;
        });
      } else {
        setState(() {
          _errorHeadings = 'Failed to load headings. Status code: ${response.statusCode}.';
          _headings = [];
        });
      }
    } catch (e) {
      setState(() {
        _errorHeadings = 'Error fetching headings: $e';
        _headings = [];
      });
    } finally {
      setState(() {
        _isLoadingHeadings = false;
      });
    }
  }

  Future<void> _fetchMunicipalities() async {
    setState(() {
      _isLoadingMunicipalities = true;
      _errorMunicipalities = null;
    });
    try {
      final response = await http.get(Uri.parse('$_apiBaseUrl/municipalities'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          _municipalities = jsonData.cast<String>().toList();
          _errorMunicipalities = null;
        });
      } else {
        setState(() {
          _errorMunicipalities = 'Failed to load municipalities. Status code: ${response.statusCode}.';
          _municipalities = [];
        });
      }
    } catch (e) {
      setState(() {
        _errorMunicipalities = 'Error fetching municipalities: $e';
        _municipalities = [];
      });
    } finally {
      setState(() {
        _isLoadingMunicipalities = false;
      });
    }
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _isLoadingCategories = true;
      _errorCategories = null;
    });
    try {
      final response = await http.get(Uri.parse('$_apiBaseUrl/categories'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          _categories = jsonData.cast<String>().toList();
          _errorCategories = null;
        });
      } else {
        setState(() {
          _errorCategories = 'Failed to load categories. Status code: ${response.statusCode}.';
          _categories = [];
        });
      }
    } catch (e) {
      setState(() {
        _errorCategories = 'Error fetching categories: $e';
        _categories = [];
      });
    } finally {
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _searchKeyword = '';
      _selectedStartDate = null;
      _selectedEndDate = null;
      _selectedHeading = null;
      _selectedMunicipality = null;
      _selectedCategory = null;
    });
    _fetchReportData(); // Reload data with no filters
  }

  Future<void> _subscribeToUpdates() async {
    if (!mounted) return; // Check if the widget is still in the tree

    setState(() {
      _isSubscribing = true;
    });

    Map<String, dynamic> filterSettings = {};
    if (_searchKeyword.isNotEmpty) {
      filterSettings['keyword'] = _searchKeyword;
    }
    if (_selectedStartDate != null) {
      filterSettings['start_date'] = DateFormat('yyyy-MM-dd').format(_selectedStartDate!);
    }
    if (_selectedEndDate != null) {
      filterSettings['end_date'] = DateFormat('yyyy-MM-dd').format(_selectedEndDate!);
    }
    if (_selectedHeading != null && _selectedHeading!.isNotEmpty) {
      filterSettings['heading'] = _selectedHeading!;
    }
    if (_selectedMunicipality != null && _selectedMunicipality!.isNotEmpty) {
      filterSettings['municipality'] = _selectedMunicipality!;
    }
    if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
      filterSettings['category'] = _selectedCategory!;
    }

    String email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid email address.'), backgroundColor: Colors.red),
        );
        setState(() {
          _isSubscribing = false;
        });
      }
      return;
    }

    Map<String, dynamic> body = {'email': email, 'filter_settings': filterSettings};

    try {
      final response = await http.post(
        Uri.parse('$_apiBaseUrl/subscribe'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (!mounted) return; // Check again after async operation

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Subscribed successfully! You'll receive emails when new items match your filters."), backgroundColor: Colors.green),
        );
        _emailController.clear();
      } else {
        String message = 'Subscription failed.';
        try {
          final errorData = jsonDecode(response.body);
          message = errorData['error'] ?? errorData['message'] ?? message;
        } catch (_) {
          // Ignore if response body is not JSON or doesn't have error/message
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Subscription failed: $message. Status: ${response.statusCode}'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return; // Check again after async operation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to subscribe. Check your connection or try again later. Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubscribing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget resultsContent;

    if (_isLoading) {
      resultsContent = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      resultsContent = Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!, textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 16)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchReportData,
                child: const Text('Retry'),
              )
            ],
          ),
        ),
      );
    } else if (_agendaItems.isEmpty) {
      resultsContent = const Center(child: Text('No agenda items found. Apply filters or broaden your search.'));
    } else {
      resultsContent = ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _agendaItems.length,
        itemBuilder: (context, index) {
          final item = _agendaItems[index];
          String formattedDate = item.date != null
              ? DateFormat('yyyy-MM-dd').format(item.date!)
              : 'N/A';
          String itemTextSnippet = item.itemText != null
              ? (item.itemText!.substring(0, min(150, item.itemText!.length)) + (item.itemText!.length > 150 ? '...' : ''))
              : 'No text available.';

          return Card(
            elevation: 2.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.heading ?? 'No Heading',
                     style: Theme.of(context).textTheme.titleLarge, // Removed bold, rely on theme
                  ),
                   const SizedBox(height: 12.0), // Increased spacing
                  Row(
                    children: [
                       Icon(Icons.calendar_today_rounded, size: 16.0, color: Theme.of(context).textTheme.bodySmall?.color), // Updated icon
                      const SizedBox(width: 4.0),
                      Text('Date: $formattedDate', style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(width: 16.0),
                       Icon(Icons.location_city_rounded, size: 16.0, color: Theme.of(context).textTheme.bodySmall?.color), // Updated icon
                      const SizedBox(width: 4.0),
                      Expanded(child: Text('Municipality: ${item.municipality ?? 'N/A'}', style: Theme.of(context).textTheme.bodySmall)),
                    ],
                  ),
                  if (item.category != null && item.category!.isNotEmpty) ...[
                     const SizedBox(height: 8.0), // Increased spacing
                     Row(
                       children: [
                          Icon(Icons.category_rounded, size: 16.0, color: Theme.of(context).textTheme.bodySmall?.color), // Updated icon
                         const SizedBox(width: 4.0),
                         Text('Category: ${item.category}', style: Theme.of(context).textTheme.bodySmall),
                       ],
                     ),
                  ],
                  const SizedBox(height: 12.0),
                  Text(
                    itemTextSnippet,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),
                  if (item.pdfUrl != null && item.pdfUrl!.isNotEmpty) ...[
                    const SizedBox(height: 12.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                         icon: Icon(Icons.picture_as_pdf_rounded, color: Theme.of(context).colorScheme.secondary), // Updated icon
                        label: Text(
                          'View PDF',
                           style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w500 // Ensure weight is explicitly w500 if not default for labelLarge
                           ),
                        ),
                        onPressed: () => _launchUrl(item.pdfUrl),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      );
    }

    // Define a helper for date picker buttons
    Widget _buildDatePickerButton({
      required String title,
      required DateTime? selectedDate,
      required Function(DateTime) onDateSelected,
    }) {
      return ElevatedButton(
        onPressed: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (picked != null && picked != selectedDate) {
            setState(() {
              onDateSelected(picked);
            });
          }
        },
        child: Text(selectedDate == null ? title : DateFormat('yyyy-MM-dd').format(selectedDate)),
      );
    }

    Widget filterUISection = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            onChanged: (value) {
              setState(() {
                _searchKeyword = value;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Search by keyword',
              // border: OutlineInputBorder(), // Will use from theme
              suffixIcon: Icon(Icons.search_rounded), // Updated icon
            ),
          ),
          const SizedBox(height: 16.0), // Increased spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: _buildDatePickerButton(
                  title: 'Start Date',
                  selectedDate: _selectedStartDate,
                  onDateSelected: (date) => _selectedStartDate = date,
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: _buildDatePickerButton(
                  title: 'End Date',
                  selectedDate: _selectedEndDate,
                  onDateSelected: (date) => _selectedEndDate = date,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0), // Increased spacing
          // Heading Dropdown
          _isLoadingHeadings
              ? const Center(child: CircularProgressIndicator())
              : _errorHeadings != null
                  ? Text('Error loading headings: $_errorHeadings', style: TextStyle(color: Theme.of(context).colorScheme.error))
                  : DropdownButtonFormField<String>(
                      value: _selectedHeading,
                      decoration: const InputDecoration(labelText: 'Filter by Heading', border: OutlineInputBorder()),
                      hint: const Text('All Headings'),
                      isExpanded: true,
                      items: [
                        const DropdownMenuItem<String>(value: null, child: Text('All Headings')),
                        ..._headings.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedHeading = newValue;
                        });
                      },
                    ),
          const SizedBox(height: 16.0), // Increased spacing
          // Municipality Dropdown
          _isLoadingMunicipalities
              ? const Center(child: CircularProgressIndicator())
              : _errorMunicipalities != null
                  ? Text('Error loading municipalities: $_errorMunicipalities', style: TextStyle(color: Theme.of(context).colorScheme.error))
                  : DropdownButtonFormField<String>(
                      value: _selectedMunicipality,
                      decoration: const InputDecoration(labelText: 'Filter by Municipality', border: OutlineInputBorder()),
                      hint: const Text('All Municipalities'),
                      isExpanded: true,
                      items: [
                        const DropdownMenuItem<String>(value: null, child: Text('All Municipalities')),
                        ..._municipalities.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedMunicipality = newValue;
                        });
                      },
                    ),
          const SizedBox(height: 16.0), // Increased spacing
          // Category Dropdown
          _isLoadingCategories
              ? const Center(child: CircularProgressIndicator())
              : _errorCategories != null
                  ? Text('Error loading categories: $_errorCategories', style: TextStyle(color: Theme.of(context).colorScheme.error))
                  : DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(labelText: 'Filter by Category', border: OutlineInputBorder()),
                      hint: const Text('All Categories'),
                      isExpanded: true,
                      items: [
                        const DropdownMenuItem<String>(value: null, child: Text('All Categories')),
                        ..._categories.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                    ),
            const SizedBox(height: 24.0), // Larger gap before action buttons
            ElevatedButton.icon(
                icon: const Icon(Icons.search_rounded), // Updated icon
                label: const Text('Apply Filters & Search'),
                onPressed: () {
                    _fetchReportData();
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12.0), // Padding from theme is usually sufficient
                ),
            ),
            const SizedBox(height: 12.0), // Increased spacing
            TextButton.icon(
                icon: const Icon(Icons.clear_all_rounded), // Updated icon
                label: const Text('Clear Filters'),
                onPressed: _clearFilters,
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    // Consider adding foregroundColor if default is not visible enough
                    // foregroundColor: Theme.of(context).colorScheme.secondary,
                ),
            ),
        ],
      ),
    );

    Widget emailSubscriptionUISection = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Adjusted padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Get Notified About New Items',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Your Email for Notifications',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
            enabled: !_isSubscribing,
          ),
          const SizedBox(height: 12.0),
          ElevatedButton(
            onPressed: _isSubscribing ? null : _subscribeToUpdates,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
            ),
            child: _isSubscribing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Subscribe to Updates'),
          ),
          const SizedBox(height: 16.0), // Spacing after subscription button
        ],
      ),
    );

    return Column(
      children: <Widget>[
        ExpansionTile(
          title: const Text('Filter'),
          initiallyExpanded: _isFilterExpanded,
          onExpansionChanged: (bool expanded) {
            setState(() {
              _isFilterExpanded = expanded;
            });
          },
          children: <Widget>[
            filterUISection,
          ],
        ),
        ExpansionTile(
          title: const Text('Subscribe'),
          initiallyExpanded: _isSubscribeExpanded,
          onExpansionChanged: (bool expanded) {
            setState(() {
              _isSubscribeExpanded = expanded;
            });
          },
          children: <Widget>[
            emailSubscriptionUISection,
          ],
        ),
        Expanded(
          child: resultsContent,
        ),
      ],
    );
  }
}
