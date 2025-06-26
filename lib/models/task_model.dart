// sipa_agend/lib/models/task_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TaskModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final bool isCompleted;

  const TaskModel({
    this.id = '',
    required this.title,
    required this.description,
    required this.date,
    this.isCompleted = false,
  });

  // Construtor para criar um TaskModel a partir de um mapa (útil para Firestore)
  factory TaskModel.fromMap(Map<String, dynamic> data, String id) {
    return TaskModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date:
          (data['date'] as Timestamp)
              .toDate(), // Converte Timestamp para DateTime
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  // Método para converter o TaskModel para um mapa (útil para Firestore)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date), // Converte DateTime para Timestamp
      'isCompleted': isCompleted,
    };
  }

  // Permite criar uma cópia do objeto com algumas propriedades modificadas
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object> get props => [id, title, description, date, isCompleted];
}
