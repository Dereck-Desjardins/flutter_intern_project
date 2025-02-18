import 'package:flutter/material.dart';
import 'package:flutter_intern_project/models/reminder.dart';
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

const taskTypeIcons = {
  TaskType.work: Icons.work,
  TaskType.chore: Icons.shopping_cart,
  TaskType.personnal: Icons.person,
  TaskType.event: Icons.control_camera_rounded,
};

class Task{
  Task({required this.creatorId, required this.title, required this.details, required this.date, required this.hour, required this.taskType, this.reminder, required this.id});

  final String id;
  final String creatorId;
  final String title;
  final String details;
  final DateTime? date;
  final TimeOfDay? hour;
  final TaskType taskType;
  Reminder? reminder;

  final DateTime creation = DateTime.now();

  

}