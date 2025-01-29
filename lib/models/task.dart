import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

enum TaskType{
  work,
  chore,
  personnal,
  event,
}

class Task{
  Task({required this.creatorId, required this.title, required this.details, required this.date, required this.hour, required this.taskType}): id = uuid.v4();

  final String id;
  final String creatorId;
  final String title;
  final String details;
  final DateTime? date;
  final TimeOfDay? hour;
  final TaskType taskType;

  final DateTime creation = DateTime.now();

  String get getFormattedDate{
    if(date != null){
      return formatter.format(date!);
    }
    return 'No assigned date';
  }

}