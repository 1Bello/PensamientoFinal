import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // bool _showPassword = false; // Flag to control password visibility
  late SharedPreferences _prefs; // Declare SharedPreferences instance

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  // Initialize SharedPreferences and check for saved credentials
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _checkSavedCredentials();
  }

  // Check for saved credentials and attempt automatic sign-in
  void _checkSavedCredentials() async {
    final String? savedEmail = _prefs.getString('email');
    final String? savedPassword = _prefs.getString('password');

    if (savedEmail != null && savedPassword != null) {
      // Try to sign in with saved credentials
      await _signIn(email: savedEmail, password: savedPassword);
    }
  }

  // Sign-in method to handle both manual and automatic sign-in
  Future<void> _signIn({String? email, String? password}) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;

      if (email == null && password == null) {
        // Manual sign-in with form data
        await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        // Automatic sign-in with saved credentials
        await auth.signInWithEmailAndPassword(email: email!, password: password!);
      }

      // Save credentials for automatic sign-in on app relaunch (after successful sign-in)
      _saveLoginCredentials(_emailController.text.trim(), _passwordController.text.trim());

      // Navigate to home page after successful sign-in
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      // Handle sign-in errors (e.g., invalid email, wrong password)
      print(e.code); // Display appropriate error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.message}'),
        ),
      );
    } catch (e) {
      // Handle other errors
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An unknown error occurred.'),
        ),
      );
    }
  }

  // Save login credentials to SharedPreferences
  void _saveLoginCredentials(String email, String password) async {
    await _prefs.setString('email', email);
    await _prefs.setString('password', password);
  }

  // Logout method to clear saved credentials
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    _clearSavedCredentials();

    // Navigate to login page after successful logout
    Navigator.pushReplacementNamed(context, '/sign_in');
  }

  // Clear saved credentials from SharedPreferences
  void _clearSavedCredentials() async {
    await _prefs.remove('email');
    await _prefs.remove('password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(201, 1, 68, 11), // Dark blue background
        title: const Text(
          'Sign In',
          style: TextStyle(
            color: Colors.white, // White text color
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10.0),
                _buildSignUpField(
                  labelText: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10.0),
                _buildSignUpField(
                  labelText: 'Password',
                  controller: _passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () => _signIn(), // Use the sign-in method without parameters
                  child: const Text('Sign In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpField({
    required String labelText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
        border: Border.all(color: Colors.grey), // Grey border
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black), // Darker label text
          focusedBorder: OutlineInputBorder( // Darker border on focus
            borderSide: const BorderSide(color: Colors.black),
          ),
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
      ),
    );
  }
}