

import 'package:flutter/material.dart';

enum ReminderType{
  set,
  daily,
  weekly
}

enum Weekday{
  monday,
  thuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

class Reminder{
  Reminder({required this.taskId, required this.frequency, this.date, this.hour, this.weekday});

  String taskId;
  ReminderType frequency;
  DateTime? date;
  TimeOfDay? hour;
  Weekday? weekday;

}