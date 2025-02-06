import 'package:flutter/material.dart';
import 'package:flutter_intern_project/models/task.dart';
import 'package:flutter_intern_project/screens/new_task.dart';

class TaskItem extends StatelessWidget{
  const TaskItem({super.key, required this.task, required this.docId});

  final Task task;
  final String docId;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){Navigator.push(context, MaterialPageRoute(builder: (ctx)=> NewTask(editTask: task, docId: docId,)));},
      child: Card(
        child:Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 18,right: 18),
          child: Row(
            spacing: 15,
            children: [
              Column(
                children: [
                  Icon(taskTypeIcons[task.taskType]),
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      task.title.toUpperCase()
                      ),
                    Text(task.details),
                  ],
                ),
              ),
              Column(
                children: [
                  if(task.date!=null)
                    Text("${task.date!.day}-${task.date!.month}-${task.date!.year}"),
                  if(task.hour!=null)
                     Text(task.hour!.format(context)),
                ],
              ),
              if(task.reminder!=null)
              if(task.reminder!=null)
                Icon(Icons.notifications),
          
            ],
          ),
        ),
      ),
    );
  }


}