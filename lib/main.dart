import 'package:flutter/material.dart';
import 'package:money_manager/screens/home/screen_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Manager',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
        selectedRowColor: Colors.purple,
        unselectedWidgetColor: Colors.grey,
        iconTheme: const IconThemeData(
          color: Colors.blue,
        ),
        textTheme: const TextTheme(
          headline6: TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const ScreenHome(),
    );
  }
}
