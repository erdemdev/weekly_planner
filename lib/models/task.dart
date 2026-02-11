class Task {
  final int? id;
  final String day;
  final String title;
  final bool isDone;

  Task({
    this.id,
    required this.day,
    required this.title,
    required this.isDone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'day': day,
      'title': title,
      'isDone': isDone ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      day: map['day'],
      title: map['title'],
      isDone: map['isDone'] == 1,
    );
  }
}
