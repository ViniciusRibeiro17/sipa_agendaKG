import 'package:flutter/material.dart';
import '../main.dart'; // Importa para ter acesso às cores do tema

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Agenda Sipá',
                  style: TextStyle(
                    fontFamily: 'Serif',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 30),
                Image.asset('assets/logo.png', height: 180),
                const SizedBox(height: 30),
                const Text(
                  'Bem-Vindo!',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Serif',
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: sipaPurple,
                      minimumSize: const Size(double.infinity, 50)),
                  child: const Text('Entrar na Conta'),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: sipaPurple,
                      minimumSize: const Size(double.infinity, 50)),
                  child: const Text('Cadastre-se'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // TODO: Implementar a tela de ajuda
                  },
                  child: const Text(
                    'Ajuda',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
