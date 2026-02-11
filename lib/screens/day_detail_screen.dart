import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/task.dart';

class DayDetailScreen extends StatefulWidget {
  final String day;

  const DayDetailScreen({super.key, required this.day});

  @override
  State<DayDetailScreen> createState() => _DayDetailScreenState();
}

class _DayDetailScreenState extends State<DayDetailScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final data = await DatabaseHelper.instance.getTasks(widget.day);
    setState(() {
      tasks = data;
    });
  }

  void _addTaskDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Görev Ekle'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Görev adı'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;

              await DatabaseHelper.instance.insertTask(
                Task(
                  day: widget.day,
                  title: controller.text.trim(),
                  isDone: false,
                ),
              );

              Navigator.pop(context);
              _loadTasks();
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.day)),
      body: tasks.isEmpty
          ? const Center(child: Text('Henüz görev yok'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (_, i) {
                final task = tasks[i];
                return ListTile(
                  leading: Checkbox(
                    value: task.isDone,
                    onChanged: (val) async {
                      await DatabaseHelper.instance.updateTask(
                        Task(
                          id: task.id,
                          day: task.day,
                          title: task.title,
                          isDone: val ?? false,
                        ),
                      );
                      _loadTasks();
                    },
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration:
                          task.isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await DatabaseHelper.instance.deleteTask(task.id!);
                      _loadTasks();
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
