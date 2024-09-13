class Todo {
  final String id;
  final String title;
  final String description;
  final bool isDone;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    this.isDone = false,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isDone: json['isDone'] == 1, // Convert int to bool
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone ? 1 : 0, // Convert bool to int for SQLite
    };
  }
}
