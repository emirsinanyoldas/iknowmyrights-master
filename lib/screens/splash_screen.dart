import 'package:flutter/material.dart';
import 'package:iknowmyrights/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 48, end: 60),
              duration: const Duration(milliseconds: 300), // Daha hızlı animasyon
              builder: (context, size, child) {
                return Text(
                  'L',
                  style: TextStyle(
                    fontSize: size,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                );
              },
            ),
            SizedBox(
              height: 60,
              width: 60,
              child: Image.asset(
                'assets/images/world.gif',
                fit: BoxFit.contain,
              ),
            ),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 48, end: 60),
              duration: const Duration(milliseconds: 300), // Daha hızlı animasyon
              builder: (context, size, child) {
                return Text(
                  'ADING',
                  style: TextStyle(
                    fontSize: size,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                );
              },
            ),
            const SizedBox(width: 20),
            const SizedBox(
              width: 10,
              child: Text(
                '.',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
              child: Text(
                '.',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
              child: Text(
                '.',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}