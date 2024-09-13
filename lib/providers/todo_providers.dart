import 'package:flutter_application/services/todo_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final todoServiceProvider = Provider((ref) => TodoService());

final todoListProvider = FutureProvider<List<dynamic>>((ref) async {
  final todoService = ref.read(todoServiceProvider);
  return todoService.fetchTodos();
});

final todoAddProvider =
    StateNotifierProvider<TodoAddNotifier, AsyncValue<void>>((ref) {
  return TodoAddNotifier(ref);
});

class TodoAddNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  TodoAddNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> addTodo(Map<String, dynamic> todo) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(todoServiceProvider).addTodo(todo);
      state = const AsyncValue.data(null);
    } catch (e) {
      print('---------PROVIDERS-------${e.toString()}');
    }
  }

  Future<void> deleteTodoById(String id) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(todoServiceProvider).deleteTodoById(id);
      state = const AsyncValue.data(null);
    } catch (e) {
      print('---------PROVIDERS DELETE-------${e.toString()}');
    }
  }


  Future<void> editTodo(String id, String title, String description) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(todoServiceProvider).editTodo(id, title, description);
      state = const AsyncValue.data(null);
    } catch (e) {
      print('---------PROVIDERS-------${e.toString()}');
    }
  }
}
