class NavItem {
  final String label;
  final String path;

  NavItem({
    required this.label,
    required this.path,
  });

  factory NavItem.fromJson(Map<String, dynamic> json) {
    return NavItem(
      label: json['label'],
      path: json['path'],
    );
  }
}
