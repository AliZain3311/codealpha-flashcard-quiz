class FlashcardModel {
  final String id;
  final String question;
  final String answer;
  final String category;
  final DateTime createdAt;

  FlashcardModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory FlashcardModel.fromMap(Map<String, dynamic> map) {
    return FlashcardModel(
      id: map['id'] as String,
      question: map['question'] as String,
      answer: map['answer'] as String,
      category: map['category'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  FlashcardModel copyWith({
    String? id,
    String? question,
    String? answer,
    String? category,
    DateTime? createdAt,
  }) {
    return FlashcardModel(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
