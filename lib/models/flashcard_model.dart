class Flashcard {
  String question;
  String answer;
  String category;
  bool isLearned;
  DateTime createdAt;

  Flashcard({
    required this.question,
    required this.answer,
    required this.category,
    this.isLearned = false,
    required this.createdAt,
  });

  // Convert Flashcard object to JSON
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      'category': category,
      'isLearned': isLearned,
      'createdAt': createdAt.toIso8601String(), // Add to JSON
    };
  }

  // Create Flashcard object from JSON
  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      question: json['question'],
      answer: json['answer'],
      category: json['category'],
      isLearned: json['isLearned'],
      createdAt: DateTime.parse(json['createdAt']), // Parse from JSON
    );
  }
}
