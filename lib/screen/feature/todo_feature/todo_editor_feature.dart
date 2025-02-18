import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/todo_controller.dart';
import '../../../model/todo/todo.dart';

class TodoEditorFeature extends StatelessWidget {
  final TodoController todoController = Get.find<TodoController>(); // Uses existing controller
  final Todo? todo;

  TodoEditorFeature({super.key, this.todo});

  final TextEditingController taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Set task text only once when opening the editor
    if (todo != null && taskController.text.isEmpty) {
      taskController.text = todo!.task;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(todo == null ? 'New Task' : 'Edit Task'),
        actions: [
          if (todo != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                todoController.deleteTodo(todo!.id);
                Get.back();
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: taskController,
          decoration: const InputDecoration(labelText: 'Task'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final task = taskController.text.trim();
          if (task.isEmpty) {
            Get.snackbar('Error', 'Task description is required.', snackPosition: SnackPosition.BOTTOM);
            return;
          }

          if (todo == null) {
            todoController.addTodo(task); // Add new task
          } else {
            todoController.updateTodo(todo!.id, task); // Update existing task
          }

          Get.back();
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
