import 'package:flutter/material.dart';
import 'package:navigator/pages/FormPage.dart';
import 'package:navigator/pages/calculator.dart';
import 'package:navigator/pages/calendar.dart';
import 'package:navigator/pages/home.dart';
import 'package:navigator/pages/profile.dart';
import 'package:navigator/pages/settings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FormPage(),
      routes: {
        '/home': (context) => const Home(),
        '/form': (context) => const FormPage(),
        '/calendar': (context) => const CalendarPage(),
        '/calculator': (context) => const CalculatorPage(),
        '/profile': (context) =>
            const Profile(name: '', email: '', password: ''),
        '/settings': (context) => Settings(
              name: '',
              email: '',
              password: '',
              onSave: (String name, String email, String password) {
                print(
                    "Saved Data - Name: $name, Email: $email, Password: $password");
              },
            ),
      },
    );
  }
}
