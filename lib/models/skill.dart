class Skill {
  final String id;
  final String title;
  final String emoji;
  final int level; // 0..5 like crowns
  final int mastered; // 0..100 percent

  Skill({
    required this.id,
    required this.title,
    required this.emoji,
    required this.level,
    required this.mastered,
  });

  Skill copyWith({int? level, int? mastered}) => Skill(
    id: id,
    title: title,
    emoji: emoji,
    level: level ?? this.level,
    mastered: mastered ?? this.mastered,
  );
}
