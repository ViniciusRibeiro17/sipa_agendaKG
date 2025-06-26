import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';
import '../main.dart'; // Para as cores

class TaskDetailView extends StatefulWidget {
  const TaskDetailView({super.key});

  @override
  State<TaskDetailView> createState() => _TaskDetailViewState();
}

class _TaskDetailViewState extends State<TaskDetailView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isCompleted = false;
  TaskModel? _editingTask;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      if (args is TaskModel) {
        _editingTask = args;
        _titleController.text = _editingTask!.title;
        _descriptionController.text = _editingTask!.description;
        _selectedDate = _editingTask!.date;
        _selectedTime = TimeOfDay.fromDateTime(_editingTask!.date);
        _isCompleted = _editingTask!.isCompleted;
      } else if (args is DateTime) {
        _selectedDate = args;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
  }

  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final DateTime finalDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final taskService = context.read<TaskService>();

      if (_editingTask == null) {
        final newTask = TaskModel(
          title: _titleController.text,
          description: _descriptionController.text,
          date: finalDateTime,
          isCompleted: _isCompleted,
        );
        await taskService.addTask(newTask);
      } else {
        final updatedTask = _editingTask!.copyWith(
          title: _titleController.text,
          description: _descriptionController.text,
          date: finalDateTime,
          isCompleted: _isCompleted,
        );
        await taskService.updateTask(updatedTask);
      }
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _editingTask == null ? 'Nova Tarefa' : 'Editar Tarefa',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: sipaLightPeach,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um título.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
              ),
              const SizedBox(height: 24.0),
              ListTile(
                title: Text(
                  'Data: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                ),
                trailing: const Icon(Icons.calendar_today, color: sipaOrange),
                onTap: () => _selectDate(context),
              ),
              ListTile(
                title: Text('Hora: ${_selectedTime.format(context)}'),
                trailing: const Icon(Icons.access_time, color: sipaOrange),
                onTap: () => _selectTime(context),
              ),
              CheckboxListTile(
                title: const Text('Concluída'),
                value: _isCompleted,
                onChanged: (bool? newValue) {
                  setState(() => _isCompleted = newValue ?? false);
                },
                activeColor: sipaOrange,
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: sipaOrange,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  _editingTask == null ? 'Salvar Tarefa' : 'Atualizar Tarefa',
                ),
              ),
              if (_editingTask != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await context.read<TaskService>().deleteTask(
                        _editingTask!.id,
                      );
                      Navigator.of(context).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Excluir Tarefa'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
