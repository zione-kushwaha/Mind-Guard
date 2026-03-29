

class PTSDFeature {
  final String id;
  final String name;
  final String urlImage;
  final String description;
  final String emoji;
  final String category;
  final List<String> benefits;
  final String route;
  final bool isEmergency;
  final bool requiresAuth;
  final bool isPremium;

  PTSDFeature({
    required this.id,
    required this.name,
    required this.urlImage,
    required this.description,
    required this.emoji,
    required this.category,
    required this.benefits,
    required this.route,
    this.isEmergency = false,
    this.requiresAuth = false,
    this.isPremium = false,
  });
}

// Legacy support for existing code
class imageData {
  final String name;
  final String urlImage;
  final String? description;
  final String? emoji;
  final int? recommendedAge;
  final List<String>? skills;

  imageData({
    required this.name,
    required this.urlImage,
    this.description,
    this.emoji,
    this.recommendedAge,
    this.skills,
  });
}
