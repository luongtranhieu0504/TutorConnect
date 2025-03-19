import 'package:flutter/material.dart';
import 'package:tutorconnect/presentation/widgets/custom_bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  final Widget child;
  const HomeScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SafeArea(child: child)
      ),
      bottomNavigationBar: CustomBottomNav(),
    );
  }
}
