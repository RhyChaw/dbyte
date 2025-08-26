enum QuestionType { multipleChoice, typeAnswer }

class Question {
  final String id;
  final QuestionType type;
  final String prompt;
  final List<String> choices; // for MC only
  final String answer; // canonical answer

  Question({
    required this.id,
    required this.type,
    required this.prompt,
    this.choices = const [],
    required this.answer,
  });
}
