
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intern_project/models/task.dart';
import 'package:flutter_intern_project/screens/drawer.dart';
import 'package:flutter_intern_project/screens/new_task.dart';
import 'package:flutter_intern_project/widget/task.dart';

class TasksScreen extends StatelessWidget{
  const TasksScreen({super.key});


  DateTime? formatDateString(String date){
    if(date != ''){

      List<String> decomposedString = date.split('/');

      DateTime formattedDate = DateTime(int.parse(decomposedString[2]),int.parse(decomposedString[0]),int.parse(decomposedString[1]));
      return formattedDate;
    }
    return null;

  }

  TaskType convertTaskType(String dataType){
        if( dataType == 'TaskType.personnal'){
          return TaskType.personnal;
        }
        else if( dataType == 'TaskType.work'){
          return  TaskType.work;
        }
        else if( dataType == 'TaskType.event'){
          return  TaskType.event;
        }
        else if( dataType == 'TaskType.chore'){
          return  TaskType.chore;
        }
        return TaskType.chore;
  }

  TimeOfDay? convertTimeOfDay(String time){
    if(time!= ''){
      if(time.split(' ')[1] == 'PM'){
        return TimeOfDay(hour: int.parse(time.split(":")[0])+12, minute: int.parse(time.split(":")[1].split(' ')[0]));
      }
      return TimeOfDay(hour: int.parse(time.split(":")[0]), minute: int.parse(time.split(":")[1]));
    }
    return null;
  }



  @override
  Widget build(BuildContext context) {
    final myTasks = FirebaseFirestore.instance.collection('tasks').doc(FirebaseAuth.instance.currentUser!.uid).collection('mytasks').snapshots();
    
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
        ],
      ),
      drawer: mainDrawer() ,
      body: StreamBuilder(
        stream: myTasks, 
        builder: (ctx, tasksSnapshots){
        if(tasksSnapshots.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }

        if(!tasksSnapshots.hasData || tasksSnapshots.data!.docs.isEmpty){
          return Center(child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('You currently have not task planned!', style: Theme.of(context).textTheme.titleLarge),
                Text('You can add one by pressing the + button in the appbar', style: Theme.of(context).textTheme.titleSmall)
              ],
            )
           ,);
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
              taskType = convertTaskType(myTasks[index]['tasktype']);
              timeOfDay = convertTimeOfDay(myTasks[index]['hour']);
              DateTime? formattedDate = formatDateString(myTasks[index]['date']);
              final Task thisTask = 
                Task(
                  creatorId: myTasks[index]['creatorId'], 
                  title: myTasks[index]['title'], 
                  details: myTasks[index]['details'], 
                  date: formattedDate, 
                  hour: timeOfDay, 
                  taskType: taskType, 
                );
              return Dismissible(
                onDismissed: (direction){removeTask(myTasks[index].id);} ,
                key: ValueKey(myTasks[index]),
                child: TaskItem(task: thisTask, docId: myTasks[index].id,)
                );
            },
          );
        }),
    );
  }
}