import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import '../models/user_model.dart';

class FirebaseAuthenticationService {
  final fb_auth.FirebaseAuth _firebaseAuth = fb_auth.FirebaseAuth.instance;

  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((fbUser) {
      if (fbUser == null) {
        return null;
      } else {
        return User(
          name: fbUser.displayName ?? '',
          email: fbUser.email ?? '',
          // A senha nunca é exposta, então deixamos em branco.
          password: '',
        );
      }
    });
  }

  // Método atualizado para incluir o displayName
  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Atualiza o perfil do usuário recém-criado com o nome de exibição
    await userCredential.user?.updateDisplayName(displayName);
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signInAnonimo() async {
    await _firebaseAuth.signInAnonymously();
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
