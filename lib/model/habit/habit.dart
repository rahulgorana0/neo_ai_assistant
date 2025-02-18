import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 0)
class Habit {
  @HiveField(0)
  String title;

  @HiveField(1)
  List<bool> progress;

  @HiveField(2)
  int progressColor; // Stored as an int in Hive

  @HiveField(3)
  int habitIcon; // Stored as an int for efficiency

  @HiveField(4)
  int? key;

  Habit({
    required this.title,
    required Color progressColor,
    required this.habitIcon,
    this.key,
    List<bool>? progress,
  })  : progressColor = progressColor.value,
        progress = progress ?? List.filled(365, false); // Default 365 days

  /// ✅ **Returns the stored progress color safely**
  Color getColor() => Color(progressColor);

  /// ✅ **Predefined icon mappings to prevent errors**
  static const Map<int, IconData> _iconMap = {
    0xe3af: Icons.fitness_center,
    0xe865: Icons.book,
    0xe87c: Icons.self_improvement,
    0xe56c: Icons.fastfood,
    0xe405: Icons.music_note,
    0xe3ae: Icons.brush,
    0xe3f2: Icons.local_florist,
    0xe3b0: Icons.camera_alt,
  };

  /// ✅ **Returns a predefined icon or a default fallback**
  IconData getIcon() => _iconMap[habitIcon] ?? Icons.fitness_center;
}
