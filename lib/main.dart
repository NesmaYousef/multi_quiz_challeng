import 'package:flutter/material.dart';
import 'package:multi_quiz_s_t_tt9/pages/home.dart';
import 'package:multi_quiz_s_t_tt9/pages/multiple_q_screen.dart';
import 'package:multi_quiz_s_t_tt9/pages/true_false_q_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: '/', routes: {
      '/': (context) => HomePage(),
      '/first': (context) => TrueFalseQuiz(),
      '/second': (context) => MultiQScreen(),
    });
  }
}
