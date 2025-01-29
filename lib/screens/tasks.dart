import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TasksScreen extends StatelessWidget{
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: [
          IconButton(onPressed: (){
             FirebaseAuth.instance.signOut();
             },
          icon: Icon(
            Icons.exit_to_app, color: Theme.of(context).colorScheme.primary),
           
          ),
        ],
      ),
      body: Center(
      ),
    );
  }
}