import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intern_project/models/reminder.dart';
import 'package:flutter_intern_project/models/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskManager{
  late Stream<List<Task>> _stream;
  
  
  DateTime? formatDateString(String date){
    if(date != ''){

      List<String> decomposedString = date.split('/');

      DateTime formattedDate = DateTime(int.parse(decomposedString[2]),int.parse(decomposedString[0]),int.parse(decomposedString[1]));
      return formattedDate;
    }
    return null;
  }

  TaskType convertTaskType(String dataType){
    return TaskType.values.firstWhere((value)=>value.toString() == dataType);
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

//CREER UN PROVIDER QUI VA VERIFIER LES CHANGEMENTS DE currentUser.uid

  Future<void> _init() async{
    
    final Stream<QuerySnapshot> snapshot = FirebaseFirestore.instance.collection('tasks').doc(FirebaseAuth.instance.currentUser!.uid).collection('mytasks').snapshots();


    _stream = snapshot.map((item){
      final List<Task> taskMap = item.docs.map((element){
        {
          TaskType taskType = TaskType.chore;
          TimeOfDay? timeOfDay;
          taskType = convertTaskType(element['tasktype']);
          timeOfDay = convertTimeOfDay(element['hour']);
          DateTime? formattedDate = formatDateString(element['date']);
          bool hasReminder = element['hasReminder'];

          if(hasReminder){
            return Task(
              id: element.id,
              creatorId: element['creatorId'], 
              title: element['title'], 
              details: element['details'], 
              date: formattedDate, 
              hour: timeOfDay, 
              taskType: taskType, 
              reminder: Reminder(taskId: element.id, frequency: ReminderType.set),
            );
          }
          else{
            return Task(
              id: element.id,
              creatorId: element['creatorId'], 
              title: element['title'], 
              details: element['details'], 
              date: formattedDate, 
              hour: timeOfDay, 
              taskType: taskType, 
              reminder: null,
            );
          }
        }
      }).toList();
      return taskMap;
    });
  }

  Stream<List<Task>> stream(){
    return _stream;
  }
}


final tasksDataProvider = StreamProvider.autoDispose <List<Task>> ((ref){
  
  final manager = TaskManager();
  manager._init();
  return manager._stream; 
  
});