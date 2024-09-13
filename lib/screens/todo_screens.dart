import 'package:flutter/material.dart';
import 'package:flutter_application/model/todo.dart';
import 'package:flutter_application/providers/todo_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoApp extends ConsumerWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoListAsync = ref.watch(todoListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade200, Colors.teal.shade50],
          ),
        ),
        child: todoListAsync.when(
          data: (todos) {
            if (todos.isEmpty) {
              return Center(
                child: Text('No todos available',
                    style:
                        TextStyle(fontSize: 18, color: Colors.teal.shade700)),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: todos.length,
              itemBuilder: (context, index) {
                Todo todo = todos[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                        decoration:
                            todo.isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text(
                      todo.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        overflow: TextOverflow.ellipsis,
                        decoration:
                            todo.isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    leading: Checkbox(
                      value: todo.isDone,
                      onChanged: (newValue) async {
                        await ref.read(todoAddProvider.notifier).editTodo(
                            todo.id, todo.title, todo.description,
                            isDone: newValue!);
                        ref.refresh(todoListProvider);
                      },
                      activeColor: Colors.teal,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            final titleController =
                                TextEditingController(text: todo.title);
                            final descriptionController =
                                TextEditingController(text: todo.description);

                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Edit Todo',
                                      style: TextStyle(color: Colors.teal)),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: titleController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          labelText: 'Title',
                                          labelStyle:
                                              TextStyle(color: Colors.teal),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.teal)),
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      TextField(
                                        controller: descriptionController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          labelText: 'Description',
                                          labelStyle:
                                              TextStyle(color: Colors.teal),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.teal)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel',
                                          style: TextStyle(color: Colors.grey)),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await ref
                                            .read(todoAddProvider.notifier)
                                            .editTodo(
                                              todo.id,
                                              titleController.text.isEmpty
                                                  ? todo.title
                                                  : titleController.text,
                                              descriptionController.text.isEmpty
                                                  ? todo.description
                                                  : descriptionController.text,
                                              isDone: todo.isDone,
                                            );
                                        ref.refresh(todoListProvider);
                                        Navigator.pop(context);
                                      },
                                      child: Text('Save'),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.teal),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.teal,
                            size: 22,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await ref
                                .read(todoAddProvider.notifier)
                                .deleteTodoById(todo.id);
                            ref.refresh(todoListProvider);
                          },
                          icon: Icon(Icons.delete, color: Colors.red, size: 22),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          loading: () => Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.teal))),
          error: (err, stack) => Center(
              child: Text('Error: $err', style: TextStyle(color: Colors.red))),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final titleController = TextEditingController();
              final descriptionController = TextEditingController();

              return AlertDialog(
                title:
                    Text('Add New Todo', style: TextStyle(color: Colors.teal)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        labelStyle: TextStyle(color: Colors.teal),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal)),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        labelStyle: TextStyle(color: Colors.teal),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal)),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel', style: TextStyle(color: Colors.grey)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final newTodo = {
                        'id': DateTime.now().millisecondsSinceEpoch.toString(),
                        'title': titleController.text.isNotEmpty
                            ? titleController.text
                            : 'New Todo',
                        'description': descriptionController.text.isNotEmpty
                            ? descriptionController.text
                            : 'New description',
                        'isDone': 0,
                      };

                      await ref.read(todoAddProvider.notifier).addTodo(newTodo);
                      ref.refresh(todoListProvider);

                      Navigator.pop(context);
                    },
                    child: Text('Add'),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
