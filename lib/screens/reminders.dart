import 'package:flutter/material.dart';
import 'package:flutter_intern_project/models/reminder.dart';
import 'package:flutter_intern_project/providers/currentuser_provider.dart';
import 'package:flutter_intern_project/providers/reminder_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RemindersScreen extends ConsumerWidget{
  const RemindersScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allReminders = ref.watch(remindersDataProvider);
    //final currentUserUid = ref.watch(currentUserProvider)!.uid;

    final myReminders = [];
    allReminders.when(
      data: (reminders){
        myReminders.add(reminders.where((singleReminder) => singleReminder.frequency == ReminderType.set));
      },  
      error: (e,st){return Center(child: Text('Failed to load reminders',),);}, 
      loading: (){return Center(child: CircularProgressIndicator(),);}
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Reminders', style: TextStyle(color: Theme.of(context).colorScheme.primaryContainer)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: myReminders.isNotEmpty ? ListView.builder(
          itemCount: myReminders.length,
          itemBuilder: (ctx, snapshot)=> Text('allo')
          ) : Center(child: Text('no reminders'),),
      )
    );
  }

}