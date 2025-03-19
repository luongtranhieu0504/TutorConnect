import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    int selectedIndex = _getSelectedIndex(context);

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/home/student-home');
            break;
          case 1:
            context.go('/home/schedule');
            break;
          case 2:
            context.go('/home/message');
            break;
          case 3:
            context.go('/home/profile');
            break;
        }
      },
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 28),
          label: "home",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/icons/schedule.svg', width: 28, height: 28),
          label: "schedule",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/icons/message.svg', width: 28, height: 28),
          label: "message",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 28),
          label: "Profile",
        ),
      ],
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home/student-home')) return 0;
    if (location.startsWith('/home/schedule')) return 1;
    if (location.startsWith('/home/message')) return 2;
    if (location.startsWith('/home/profile')) return 3;
    return 0;
  }
}
