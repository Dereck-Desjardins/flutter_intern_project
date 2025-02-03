import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RemindersScreen extends StatelessWidget{
  const RemindersScreen({super.key});




  @override
  Widget build(BuildContext context) {
    final myReminders = FirebaseFirestore.instance.collection('tasks').doc(FirebaseAuth.instance.currentUser!.uid).collection('mytasks').snapshots();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Reminders', style: TextStyle(color: Theme.of(context).colorScheme.primaryContainer)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: myReminders, 
          builder: (ctx, remindersSnapshots){
          if(remindersSnapshots.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
        
          if(!remindersSnapshots.hasData || remindersSnapshots.data!.docs.isEmpty){
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
        
          if(remindersSnapshots.hasError){
            return Center(child: Text('Something went wrong...'),);
          }
        
            final myReminders = remindersSnapshots.data!.docs;
            return ListView.builder(
              itemCount: myReminders.length,
              itemBuilder: (context, index) {

                // Create each reminders widget 


              //   TaskType taskType = TaskType.chore;
              //   TimeOfDay? timeOfDay;
              //   taskType = convertTaskType(myTasks[index]['tasktype']);
              //   timeOfDay = convertTimeOfDay(myTasks[index]['hour']);
              //   DateTime? formattedDate = formatDateString(myTasks[index]['date']);
              //   final Task thisTask = 
              //     Task(
              //       creatorId: myTasks[index]['creatorId'], 
              //       title: myTasks[index]['title'], 
              //       details: myTasks[index]['details'], 
              //       date: formattedDate, 
              //       hour: timeOfDay, 
              //       taskType: taskType, 
              //     );
              //   return Dismissible(
              //     onDismissed: (direction){removeTask(myTasks[index].id);} ,
              //     key: ValueKey(myTasks[index]),
              //     child: TaskItem(task: thisTask, docId: myTasks[index].id,)
              //     );
              },
            );
          }),
      ),
    );
  }

}