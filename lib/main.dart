import 'package:flutter/material.dart';

import 'login_screen.dart';

void main() => runApp(const StudentApp());

class StudentApp extends StatelessWidget {
  const StudentApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Laboratory',
        theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
        home: const LoginScreen(),
      );
}
