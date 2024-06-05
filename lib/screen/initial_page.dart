import 'package:flutter/material.dart';
import 'package:testapp/elements/buttoms_edit.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/fondo_usuarios.jpg', // Ruta de la imagen de fondo
            fit: BoxFit.cover,
          ),  
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: 'Sign In',
                onPressed: () {
                  Navigator.pushNamed(context, '/signIn');
                },
              ),
              SizedBox(height: 20),
              CustomButton(
                text: 'Sign Up',
                onPressed: () {
                  Navigator.pushNamed(context, '/signUp');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
