import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intern_project/models/task.dart';
import 'package:riverpod/riverpod.dart';


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

TimeOfDay convertTimeOfDay(String time){
  if(time.split(' ')[1] == 'PM'){
    return TimeOfDay(hour: int.parse(time.split(":")[0])+12, minute: int.parse(time.split(":")[1].split(' ')[0])+12);
  }
  return TimeOfDay(hour: int.parse(time.split(":")[0]), minute: int.parse(time.split(":")[1]));
}

Future<List<Task>> getTasks() async{
  final List<Task> myTasks = [];
  TaskType taskType = TaskType.chore;
  TimeOfDay? timeOfDay;

  //final allTasksData = await FirebaseFirestore.instance.collection('tasks').doc(FirebaseAuth.instance.currentUser!.uid).collection('mytasks').snapshots();
    // allTasksData.docs.forEach((taskData){
    //   taskType = convertTaskType(taskData['tasktype']);
    //   timeOfDay = convertTimeOfDay(taskData['hour']);
    //   myTasks.add(
    //     Task(
    //       creatorId: taskData['creatorId'], 
    //       title: taskData['title'], 
    //       details: taskData['details'], 
    //       date: DateTime.parse(taskData['date']), 
    //       hour: timeOfDay, 
    //       taskType: taskType, 
    //       ));
    // });
  
  return myTasks;
}

final filteredTasks = Provider((ref){
  return  FirebaseFirestore.instance.collection('tasks').doc(FirebaseAuth.instance.currentUser!.uid).collection('mytasks').snapshots();
});