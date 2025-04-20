import 'package:flutter/material.dart';
import 'views/home_view.dart';

void main() {
  runApp(AgendaSipaApp());
}

class AgendaSipaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Sipá',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepOrange, fontFamily: 'Arial'),
      home: HomeView(),
    );
  }
}
