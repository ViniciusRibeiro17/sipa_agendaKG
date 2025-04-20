import 'package:flutter/material.dart';
import '../models/task_model.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Task> tasks = [
      Task(
        title: 'Limpar cozinha',
        description: 'Limpar o fogão e a pia',
        date: DateTime.now(),
      ),
      Task(
        title: 'Dar comida ao cachorro',
        description: 'Ração + água',
        date: DateTime.now(),
      ),
      Task(
        title: 'Levar o lixo para fora',
        description: 'Antes das 20h',
        date: DateTime.now(),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9CBA1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B5EA7),
        title: const Text('Agenda de Tarefas'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(task.title),
              subtitle: Text(task.description),
              leading: const Icon(Icons.task),
              trailing: Text(
                '${task.date.day}/${task.date.month}/${task.date.year}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          );
        },
      ),
    );
  }
}
