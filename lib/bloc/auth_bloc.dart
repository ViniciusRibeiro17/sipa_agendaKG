// sipa_agend/lib/bloc/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../provider/firebase_auth.dart';
import '../models/user_model.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuthenticationService _authenticationService =
      FirebaseAuthenticationService();

  AuthBloc() : super(Unauthenticated()) {
    _authenticationService.user.listen((event) {
      add(AuthServerEvent(event));
    });

    on<AuthServerEvent>((event, emit) {
      if (event.userModel == null) {
        emit(Unauthenticated());
      } else {
        emit(Authenticated(userModel: event.userModel!));
      }
    });

    on<RegisterUser>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authenticationService.createUserWithEmailAndPassword(
          event.email, // Corrigido para usar email
          event.password,
          event.displayName, // Passa o nome de usuário
        );
      } catch (e) {
        emit(AuthError(message: "Impossível Registrar: ${e.toString()}"));
      }
    });

    on<LoginUser>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authenticationService.signInWithEmailAndPassword(
          event.username,
          event.password,
        );
      } catch (e) {
        emit(
          AuthError(
            message: "Impossível Logar com ${event.username}: ${e.toString()}",
          ),
        );
      }
    });

    on<LoginAnonymousUser>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authenticationService.signInAnonimo();
      } catch (e) {
        emit(
          AuthError(
            message: "Impossível Acessar Anonimamente: ${e.toString()}",
          ),
        );
      }
    });

    on<Logout>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authenticationService.signOut();
      } catch (e) {
        emit(AuthError(message: "Impossível Efeturar Logout: ${e.toString()}"));
      }
    });
  }
}

// Eventos de Autenticação
abstract class AuthEvent {}

class RegisterUser extends AuthEvent {
  final String email;
  final String password;
  final String displayName;

  RegisterUser({
    required this.email,
    required this.password,
    required this.displayName,
  });
}

class LoginUser extends AuthEvent {
  String username;
  String password;

  LoginUser({required this.username, required this.password});
}

class LoginAnonymousUser extends AuthEvent {}

class Logout extends AuthEvent {}

class AuthServerEvent extends AuthEvent {
  final User? userModel;
  AuthServerEvent(this.userModel);
}

// Estados de Autenticação
abstract class AuthState {}

class Unauthenticated extends AuthState {}

class Authenticated extends AuthState {
  User userModel;
  Authenticated({required this.userModel});
}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}
