import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final Widget child;
  const HomeScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SafeArea(child: child)
      ),
      // bottomNavigationBar: CustomBottomNav(),
    );
  }
}
