class Endorsement {
  final String name;
  final String quote;
  final String imagePath;
  final bool imageLeft;
  final String backgroundColor;
  final String textColor;

  Endorsement({
    required this.name,
    required this.quote,
    required this.imagePath,
    required this.imageLeft,
    required this.backgroundColor,
    required this.textColor,
  });

  factory Endorsement.fromJson(Map<String, dynamic> json) {
    return Endorsement(
      name: json['name'],
      quote: json['quote'],
      imagePath: json['imagePath'],
      imageLeft: json['imageLeft'],
      backgroundColor: json['backgroundColor'],
      textColor: json['textColor'],
    );
  }
}
