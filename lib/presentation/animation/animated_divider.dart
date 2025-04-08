import 'package:flutter/material.dart';

class AnimatedDivider extends StatefulWidget {
  const AnimatedDivider({super.key});

  @override
  State<AnimatedDivider> createState() => _AnimatedDividerState();
}

class _AnimatedDividerState extends State<AnimatedDivider>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _fade = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward(); // Bắt đầu animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: const Divider(thickness: 3, color: Colors.grey),
    );
  }
}
