import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../model/habit/habit.dart';
import 'habit_editor_feature.dart';
import '../../../controller/habit_controller/habit_creation.dart';
import '../../../controller/habit_controller/habit_deletion.dart';

class HabitFeature extends StatefulWidget {
  const HabitFeature({super.key});

  @override
  _HabitFeatureState createState() => _HabitFeatureState();
}

class _HabitFeatureState extends State<HabitFeature> {
  late final Box<Habit> habitBox;

  @override
  void initState() {
    super.initState();
    habitBox = Hive.box<Habit>('habits');
  }

  void _createNewHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return HabitCreation(
          onHabitCreated: (habit) async {
            await habitBox.add(habit);
          },
        );
      },
    );
  }

  void _deleteHabit() {
    if (habitBox.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No habits to delete.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return HabitDeletion(
          habits: habitBox.values.toList(),
          onHabitDeleted: (habit) {
            final keyIndex = habitBox.values.toList().indexOf(habit);
            if (keyIndex != -1) {
              final key = habitBox.keyAt(keyIndex); // ✅ Get a valid key
              habitBox.delete(key);
            } else {
              debugPrint("Habit not found in box.");
            }
          },
        );
      },
    );
  }

  void _updateHabit(Habit updatedHabit) {
    final keyIndex = habitBox.values.toList().indexOf(updatedHabit);
    if (keyIndex != -1) {
      final key = habitBox.keyAt(keyIndex); // ✅ Ensure valid key
      habitBox.put(key, updatedHabit);
    } else {
      debugPrint("Cannot update: Habit not found.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Habit Tracker"),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<Habit>>(
        valueListenable: habitBox.listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No habits yet! Add one using the "+" button.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: box.length,
            itemBuilder: (context, index) {
              final habit = box.getAt(index);
              if (habit == null) return const SizedBox.shrink();
              return HabitEditorScreen(habit: habit, onHabitUpdated: _updateHabit);
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "create_habit",
            onPressed: _createNewHabit,
            backgroundColor: Colors.green,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "delete_habit",
            onPressed: _deleteHabit,
            backgroundColor: Colors.red,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
