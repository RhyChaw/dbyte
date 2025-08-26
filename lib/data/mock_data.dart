import '../../models/skill.dart';
import '../../models/lesson.dart';
import '../../models/question.dart';

final mockSkills = <Skill>[
  Skill(id: 'basics', title: 'Basics', emoji: '🔤', level: 1, mastered: 40),
  Skill(id: 'phrases', title: 'Phrases', emoji: '💬', level: 0, mastered: 15),
  Skill(id: 'food', title: 'Food', emoji: '🍎', level: 0, mastered: 0),
  Skill(id: 'travel', title: 'Travel', emoji: '🧳', level: 0, mastered: 0),
];

final mockLessons = <Lesson>[
  Lesson(
    id: 'L1',
    skillId: 'basics',
    questions: [
      Question(
        id: 'q1',
        type: QuestionType.multipleChoice,
        prompt: 'Translate: "Hello"',
        choices: ['Hola', 'Adiós', 'Gracias', 'Por favor'],
        answer: 'Hola',
      ),
      Question(
        id: 'q2',
        type: QuestionType.typeAnswer,
        prompt: 'Type the translation for "Thank you"',
        answer: 'Gracias',
      ),
    ],
  ),
  Lesson(
    id: 'L2',
    skillId: 'phrases',
    questions: [
      Question(
        id: 'q3',
        type: QuestionType.multipleChoice,
        prompt: 'Translate: "Please"',
        choices: ['Perdón', 'Por favor', 'De nada', 'Buenos días'],
        answer: 'Por favor',
      ),
      Question(
        id: 'q4',
        type: QuestionType.typeAnswer,
        prompt: 'Type the translation for "Good morning"',
        answer: 'Buenos días',
      ),
    ],
  ),
];
