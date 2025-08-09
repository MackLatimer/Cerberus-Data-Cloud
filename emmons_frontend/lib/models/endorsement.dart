class Endorsement {
  final String endorserName;
  final String quote;
  final String logoUrl;

  Endorsement({
    required this.endorserName,
    required this.quote,
    required this.logoUrl,
  });

  factory Endorsement.fromJson(Map<String, dynamic> json) {
    return Endorsement(
      endorserName: json['endorserName'] as String,
      quote: json['quote'] as String,
      logoUrl: json['logoUrl'] as String,
    );
  }
}
