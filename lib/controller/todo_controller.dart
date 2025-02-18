import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../model/todo/todo.dart';

class TodoController extends GetxController {
  late Box<Todo> todoBox;
  final RxList<Todo> todos = <Todo>[].obs;

  @override
  void onInit() {
    super.onInit();
    todoBox = Hive.box<Todo>('todos');
    loadTodos();
  }

  void loadTodos() {
    todos.value = List.from(todoBox.values);
  }

  void addTodo(String task) {
    final newTodo = Todo(
      id: const Uuid().v4(),
      task: task,
      isCompleted: false,
    );

    todoBox.put(newTodo.id, newTodo);
    todos.add(newTodo);
  }

  void updateTodo(String id, String newTask) {
    final index = todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      final updatedTodo = todos[index].copyWith(task: newTask);
      todoBox.put(updatedTodo.id, updatedTodo);
      todos[index] = updatedTodo;
    }
  }

  void toggleTodoCompletion(String id) {
    final index = todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      final updatedTodo = todos[index].copyWith(isCompleted: !todos[index].isCompleted);
      todoBox.put(updatedTodo.id, updatedTodo);
      todos[index] = updatedTodo;
    }
  }

  void deleteTodo(String id) {
    final index = todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      todoBox.delete(id);
      todos.removeAt(index);
    }
  }
}
