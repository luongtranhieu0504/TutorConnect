import 'package:flutter/material.dart';

class Destination {
  const Destination({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

const destinations = [
  Destination(label: 'Home', icon: Icons.home_outlined),
  Destination(label: 'Post', icon: Icons.post_add_outlined),
  Destination(label: 'Schedule', icon: Icons.schedule_outlined),
  Destination(label: 'Message', icon: Icons.message_outlined),
  Destination(label: 'Profile', icon: Icons.person_outline),
];