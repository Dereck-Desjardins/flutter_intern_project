import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intern_project/firebase_options.dart';
import 'package:flutter_intern_project/screens/connexion.dart';
import 'package:flutter_intern_project/screens/tasks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async{
  
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: MyApp()));
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
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges() , builder: (ctx, snapshot){
          if(snapshot.hasData){
            return const TasksScreen();
          }
        return ConnexionScreen();
      }),
      
       
    );
  } 
 
  
}
