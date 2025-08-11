import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SplashController extends StatefulWidget {
  const SplashController({super.key});

  @override
  State<SplashController> createState() => _SplashControllerState();
}

class _SplashControllerState extends State<SplashController> {
  final int splashDuration = 3; // seconds
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = splashDuration;
    _initializeSplash();
  }

  void _initializeSplash() {
    FlutterNativeSplash.remove();
    _startCountdown();

    // Check authentication status after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        context.read<AuthBloc>().add(CheckAuthStatusEvent());
      }
    });
  }

  void _startCountdown() {
    Future.doWhile(() async {
      if (_remainingSeconds > 0) {
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) setState(() => _remainingSeconds--);
        return true;
      }
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, '/chats');
          } else if (state is Unauthenticated) {
            Navigator.pushReplacementNamed(context, '/chats');
          }
        },
        child: Stack(
          children: [
            // Background image
            Container(
              constraints: const BoxConstraints.expand(),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Splash.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Gradient overlay (on top of image)
            Container(
              constraints: const BoxConstraints.expand(),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x003F51F3), // Transparent
                    Color(0xFF3F51F3), // Opaque
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
            // Your content (on top of gradient)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18)
                    ),
                    child: Text(
                      'ECOM',
                      style: GoogleFonts.caveatBrush(
                        fontSize: 100,
                        color: Colors.blueAccent
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Ecommerce APP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Column(
                    children: [
                      CircularProgressIndicator(
                        value: 1 - (_remainingSeconds / splashDuration),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 6,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '$_remainingSeconds',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
