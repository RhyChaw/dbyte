import 'question.dart';

class Lesson {
  final String id;
  final String skillId;
  final List<Question> questions;

  Lesson({required this.id, required this.skillId, required this.questions});
}
