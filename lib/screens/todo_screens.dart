import 'package:flutter/material.dart';
import 'package:flutter_application/model/todo.dart';
import 'package:flutter_application/providers/todo_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoApp extends ConsumerWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final todoListAsync = ref.watch(todoListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      body: todoListAsync.when(
        data: (todos) {
          if (todos.isEmpty) {
            return Center(
              child: Text('No todos available'),
            );
          }
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              Todo todo = todos[index];
              return ListTile(
                title: Text(todo.title),
                subtitle: Text(todo.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                actions: [
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Edit Todo'),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  TextField(
                                    controller: titleController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: todo.title,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  TextField(
                                    controller: descriptionController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: todo.description,
                                    ),
                                  ),
                                  SizedBox(height: 25),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cencel')),
                                      ElevatedButton(
                                          onPressed: () async {
                                            await ref
                                                .read(todoAddProvider.notifier)
                                                .editTodo(
                                                    todo.id,
                                                    titleController.text,
                                                    descriptionController.text);
                                            ref.refresh(todoListProvider);
                                            Navigator.pop(context);
                                          },
                                          child: Text('Save')),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.edit,
                            color: const Color.fromARGB(255, 109, 154, 190),
                            size: 25)),
                    IconButton(
                        onPressed: () async {
                          await ref
                              .read(todoAddProvider.notifier)
                              .deleteTodoById(todo.id);
                          ref.refresh(todoListProvider);
                        },
                        icon: Icon(Icons.delete, color: Colors.red, size: 25)),
                  ],
                ),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTodo = {
            'id': 100,
            'title': 'New Todo',
            'description': 'New description'
          };
          await ref.read(todoAddProvider.notifier).addTodo(newTodo);
          ref.refresh(todoListProvider);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
