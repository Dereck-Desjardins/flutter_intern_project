
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intern_project/models/task.dart';
import 'package:flutter_intern_project/providers/filtered_tasks.dart';
import 'package:flutter_intern_project/screens/new_task.dart';
import 'package:flutter_intern_project/widget/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksScreen extends ConsumerWidget{
  const TasksScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myTasks = ref.watch(filteredTasks);

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
      body: StreamBuilder(
        stream: myTasks, 
        builder: (ctx, tasksSnapshots){
        if(tasksSnapshots.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }

        if(!tasksSnapshots.hasData || tasksSnapshots.data!.docs.isEmpty){
          return Center(child: Text('no messages'),);
        }

        if(tasksSnapshots.hasError){
          return Center(child: Text('Something went wrong...'),);
        }
          final myTasks = tasksSnapshots.data!.docs;
          return ListView.builder(
            itemCount: myTasks.length,
            itemBuilder: (context, index) {
              TaskType taskType = TaskType.chore;
              TimeOfDay? timeOfDay;
              String nonFormattedDate;
              taskType = convertTaskType(myTasks[index]['tasktype']);
              timeOfDay = convertTimeOfDay(myTasks[index]['hour']);
              nonFormattedDate = myTasks[index]['date'];
              nonFormattedDate = nonFormattedDate.replaceAll('/', '-');

              //DateTime.parse is not working

              final Task thisTask = 
                Task(
                  creatorId: myTasks[index]['creatorId'], 
                  title: myTasks[index]['title'], 
                  details: myTasks[index]['details'], 
                  date: DateTime.parse(nonFormattedDate), 
                  hour: timeOfDay, 
                  taskType: taskType, 
                );
              return TaskItem(task: thisTask);
            },
          );
        }),
    );
  }
}