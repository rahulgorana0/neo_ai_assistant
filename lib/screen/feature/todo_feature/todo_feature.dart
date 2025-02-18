import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/todo_controller.dart';
import 'todo_editor_feature.dart';

class TodoFeature extends StatelessWidget {
  final TodoController todoController = Get.find<TodoController>(); // Avoids re-creating controller

  TodoFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List')),
      body: Obx(() {
        final todos = todoController.todos;
        
        if (todos.isEmpty) {
          return const Center(child: Text('No tasks yet! Tap "+" to add one.'));
        }

        return ListView.builder(
          itemCount: todos.length,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemBuilder: (context, index) {
            final todo = todos[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (_) => todoController.toggleTodoCompletion(todo.id),
                ),
                title: GestureDetector(
                  onTap: () => Get.to(() => TodoEditorFeature(todo: todo)),
                  child: Text(
                    todo.task,
                    style: TextStyle(
                      fontSize: 16,
                      decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => todoController.deleteTodo(todo.id),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => TodoEditorFeature()), // Adding new task
        child: const Icon(Icons.add),
      ),
    );
  }
}
