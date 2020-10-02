import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/my_app_model.dart';
import 'pages/first_page.dart';
import 'pages/quiz_page.dart';
import 'pages/result_page.dart';

void main() {
  runApp(ChangeNotifierProvider<MyAPPModel>(
      create: (_) => MyAPPModel(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Answring Bag',
      initialRoute: '/',
      routes: {
        '/': (context) => FirstPage(title: 'Punching Bag'),
        '/home': (context) => FirstPage(title: 'Punching Bag'),
        '/quiz': (context) => QuizPage(),
        '/result': (context) => ResultPage(),
      },
    );
  }
}
