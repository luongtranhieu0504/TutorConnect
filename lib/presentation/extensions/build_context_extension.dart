import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  Future<T?> pushNamed<T extends Object?>(
      String route, {
        Object? arguments,
      }) =>
      Navigator.pushNamed(this, route, arguments: arguments);

  void pushNamedAndRemoveUntil(String route) =>
      Navigator.pushNamedAndRemoveUntil(this, route, (_) => false);
}
