// sipa_agend/lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'firebase_options.dart';
import 'bloc/auth_bloc.dart';
import 'views/home_calendar_view.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/task_detail_view.dart';
import 'services/task_service.dart';
import 'views/welcome_view.dart'; // Importa a nova tela de boas-vindas

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(
    'pt_BR',
    null,
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

// Definição das cores do tema do aplicativo
const Color sipaOrange = Color(0xFFF9A825); // Um laranja mais vibrante
const Color sipaPurple =
    Color(0xFF6A1B9A); // Um roxo mais escuro para contraste
const Color sipaLightPeach = Color(0xFFFDEBD0);
const Color sipaWhite = Color(0xFFFFFFFF);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        Provider<TaskService>(create: (_) => TaskService()),
      ],
      child: MaterialApp(
        title: 'SIPA Agend',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: sipaOrange,
          scaffoldBackgroundColor: sipaLightPeach,
          colorScheme: const ColorScheme.light(
            primary: sipaOrange,
            secondary: sipaPurple,
            background: sipaLightPeach,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
          ),
          textTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: sipaPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: sipaLightPeach,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black87),
            titleTextStyle: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AuthWrapper(), // Define AuthWrapper como a tela inicial
        routes: {
          '/welcome': (context) => const WelcomeView(),
          '/login': (context) => const LoginView(),
          '/register': (context) => const RegisterView(),
          '/home': (context) => const HomeCalendarView(),
          '/task_detail': (context) => const TaskDetailView(),
        },
      ),
    );
  }
}

// Widget que decide qual tela mostrar com base no estado de autenticação
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return const HomeCalendarView();
        }
        // Se não estiver autenticado, mostra a tela de boas-vindas
        return const WelcomeView();
      },
    );
  }
}
