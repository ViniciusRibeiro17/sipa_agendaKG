import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskDetailView extends StatelessWidget {
  final TaskModel task;

  const TaskDetailView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(task.title), backgroundColor: Colors.orange),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Descrição:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 10),
            Text(task.description, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            Row(
              children: [
                const Text(
                  'Status:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                Text(
                  task.isCompleted ? 'Concluído' : 'Pendente',
                  style: TextStyle(
                    fontSize: 22,
                    color: task.isCompleted ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
