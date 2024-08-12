class Category {
  final String name;
  final List<String> subcategories;

  Category({required this.name, required this.subcategories});

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['name'] ?? '',
      subcategories: List<String>.from(map['subcategories'] ?? []),
    );
  }
}
