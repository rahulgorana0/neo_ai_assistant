import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 1)
class Note extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final bool isPinned;

  @HiveField(5)
  final List<bool> checklist;

  @HiveField(6)
  final DateTime timestamp;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.isPinned,
    required this.checklist,
    required this.timestamp,
  });

  /// Helper method for copyWith
  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    bool? isPinned,
    List<bool>? checklist,
    DateTime? timestamp,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      isPinned: isPinned ?? this.isPinned,
      checklist: checklist ?? this.checklist,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

