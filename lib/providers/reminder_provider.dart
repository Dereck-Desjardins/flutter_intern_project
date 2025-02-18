import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intern_project/models/reminder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReminderManager{
  late Stream<List<Reminder>> _stream;

  
  DateTime? formatDateString(String date){
    if(date != ''){

      List<String> decomposedString = date.split('/');

      DateTime formattedDate = DateTime(int.parse(decomposedString[2]),int.parse(decomposedString[0]),int.parse(decomposedString[1]));
      return formattedDate;
    }
    return null;
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

  Weekday convertWeekDay(String dataWeekday){
    return Weekday.values.firstWhere((value)=>value.index == int.tryParse(dataWeekday));
  }

  ReminderType convertReminderType(String dataReminderType){
    return ReminderType.values.firstWhere((value)=>value.toString() == dataReminderType);
  }


  Future<void> _init() async{
    final Stream<QuerySnapshot> snapshot = FirebaseFirestore.instance.collection('reminders').snapshots();
    _stream = snapshot.map((reminder){
      final List<Reminder> reminderMap = reminder.docs.map((element){
        {
          print('new object');
          return Reminder(
            taskId: element.id, 
            frequency: convertReminderType(element['frequency']) , 
            date: element['date'] != '' ? formatDateString(element['date']):null,
            hour: element['hour'] != '' ?  convertTimeOfDay(element['hour']):null,
            weekday: element['weekday'] != '' ? convertWeekDay(element['weekday'].toString()):null,
          );
        }

      }).toList();
      return reminderMap;
    });
  }

  Stream <List<Reminder>> stream(){
    return _stream;
  }
}


final remindersDataProvider = StreamProvider.autoDispose <List<Reminder>> ((ref){

  final manager = ReminderManager();
  manager._init();
  return manager._stream; 
  
});