
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intern_project/models/reminder.dart';
import 'package:flutter_intern_project/models/task.dart';
import 'package:flutter_intern_project/providers/reminderProvider.dart';
import 'package:flutter_intern_project/providers/taskProvider.dart';
import 'package:flutter_intern_project/screens/drawer.dart';
import 'package:flutter_intern_project/screens/new_task.dart';
import 'package:flutter_intern_project/screens/unverified.dart';
import 'package:flutter_intern_project/widget/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksScreen extends ConsumerStatefulWidget{
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {

  void setupPushNotifications() async{
    final messager = FirebaseMessaging.instance;
    final notifiactionSettings = await messager.requestPermission();
    final token = await messager.getToken();
    messager.subscribeToTopic(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
    void initState(){
      super.initState();
      setupPushNotifications();
    }


  @override
  Widget build(BuildContext context) {
    
    
    final myTasks = ref.watch(tasksDataProvider);
    final allReminders = ref.watch(remindersDataProvider);
    
    void removeTask(String docId)async{
      try{
        FirebaseFirestore.instance.collection('tasks').doc(FirebaseAuth.instance.currentUser!.uid).collection('mytasks').doc(docId).delete();
      }
      on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message ?? "Removal of the task failed")));
      } 
    }    

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: FirebaseAuth.instance.currentUser!.emailVerified ? AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Tasks', style: TextStyle(color: Theme.of(context).colorScheme.primaryContainer)),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (ctx)=> const NewTask()));
          },
          icon: Icon(
            Icons.add, color: Theme.of(context).colorScheme.primaryContainer),
          ),
        ],
      ): AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Unverified', style: TextStyle(color: Theme.of(context).colorScheme.primaryContainer)),
      ),
      drawer:FirebaseAuth.instance.currentUser!.emailVerified ? mainDrawer() : null ,
      body: Padding(
        padding: const EdgeInsets.all(8.0),

        child: myTasks.when(
          data: (tasks){
            return ListView.builder(
              itemCount: tasks.length,  
              itemBuilder: (context, index) {
                
                if(tasks[index].reminder !=null){
                  allReminders.when(
                    data: (reminders){
                      
                      final taskReminder = reminders.firstWhere((element) => element.taskId == tasks[index].id,);
                      tasks[index].reminder = taskReminder;
                    },
                      
                    error: (e,st){}, 
                    loading: (){}
                  );
                  return Dismissible(
                    onDismissed: (direction){removeTask(tasks[index].id);} ,
                    key: ValueKey(tasks[index]),
                    child: TaskItem(task: tasks[index], docId: tasks[index].id,)
                  );
                }
                else{
                  return Dismissible(
                    onDismissed: (direction){removeTask(tasks[index].id);} ,
                    key: ValueKey(tasks[index]),
                    child: TaskItem(task: tasks[index], docId: tasks[index].id,)
                 );
                }
              }
            );
              

          }, 
          error: (e, st){return Center(child: Text('Something went wrong...'),);}, 
          loading:(){ return Center(child: CircularProgressIndicator(),);},
        )
      ),
    );
  }
}