// lib/models/agenda_item.dart
class AgendaItem {
  final int id;
  final String? heading;
  final String? itemText;
  final String? category;
  final String? municipality;
  final DateTime? date; // Store as DateTime for easier manipulation
  final String? pdfUrl;
  // final String? filePrefix; // Optional, if needed

  AgendaItem({
    required this.id,
    this.heading,
    this.itemText,
    this.category,
    this.municipality,
    this.date,
    this.pdfUrl,
  });

  factory AgendaItem.fromJson(Map<String, dynamic> json) {
    return AgendaItem(
      id: json['id'] as int,
      heading: json['heading'] as String?,
      itemText: json['item_text'] as String?, // Ensure snake_case matches JSON
      category: json['category'] as String?,
      municipality: json['municipality'] as String?,
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      pdfUrl: json['pdf_url'] as String?, // Ensure snake_case matches JSON
    );
  }
}
