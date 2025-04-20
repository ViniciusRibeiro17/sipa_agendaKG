import 'package:flutter/material.dart';
import 'package:sipa_agend/views/home_view.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/task_model.dart';
import 'task_list_view.dart';
import 'task_detail_view.dart';

class HomeCalendarView extends StatefulWidget {
  const HomeCalendarView({super.key});

  @override
  State<HomeCalendarView> createState() => _HomeCalendarViewState();
}

class _HomeCalendarViewState extends State<HomeCalendarView> {
  DateTime _focusedDay = DateTime.now();
  List<TaskModel> tasks = [
    TaskModel(
      title: 'Dar comida para o cachorro',
      description: 'Alimentar o cachorro com ração.',
      isCompleted: true,
    ),
    TaskModel(
      title: 'Limpar o fogão',
      description: 'Limpar o fogão depois do jantar.',
    ),
    TaskModel(
      title: 'Levar o lixo para fora',
      description: 'Levar o lixo da cozinha para fora.',
    ),
    TaskModel(
      title: 'Guardar Louça',
      description: 'Colocar a louça seca no armário'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Agenda Sipa', style: TextStyle(color: Colors.orange,),),
        backgroundColor: Colors.black,
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
            PopupMenuItem(child: ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sair'),
              onTap: (){
                Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) => HomeView()),
                (Route<dynamic> route) => false,);
              },
            ),)]
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFFA500),
      body: Column(
        children: [
          const SizedBox(height: 0),
          _buildCalendar(),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: _buildTaskList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
      },
      calendarFormat: CalendarFormat.week,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailView(task: task),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  task.isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: task.isCompleted ? Colors.black : Colors.grey,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: task.isCompleted ? Colors.black : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.view_list), label: ''),
      ],
      onTap: (index) {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskListView(tasks: tasks)),
          );
        }
      },
    );
  }
}
