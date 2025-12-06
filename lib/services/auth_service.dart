import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/login.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> register(String email, String password, BuildContext context) async {
    print('AuthService.register CALLED with $email');

    try {
      print('CALLING createUserWithEmailAndPassword...');
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('REGISTER SUCCESS');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
      return "Success!";
    } on FirebaseAuthException catch (e) {
      print('REGISTER ERROR CODE: ${e.code}');
      print('REGISTER ERROR MESSAGE: ${e.message}');
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        return 'Email format is not valid.';
      } else {
        return e.message ?? 'Register failed: ${e.code}';
      }
    } catch (e) {
      print('REGISTER OTHER ERROR: $e');
      return e.toString();
    }
  }


  Future<String?> login(String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );

      return "Success!";
    } on FirebaseAuthException catch (e) {
      debugPrint('LOGIN ERROR CODE: ${e.code}');

      if (e.code == "INVALID_LOGIN_CREDENTIALS" ||
          e.code == "wrong-password" ||
          e.code == "user-not-found") {
        return 'Invalid login credentials.';
      } else {
        return e.message ?? "Login failed: ${e.code}";
      }
    } catch (e) {
      return e.toString();
    }
  }


  Future<String?> getEmail() async {
    String? email = FirebaseAuth.instance.currentUser?.email ?? "Email not found.";
    print(email);
    return email;
  }

  Future<void> logout(BuildContext context) async {
    await _auth.signOut();

    await Future.delayed(const Duration(milliseconds: 300));

    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
            (Route<dynamic> route) => false,
      );
    }
  }

}