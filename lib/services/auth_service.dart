import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up with email and password
  Future<User?> signUp(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      print('Signup error: $e');
      return null;
    }
  }

  // Log in
  Future<User?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Log out
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Auth State Stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
