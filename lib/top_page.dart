import 'package:flutter/material.dart';
import 'package:miecal/login.dart';
import 'package:miecal/vertical_slide_page.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  void _goToLoginPage() {
    Navigator.push(context, VerticalSlideRoute(page: const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _goToLoginPage,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.transparent,
          child: const Center(
            child: Text(
              'Please Tap the Screen',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
