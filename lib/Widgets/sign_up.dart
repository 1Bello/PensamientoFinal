import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp/auth_service.dart'; // Import AuthService

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final _authService = AuthService(); // Create an AuthService instance
  bool _showPassword = false;

  String _errorMessage = '';

  Future<void> _signUp() async {
    // Validate user input before attempting sign-up
    if (_validateUserInput()) {
      try {
        final credential = await _authService.signUpWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        if (credential != null) {
          // Handle successful sign-up (e.g., navigate to home page)
          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        if (e is FirebaseAuthException) {
          setState(() {
            _errorMessage = e.code; // Display appropriate error message
          });
        } else {
          setState(() {
            _errorMessage = 'An unknown error occurred.';
          });
        }
      }
    }
  }
bool _validateUserInput() {
  bool isValid = true;
  _errorMessage = ''; // Clear previous error messages

  if (_usernameController.text.isEmpty) {
    isValid = false;
    _errorMessage = 'Please enter a username.';
  }
  if (_emailController.text.isEmpty || !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+").hasMatch(_emailController.text.trim())) {
    isValid = false;
    _errorMessage = 'Please enter a valid email address.';
  }
  if (_passwordController.text.isEmpty || _passwordController.text.length < 6) {
    isValid = false;
    _errorMessage = 'Password must be at least 6 characters long.';
  }
  if (_confirmPasswordController.text.isEmpty || _confirmPasswordController.text != _passwordController.text) {
    isValid = false;
    _errorMessage = 'Passwords do not match.';
  }
  int age;
  try {
    age = int.parse(_ageController.text);
    if (age < 13) {
      isValid = false;
      _errorMessage = 'You must be 13 years or older to sign up.';
    }
  } catch (e) {
    isValid = false;
    _errorMessage = 'Please enter a valid age.';
  }

  return isValid;
}

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
      backgroundColor: const Color.fromARGB(201, 1, 68, 11), // Dark blue background
      title: const Text(
        'Sign Up', // Change to 'Sign Up' for consistency
        style: TextStyle(
          color: Colors.white, // White text color
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
        body: SingleChildScrollView( // Allow scrolling if content overflows
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center( // Center content vertically and horizontally
            child: Column(
              mainAxisSize: MainAxisSize.min, // Prevent excessive column expansion
              children: [
                _buildSignUpField(labelText: 'Username', controller: _usernameController),
                const SizedBox(height: 10.0),
                _buildSignUpField(labelText: 'Email', controller: _emailController, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 10.0),
                _buildSignUpField(labelText: 'Password', controller: _passwordController, obscureText: true),
                const SizedBox(height: 10.0),
                _buildSignUpField(labelText: 'Confirm Password', controller: _confirmPasswordController, obscureText: true),
                const SizedBox(height: 10.0),
                _buildSignUpField(labelText: 'Age', controller: _ageController, keyboardType: TextInputType.number),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _signUp,
                  child: const Text('Sign Up'),
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