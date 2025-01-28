import 'package:flutter/material.dart';
import 'package:flutter_intern_project/screens/connexion.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'Intern Task Manager',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 161, 85, 35)),
      ),
      home: ConnexionScreen(),
    );
  } 
 
  
}
