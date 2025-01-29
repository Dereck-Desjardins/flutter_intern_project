import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intern_project/screens/new_task.dart';

class TasksScreen extends StatelessWidget{
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Tasks', style: TextStyle(color: Theme.of(context).colorScheme.primaryContainer)),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (ctx)=> const NewTask()));
          },
          icon: Icon(
            Icons.add, color: Theme.of(context).colorScheme.primaryContainer),
          ),
          IconButton(onPressed: (){
              FirebaseAuth.instance.signOut();
             },
          icon: Icon(
            Icons.exit_to_app, color: Theme.of(context).colorScheme.primaryContainer),
           
          ),
        ],
      ),
      body: ListView.builder(
        //itemCount: _allTasks.length,
        itemBuilder: (ctx, index){

        },
      ),
    );
  }
}