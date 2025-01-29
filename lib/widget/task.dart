import 'package:flutter/material.dart';
import 'package:flutter_intern_project/models/task.dart';

class TaskItem extends StatelessWidget{
  const TaskItem({super.key, required this.task});

  final Task task;


  @override
  Widget build(BuildContext context) {
    return Text(task.title);
  }


}