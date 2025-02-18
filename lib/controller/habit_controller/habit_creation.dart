import 'package:flutter/material.dart';
import '../../../../../model/habit/habit.dart' as habitModel; // Avoid ambiguity with habitModel prefix

class HabitCreation extends StatefulWidget {
  final Function(habitModel.Habit) onHabitCreated;

  const HabitCreation({super.key, required this.onHabitCreated});

  @override
  _HabitCreationState createState() => _HabitCreationState();
}

class _HabitCreationState extends State<HabitCreation> {
  String habitName = "";
  Color selectedColor = Colors.green[200]!;
  IconData selectedIcon = Icons.fitness_center;

  final List<Color> availableColors = [
    Colors.red[200]!,
    Colors.green[200]!,
    Colors.blue[200]!,
    Colors.orange[200]!,
    Colors.purple[200]!,
    Colors.teal[200]!,
    Colors.amber[200]!,
    Colors.pink[200]!,
    Colors.indigo[200]!,
    Colors.brown[200]!,
  ];

  final List<IconData> availableIcons = [
    Icons.fitness_center,
    Icons.book,
    Icons.self_improvement,
    Icons.fastfood,
    Icons.music_note,
    Icons.brush,
    Icons.local_florist,
    Icons.camera_alt,
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Create New Habit"),
      content: IntrinsicHeight(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              maxLength: 30,
              decoration: const InputDecoration(labelText: "Habit Name"),
              onChanged: (value) => setState(() => habitName = value),
            ),
            const SizedBox(height: 16),
            const Text("Select Color:"),
            Wrap(
              spacing: 8,
              children: availableColors.map((color) {
                return GestureDetector(
                  onTap: () {
                    if (selectedColor != color) {
                      setState(() => selectedColor = color);
                    }
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                        border: selectedColor == color
                            ? Border.all(color: Colors.white, width: 2)
                            : null,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text("Select Icon:"),
            Wrap(
              spacing: 8,
              children: availableIcons.map((icon) {
                return GestureDetector(
                  onTap: () {
                    if (selectedIcon != icon) {
                      setState(() => selectedIcon = icon);
                    }
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: selectedIcon == icon
                            ? Border.all(color: Colors.white, width: 2)
                            : null,
                      ),
                      child: Icon(icon, size: 30, color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: habitName.isNotEmpty
              ? () {
                  widget.onHabitCreated(
                    habitModel.Habit(
                      title: habitName,
                      progress: List.filled(365, false),
                      progressColor: selectedColor, // Ensure color is saved properly
                      habitIcon: selectedIcon.codePoint,
                    ),
                  );
                  Navigator.of(context).pop();
                }
              : null, // Disable button if habitName is empty
          child: const Text("Create"),
        ),
      ],
    );
  }
}
