import 'package:flutter/material.dart';
import '../../../../../model/habit/habit.dart' as habitModel;

class HabitEditorScreen extends StatefulWidget {
  final habitModel.Habit habit;
  final Function(habitModel.Habit) onHabitUpdated;

  const HabitEditorScreen({super.key, required this.habit, required this.onHabitUpdated});

  @override
  _HabitCardState createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitEditorScreen> {
  late TextEditingController _controller;
  bool isEditing = false;
  late List<bool> progress;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.habit.title);
    // ✅ Ensure `progress` is exactly 365 days long
    progress = List.generate(365, (i) => i < widget.habit.progress.length ? widget.habit.progress[i] : false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _getCurrentDayIndex() {
    return DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
  }

  void _toggleTodayProgress() {
    int todayIndex = _getCurrentDayIndex();
    if (todayIndex >= 0 && todayIndex < 365) {
      setState(() {
        progress[todayIndex] = !progress[todayIndex];
        widget.onHabitUpdated(widget.habit..progress = progress);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double boxSize = (screenWidth - 64) / 31; // Responsive grid box size
    Color color = widget.habit.getColor();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFF2C2C2C),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(widget.habit.getIcon(), color: Colors.white, size: 28),
                    const SizedBox(width: 10),
                    isEditing
                        ? Expanded(
                            child: TextField(
                              controller: _controller,
                              maxLength: 30,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              decoration: const InputDecoration(border: InputBorder.none, counterText: ""),
                              onSubmitted: _saveTitle,
                              onEditingComplete: () => _saveTitle(_controller.text),
                            ),
                          )
                        : GestureDetector(
                            onTap: () => setState(() => isEditing = true),
                            child: Text(
                              widget.habit.title,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  onPressed: _toggleTodayProgress,
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Scrollable 365-Day Grid (GitHub-style)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: List.generate(7, (rowIndex) {
                  return Row(
                    children: List.generate(53, (colIndex) {
                      int dayOfYear = colIndex * 7 + rowIndex;
                      return dayOfYear < 365 ? _buildDayBox(dayOfYear, boxSize) : _buildEmptyBox(boxSize);
                    }),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveTitle(String value) {
    setState(() {
      if (_controller.text.isNotEmpty) {
        widget.habit.title = _controller.text;
        widget.onHabitUpdated(widget.habit);
      }
      isEditing = false;
    });
  }

  Widget _buildDayBox(int index, double boxSize) {
    bool isChecked = progress[index];
    Color boxColor = widget.habit.getColor();

    return GestureDetector(
      onTap: () {
        setState(() {
          progress[index] = !isChecked;
          widget.onHabitUpdated(widget.habit..progress = progress);
        });
      },
      child: Container(
        width: boxSize,
        height: boxSize,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isChecked ? boxColor : boxColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
      ),
    );
  }

  Widget _buildEmptyBox(double boxSize) {
    return Container(
      width: boxSize,
      height: boxSize,
      margin: const EdgeInsets.all(2),
      color: Colors.transparent,
    );
  }
}
