class CompanyModel {
  final String id;
  final String name;
  final String description;
  final String logo;
  final String category;
  final bool isActive;
  final DateTime createdAt;

  CompanyModel({
    required this.id,
    required this.name,
    required this.description,
    required this.logo,
    required this.category,
    required this.isActive,
    required this.createdAt,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      logo: json['logo'] ?? '',
      category: json['category'] ?? '',
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logo': logo,
      'category': category,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
