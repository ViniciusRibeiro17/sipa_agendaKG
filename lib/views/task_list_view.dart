import 'package:flutter/material.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFFFA500),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: ''),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          }
        },
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              left: 16,
              right: 16,
              bottom: 24,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFFFA500),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Hoje',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(Icons.calendar_today, color: Colors.white),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: const [
                Text(
                  'Tarefas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Icon(Icons.keyboard_arrow_down_rounded, size: 28),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                _buildTaskCard('Levar o lixo para fora', true),
                _buildTaskCard('Limpar o fogão', false),
                _buildTaskCard('Passear com o cachorro', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(String task, bool done) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        leading: Icon(
          done ? Icons.check_circle : Icons.circle_outlined,
          color: done ? Colors.black : Colors.black45,
          size: 28,
        ),
        title: Text(
          task,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: done ? TextDecoration.lineThrough : null,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
