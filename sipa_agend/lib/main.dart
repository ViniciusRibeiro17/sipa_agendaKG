import 'package:flutter/material.dart';
import 'views/home_view.dart';

void main() {
  runApp(const AgendaSipaApp());
}

class AgendaSipaApp extends StatelessWidget {
  const AgendaSipaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Sipá',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeView(),
    );
  }
}
