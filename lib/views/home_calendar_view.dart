import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/auth_bloc.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';
import 'package:provider/provider.dart';
import '../main.dart'; // Para as cores

class HomeCalendarView extends StatefulWidget {
  const HomeCalendarView({super.key});

  @override
  State<HomeCalendarView> createState() => _HomeCalendarViewState();
}

class _HomeCalendarViewState extends State<HomeCalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<TaskModel>> _events = {};
  List<TaskModel> _selectedDayTasks = [];
  int _bottomNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadTasks();
  }

  void _loadTasks() {
    context.read<TaskService>().getTasks().listen((tasks) {
      if (!mounted) return;
      setState(() {
        _events = {};
        for (var task in tasks) {
          DateTime normalizedDate = DateTime(
            task.date.year,
            task.date.month,
            task.date.day,
          );
          if (_events[normalizedDate] == null) {
            _events[normalizedDate] = [];
          }
          _events[normalizedDate]!.add(task);
        }
        if (_selectedDay != null) {
          _selectedDayTasks = _getEventsForDay(_selectedDay!);
        }
      });
    });
  }

  List<TaskModel> _getEventsForDay(DateTime day) {
    DateTime normalizedDay = DateTime(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sipaOrange,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildCalendar(),
          const SizedBox(height: 8.0),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: sipaWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tarefas',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: sipaOrange,
                          size: 30,
                        ),
                        onPressed: () => _navigateToTaskDetail(null),
                      ),
                    ],
                  ),
                  Expanded(
                    child:
                        _selectedDayTasks.isEmpty
                            ? const Center(
                              child: Text("Nenhuma tarefa para este dia."),
                            )
                            : ListView.builder(
                              itemCount: _selectedDayTasks.length,
                              itemBuilder: (context, index) {
                                final task = _selectedDayTasks[index];
                                return _buildTaskCard(task);
                              },
                            ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: sipaOrange,
      elevation: 0,
      title: const Text(
        'Hoje',
        style: TextStyle(
          color: sipaWhite,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: sipaWhite, size: 28),
          onPressed: () {
            // TODO: Implement search
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: sipaWhite, size: 28),
          onPressed: () {
            context.read<AuthBloc>().add(Logout());
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/welcome', (route) => false);
          },
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return TableCalendar<TaskModel>(
      locale: 'pt_BR',
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      headerVisible: true,
      daysOfWeekVisible: true,
      calendarFormat: CalendarFormat.week, // Inicia com a visão da semana
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      eventLoader: _getEventsForDay,

      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            _selectedDayTasks = _getEventsForDay(selectedDay);
          });
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      headerStyle: HeaderStyle(
        titleTextStyle: const TextStyle(color: sipaWhite, fontSize: 20.0),
        formatButtonVisible: false,
        titleCentered: true,
        leftChevronIcon: const Icon(Icons.chevron_left, color: sipaWhite),
        rightChevronIcon: const Icon(Icons.chevron_right, color: sipaWhite),
        titleTextFormatter:
            (date, locale) => DateFormat.yMMMM(locale).format(date),
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: sipaWhite),
        weekendStyle: TextStyle(color: sipaWhite),
      ),
      calendarStyle: CalendarStyle(
        defaultTextStyle: const TextStyle(color: sipaWhite),
        weekendTextStyle: const TextStyle(color: sipaWhite),
        outsideTextStyle: TextStyle(color: sipaWhite.withOpacity(0.5)),
        selectedDecoration: const BoxDecoration(
          color: sipaPurple,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: sipaWhite.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        markerDecoration: const BoxDecoration(
          color: sipaPurple,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task) {
  final imagens = {
    'fogao': 'fogao.png',
    'varrer': 'varrer.png',
    'lixo': 'lixo.png',
    'louça': 'pia.png',
  };

  final nomeTarefa = task.title.toLowerCase();
  final nomeArquivo = imagens[nomeTarefa];
  final mostrarImagem = nomeArquivo != null;
  final caminhoImagem = 'assets/$nomeArquivo';

  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    elevation: 2,
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (bool? newValue) {
          if (newValue != null) {
            context.read<TaskService>().updateTask(
              task.copyWith(isCompleted: newValue),
            );
          }
        },
        shape: const CircleBorder(),
        activeColor: Colors.black,
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                Text(task.description),
              ],
            ),
          ),
          if (mostrarImagem)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                caminhoImagem,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _navigateToTaskDetail(task),
      onLongPress: () => _showDeleteConfirmationDialog(task),
    ),
  );
}


  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _bottomNavIndex,
      onTap: (index) {
        setState(() => _bottomNavIndex = index);
        if (index == 1) {
          // Navegar para a visualização de calendário completa
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullCalendarView(events: _events),
            ),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Calendário',
        ),
      ],
      backgroundColor: sipaWhite,
      selectedItemColor: sipaOrange,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 10,
    );
  }

  void _navigateToTaskDetail(TaskModel? task) async {
    final result = await Navigator.of(
      context,
    ).pushNamed('/task_detail', arguments: task ?? _selectedDay);
    if (result == true) {
      // O listener já atualiza, mas isso força a atualização se necessário
    }
  }

  void _showDeleteConfirmationDialog(TaskModel task) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Excluir Tarefa?'),
            content: Text(
              'Tem certeza que deseja excluir a tarefa "${task.title}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  context.read<TaskService>().deleteTask(task.id);
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Excluir',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}

// Widget para a visão de calendário do mês inteiro
class FullCalendarView extends StatelessWidget {
  final Map<DateTime, List<TaskModel>> events;

  const FullCalendarView({super.key, required this.events});

  List<TaskModel> _getEventsForDay(DateTime day) {
    DateTime normalizedDay = DateTime(day.year, day.month, day.day);
    return events[normalizedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendário Mensal'),
        backgroundColor: sipaOrange,
      ),
      body: TableCalendar(
        locale: 'pt_BR',
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: DateTime.now(),
        eventLoader: _getEventsForDay,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
      ),
    );
  }
}
