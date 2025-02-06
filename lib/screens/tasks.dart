
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intern_project/models/reminder.dart';
import 'package:flutter_intern_project/models/task.dart';
import 'package:flutter_intern_project/screens/drawer.dart';
import 'package:flutter_intern_project/screens/new_task.dart';
import 'package:flutter_intern_project/screens/unverified.dart';
import 'package:flutter_intern_project/widget/task.dart';

class TasksScreen extends StatefulWidget{
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {

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


  DateTime? formatDateString(String date){
    if(date != ''){

      List<String> decomposedString = date.split('/');

      DateTime formattedDate = DateTime(int.parse(decomposedString[2]),int.parse(decomposedString[0]),int.parse(decomposedString[1]));
      return formattedDate;
    }
    return null;

  }

  Weekday convertWeekDay(String dataWeekday){
    return Weekday.values.firstWhere((value)=>value.index == int.tryParse(dataWeekday));
  }

  TaskType convertTaskType(String dataType){
    return TaskType.values.firstWhere((value)=>value.toString() == dataType);
  }

  ReminderType convertReminderType(String dataReminderType){
    return ReminderType.values.firstWhere((value)=>value.toString() == dataReminderType);
  }

  TimeOfDay? convertTimeOfDay(String time){
    if(time!= ''){
      if(time.split(' ')[1] == 'PM'){
        return TimeOfDay(hour: int.parse(time.split(":")[0])+12, minute: int.parse(time.split(":")[1].split(' ')[0]));
      }
      return TimeOfDay(hour: int.parse(time.split(":")[0]), minute: int.parse(time.split(":")[1].split(' ')[0]));
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
        child: StreamBuilder(
          stream: myTasks, 
          builder: (ctx, tasksSnapshots){
          if(tasksSnapshots.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }

          if(!FirebaseAuth.instance.currentUser!.emailVerified){
            return UnverifiedScreen();
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
                bool hasReminder = myTasks[index]['hasReminder'];
                Reminder? thisTaskReminder;
                if(hasReminder){
                  var taskReminder = FirebaseFirestore.instance.collection('reminders').doc(myTasks[index].id).snapshots();
                  return StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
                    stream: taskReminder,
                    builder: (ctx, snapshot){

                      if (snapshot.hasError) return Text('Error while retireving data');

                      if(snapshot.hasData){
                        var data = snapshot.data!.data();
                        thisTaskReminder = 
                          Reminder(
                            taskId: myTasks[index].id, 
                            frequency: convertReminderType(data!['frequency']) , 
                            date: data['date'] != null ? formatDateString(data['date']):null,
                            hour: data['hour'] != null ?  convertTimeOfDay(data['hour']):null,
                            weekday: data['weekday'] != null ? convertWeekDay(data['weekday'].toString()):null,
                          );
                        final Task thisTask = 
                          Task(
                            creatorId: myTasks[index]['creatorId'], 
                            title: myTasks[index]['title'], 
                            details: myTasks[index]['details'], 
                            date: formattedDate, 
                            hour: timeOfDay, 
                            taskType: taskType, 
                            reminder: thisTaskReminder
                          );
                        return Dismissible(
                          onDismissed: (direction){removeTask(myTasks[index].id);} ,
                          key: ValueKey(myTasks[index]),
                          child: TaskItem(task: thisTask, docId: myTasks[index].id,)
                        );
                      }
                      return Center(child: CircularProgressIndicator(),);
                    }
                    
                  );
                }
                else{
                  final Task thisTask = 
                  Task(
                    creatorId: myTasks[index]['creatorId'], 
                    title: myTasks[index]['title'], 
                    details: myTasks[index]['details'], 
                    date: formattedDate, 
                    hour: timeOfDay, 
                    taskType: taskType, 
                    reminder: null,
                  );
                  return Dismissible(
                    onDismissed: (direction){removeTask(myTasks[index].id);} ,
                    key: ValueKey(myTasks[index]),
                    child: TaskItem(task: thisTask, docId: myTasks[index].id,)
                  );
                }
              },
            );
        }),
      ),
    );
  }
}