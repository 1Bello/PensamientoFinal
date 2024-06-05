import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/Welcome');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo difuminado
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.green.withOpacity(0.8),
                  Colors.white.withOpacity(0.5),
                ],
              ),
            ),
          ),
          // Contenido centrado
          Center(
            child: FadeTransition(
              opacity: _animation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo más grande
                  SizedBox(
                    width: 500,
                    height: 500,
                    child: Image.asset('assets/images/basuraman_limpio.png'),
                  ),
                  const SizedBox(height: 20), // Espacio adicional entre el logo y el texto
                  // Texto más grande
                  Text(
                    'EcoSnap',
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Typefesse',
                      color: Color.fromARGB(255, 2, 120, 0), // Letras más oscuras
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
