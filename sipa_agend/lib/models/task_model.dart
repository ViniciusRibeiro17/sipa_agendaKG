class TaskModel {
  final String title;
  final String description;
  final bool isCompleted;

  TaskModel({
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  TaskModel copyWith({String? title, String? description, bool? isCompleted}) {
    return TaskModel(
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
