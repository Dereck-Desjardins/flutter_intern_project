import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intern_project/models/reminder.dart';
import 'package:flutter_intern_project/models/task.dart';

class NewTask extends StatefulWidget {
  const NewTask({super.key, this.editTask, this.docId});
  

  final Task? editTask;
  final String? docId;

  @override
  State<StatefulWidget> createState() {
    return NewTaskState();
  }
}

class NewTaskState extends State<NewTask> {
  final _formKey = GlobalKey<FormState>();
  final _reminderFormKey = GlobalKey<FormState>();
  String _enteredTitle = '';
  String _enteredDetails = '';
  DateTime? _selectedDate;
  TimeOfDay? _selectedHour;
  TaskType _selectedType = TaskType.work;
  bool onlyOnce = true;
  bool createReminder = false;
  
  DateTime? _selectedReminderDate;
  TimeOfDay? _selectedReminderHour;
  Weekday? _selectedReminderWeekday;
  ReminderType _selectedReminderType = ReminderType.set;

  int _dayToNumber(Weekday day){
    return day.index;
  }
  

  void _datePicker(String datePickerType) async {
    final now = DateTime.now();
    final lastDate = DateTime(now.year + 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: datePickerType == 'task' || _selectedReminderDate == null ? now : _selectedReminderDate , 
        firstDate: now , 
        lastDate: datePickerType == 'task' || _selectedDate == null ? lastDate : _selectedDate!
        );

    if(datePickerType == 'task'){
      setState(() {
        if(_selectedDate == null){
          _selectedHour = null;
        }
        _selectedDate = pickedDate;
        _selectedReminderDate = null;
      });
    }
    else{
      setState(() {
        if(_selectedReminderDate == null){
          _selectedReminderHour = null;
        }
        _selectedReminderDate = pickedDate;
      });
    }
  }

    void _hourPicker(String hourPickerType) async {
    final pickedHour = await showTimePicker(
        context: context, 
        initialTime:hourPickerType == 'task' || _selectedReminderHour == null ? TimeOfDay.now():TimeOfDay(hour: _selectedReminderHour!.hour, minute: _selectedReminderHour!.minute));

    if(hourPickerType == 'task'){
      setState(() {
        _selectedHour = pickedHour;
      });
    }
    else{
      setState(() {
        _selectedReminderHour = pickedHour;
      });
    }

  }

