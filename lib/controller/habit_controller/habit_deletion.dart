import 'package:flutter/material.dart';
import '../../../../../model/habit/habit.dart';

class HabitDeletion extends StatelessWidget {
  final List<Habit> habits;
  final Function(Habit) onHabitDeleted;

  const HabitDeletion({
    super.key,
    required this.habits,
    required this.onHabitDeleted,
  });

  @override
    Widget build(BuildContext context) {
      return AlertDialog(
        title: const Text("Delete Habit"),
        content: habits.isEmpty
            ? const Text("No habits available for deletion.")
            : SizedBox(
                height: 300, // ✅ Constrain height to avoid rendering errors
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: habits.map((habit) {
                      return ListTile(
                        title: Text(habit.title),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            onHabitDeleted(habit);
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}
