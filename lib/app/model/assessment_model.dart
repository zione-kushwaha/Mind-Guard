class PTSDCategory {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final String icon;
  final List<String> commonSymptoms;

  PTSDCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.icon,
    required this.commonSymptoms,
  });
}

class AssessmentQuestion {
  final String id;
  final String question;
  final List<String> options;
  final String category;
  final int severity; // 1-5 scale

  AssessmentQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.category,
    required this.severity,
  });
}

class AssessmentResponse {
  final String questionId;
  final String answer;
  final int score;
  final DateTime timestamp;

  AssessmentResponse({
    required this.questionId,
    required this.answer,
    required this.score,
    required this.timestamp,
  });
}

class AssessmentResult {
  final String categoryId;
  final String categoryName;
  final int totalScore;
  final int maxScore;
  final List<AssessmentResponse> responses;
  final DateTime completedAt;
  final String riskLevel; // Low, Moderate, High, Severe

  AssessmentResult({
    required this.categoryId,
    required this.categoryName,
    required this.totalScore,
    required this.maxScore,
    required this.responses,
    required this.completedAt,
    required this.riskLevel,
  });

  double get percentage => (totalScore / maxScore) * 100;
}
