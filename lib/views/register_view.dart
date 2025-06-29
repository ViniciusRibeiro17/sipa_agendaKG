import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../main.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        errorMessage = 'As senhas não coincidem.';
      });
      return;
    }
    if (_passwordController.text.length < 6) {
      setState(() {
        errorMessage = 'A senha deve ter pelo menos 6 caracteres.';
      });
      return;
    }

    // Adiciona o evento com os novos campos
    context.read<AuthBloc>().add(
          RegisterUser(
            email: _emailController.text,
            password: _passwordController.text,
            displayName: _usernameController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            setState(() {
              errorMessage = state.message;
            });
          } else if (state is Authenticated) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (state is AuthLoading) {
            setState(() {
              errorMessage = null;
            });
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
    alignment: Alignment.centerLeft,
    child: IconButton(
      icon: const Icon(Icons.arrow_back),
      color: Colors.black87,
      onPressed: () {
        Navigator.pop(context); // Volta para a tela anterior (HomeView)
      },
    ),
  ),
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: sipaOrange,
                    child:
                        Icon(Icons.person_add, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Cadastro',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Serif',
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildTextField(
                      controller: _usernameController, label: 'Usuário'),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _passwordController,
                    label: 'Senha',
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirmar Senha',
                    obscureText: true,
                  ),
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 20),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const CircularProgressIndicator(
                            color: sipaOrange);
                      }
                      return ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: sipaOrange,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Confirmar'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          ),
        ),
      ],
    );
  }
}
