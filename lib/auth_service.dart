   import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return credential;
    } catch (e) {
      if (e is FirebaseAuthException){
         print(e.code);
         return null;
      }
    }
    return null;
  }

  Future<UserCredential?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return credential;
    } catch (e) {
      if (e is FirebaseAuthException){
         print(e.code);
         return null;
      }
    }
    return null;
  }

  // Add sign-out functionality if needed
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
