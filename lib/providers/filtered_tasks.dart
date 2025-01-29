import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_intern_project/models/task.dart';
import 'package:riverpod/riverpod.dart';

final filteredTasks = Provider((ref){
  final List<Task> myTasks = [];

  FirebaseFirestore.instance.collection('tasks').get();

  return myTasks;
});