  void _submitTask() async{
    if(!_formKey.currentState!.validate()){
      return;
    }
    _formKey.currentState!.save();

    final currentUser = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance.collection('tasks').doc(currentUser.uid).collection('mytasks').add({
      'creatorId': currentUser.uid,
      'title': _enteredTitle,
      'details': _enteredDetails,
      'date': _selectedDate != null ? formatter.format(_selectedDate!):'',
      'hour': _selectedHour != null ? _selectedHour!.format(context): '',
      'tasktype': _selectedType.toString(),
      'createdAt': Timestamp.now(),
      'hasReminder': false
    });

    Navigator.pop(context);
  }
  void _editTask() async{
    if(!_formKey.currentState!.validate()){
      return;
    }

    _formKey.currentState!.save();
    final currentUser = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance.collection('tasks').doc(currentUser.uid).collection('mytasks').doc(widget.docId).update({
      'title': _enteredTitle,
      'details': _enteredDetails,
      'date': _selectedDate != null ? formatter.format(_selectedDate!):'',
      'hour': _selectedHour != null ? _selectedHour!.format(context): '',
      'tasktype': _selectedType.toString(),
      'createdAt': Timestamp.now(),
      'hasReminder': createReminder
    });

    if(createReminder){
      FirebaseFirestore.instance.collection('reminders').doc(widget.docId).set({
        'userId':FirebaseAuth.instance.currentUser!.uid,
        'frequency': _selectedReminderType.toString(),
        'date': _selectedReminderDate != null ? formatter.format(_selectedReminderDate!):'',
        'hour': _selectedReminderHour != null ? _selectedReminderHour!.format(context): '',
        'weekday': _selectedReminderWeekday != null ? _dayToNumber(_selectedReminderWeekday!):'',
      });
    }

    if(!createReminder && widget.editTask!.reminder != null){
        FirebaseFirestore.instance.collection('reminders').doc(widget.docId).delete();
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    final bool isEditing = widget.editTask != null;

    if(onlyOnce){
      setState(() {
        isEditing ? _selectedDate = widget.editTask!.date : _selectedDate = null; 
        isEditing ? _selectedHour = widget.editTask!.hour : _selectedHour = null; 
        isEditing ? _selectedType = widget.editTask!.taskType : null;
        isEditing ? _selectedReminderDate = widget.editTask!.date : _selectedReminderDate = null;
        isEditing ? _selectedReminderHour = widget.editTask!.hour : _selectedReminderHour = null; 
      });
      if(isEditing){
        if(widget.editTask!.reminder != null){
          setState(() {
            _selectedReminderType = widget.editTask!.reminder!.frequency;
            _selectedReminderDate = widget.editTask!.reminder!.date;
            _selectedReminderHour = widget.editTask!.reminder!.hour;
            _selectedReminderWeekday = widget.editTask!.reminder!.weekday;
            createReminder = true;
          });
          
        }
      }
      


      onlyOnce = false;
    }


    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        title: Text(isEditing?'Edit Task':'New Task', style:  TextStyle(color: Theme.of(context).colorScheme.primaryContainer)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            
            //Task Form 

            Card(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      spacing: 20,
                      children: [
                        TextFormField(
                          initialValue: isEditing? widget.editTask!.title:"",
                          maxLength: 30,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            
                          ),
                          validator: (value) {
                            if (value == null || value.trim().length < 3) {
                              return 'Enter a valid title';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            setState(() {
                              _enteredTitle = newValue!;
                            });
                          },
                        ),

                        TextFormField(
                          initialValue: isEditing? widget.editTask!.details:"",
                          maxLength: 60,
                          decoration: InputDecoration(
                            labelText: 'Details',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().length < 3) {
                              return 'Enter some valid details';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            setState(() {
                              _enteredDetails = newValue!;
                            });
                          }),
                        Row(
                          
                          mainAxisAlignment: _selectedDate==null? MainAxisAlignment.center:MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_selectedDate == null
                                ? "No date selected"
                                : formatter.format(_selectedDate!)),
                            IconButton(
                              onPressed: (){_datePicker('task');},
                              icon: const Icon(
                                Icons.calendar_month,
                              ),
                            ),
                            if (_selectedDate != null)
                              Text(_selectedHour == null
                                  ? "No hour selected"
                                  : _selectedHour!.format(context)),
                            if (_selectedDate != null)
                              IconButton(
                                onPressed: (){_hourPicker('task');},
                                icon: const Icon(
                                  Icons.watch_later,
                                ),
                              ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButton(
                                value: _selectedType,
                                items: TaskType.values
                                    .map(
                                      (type) => DropdownMenuItem(
                                        value: type,
                                        child: Text(
                                          type.name.toUpperCase().toString(),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value == null) {
                                    return;
                                  }
                                  setState(() {
                                    _selectedType = value;
                                  }
                                );
                              }
                            ),
                            if(isEditing)
                              ElevatedButton(
                                onPressed: (){
                                  setState(() {
                                    createReminder = !createReminder;
                                  });
                                  
                                }, 
                                child: Text(!createReminder ? 'Add a new reminder ':'Remove the reminder')
                              ),
                            if(!isEditing)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [  
                                    TextButton(onPressed:(){_formKey.currentState!.reset();} , child: Text("Reset")),
                                    ElevatedButton(onPressed: isEditing? _editTask :_submitTask , child: Text(isEditing?"Update Task":"Create Task")),
                                  ],
                              ),  
                          ],
                        ),
                        if(isEditing)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(),
                                  if(!isEditing)
                                    TextButton(onPressed:(){_formKey.currentState!.reset();} , child: Text("Reset")),
                                  ElevatedButton(onPressed: isEditing? _editTask :_submitTask , child: Text(isEditing?"Update Task":"Create Task")),
                                ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            //Reminder Form


            if(createReminder)
              Card(
                child: Padding(
                  padding: EdgeInsets.only(left: 50, right: 50, top: 16, bottom: 16),
                  child: 
                    Form(
                    key: _reminderFormKey,
                    child: Column(
                      spacing: 10,
                      children: [
                        Text('Create your Reminder', style: Theme.of(context).textTheme.bodyLarge,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          
                          children: [
                            Column(
                              children: [
                                DropdownButton(
                                  value: _selectedReminderType,
                                  items: ReminderType.values
                                        .map(
                                          (type) => DropdownMenuItem(
                                            value: type,
                                            child: Text(
                                              type.name.toUpperCase().toString(),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      if (value == null) {
                                        return;
                                      }
                                      if(_selectedReminderType == ReminderType.weekly){
                                        _selectedReminderDate = null;
                                      }
                                      setState(() {
                                        _selectedReminderType = value;
                                      }
                                    );
                                  }
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                if(_selectedReminderType == ReminderType.set)
                                Row(
                                  children: [
                                    Text('Date: '),
                                    Text(_selectedReminderDate == null
                                        ? "No date selected"
                                        : formatter.format(_selectedReminderDate!)),
                                    IconButton(
                                      onPressed: (){_datePicker('reminder');},
                                      icon: const Icon(
                                        Icons.calendar_month,
                                      ),
                                    ),  
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Hour: '),
                                    Text(_selectedReminderHour == null
                                      ? "No hour selected"
                                      : _selectedReminderHour!.format(context)),
                                    
                                    IconButton(
                                      onPressed: (){_hourPicker('reminder');},
                                      icon: const Icon(
                                        Icons.watch_later,
                                      ),
                                    ),
                                  ],
                                ),
                                if(_selectedReminderType == ReminderType.weekly)
                                  Row(
                                    children: [
                                      Text('Weekday: '),
                                       DropdownButton(
                                        value: _selectedReminderWeekday,
                                        items: Weekday.values
                                              .map(
                                                (type) => DropdownMenuItem(
                                                  value: type,
                                                  child: Text(
                                                    type.name.toUpperCase().toString(),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (value) {
                                            if (value == null) {
                                              return;
                                            }
                                            setState(() {
                                              _selectedReminderWeekday = value;
                                            }
                                          );
                                        }
                                      ),  
                                    ]
                                  ) ,
                              ],
                              ),
                            ],
                          ),
                      ],
                    )
                    ),
                ),
              )
          ],
        ),
        


      ),
    );
  }
}
