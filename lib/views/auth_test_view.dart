import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class AuthTestView extends StatefulWidget {
  const AuthTestView({super.key});

  @override
  State<AuthTestView> createState() => _AuthTestViewState();
}

class _AuthTestViewState extends State<AuthTestView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Auth Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            String statusText = 'Unknown state';
            if (state is Unauthenticated) {
              statusText = 'User is not authenticated';
            } else if (state is Authenticated) {
              statusText = 'User is authenticated: ${state.userModel.email}';
            } else if (state is AuthError) {
              statusText = 'Error: ${state.message}';
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(statusText, style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();
                      authBloc.add(
                        RegisterUser(username: email, password: password),
                      );
                    },
                    child: const Text('Register with Email'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();
                      authBloc.add(
                        LoginUser(username: email, password: password),
                      );
                    },
                    child: const Text('Login with Email'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      authBloc.add(LoginAnonymousUser());
                    },
                    child: const Text('Login Anonymously'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      authBloc.add(Logout());
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
