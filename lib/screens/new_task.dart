import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  String _enteredTitle = '';
  String _enteredDetails = '';
  DateTime? _selectedDate;
  TimeOfDay? _selectedHour = null;
  TaskType _selectedType = TaskType.work;
  bool onlyOnce = true;


  

  void _datePicker() async {
    final now = DateTime.now();
    final lastDate = DateTime(now.year + 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context, initialDate: now, firstDate: now, lastDate: lastDate);
    setState(() {
      if(_selectedDate == null){
        _selectedHour = null;
      }
      _selectedDate = pickedDate;
    });
  }

    void _hourPicker() async {
    final pickedHour = await showTimePicker(
        context: context, initialTime: TimeOfDay.now());
    setState(() {
      _selectedHour = pickedHour;
      
    });
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
    });

    Navigator.pop(context);
  }
  void _editTask() async{
    if(!_formKey.currentState!.validate()){
      return;
    }

    _formKey.currentState!.save();
    final currentUser = FirebaseAuth.instance.currentUser!;


    //recreate a new task in firestore
    FirebaseFirestore.instance.collection('tasks').doc(currentUser.uid).collection('mytasks').doc(widget.docId).update({
      'title': _enteredTitle,
      'details': _enteredDetails,
      'date': _selectedDate != null ? formatter.format(_selectedDate!):'',
      'hour': _selectedHour != null ? _selectedHour!.format(context): '',
      'tasktype': _selectedType.toString(),
      'createdAt': Timestamp.now(),
    });

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
      });
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
        child: Card(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
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
                    const SizedBox(
                      height: 20,
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
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      
                      mainAxisAlignment: _selectedDate==null? MainAxisAlignment.center:MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(_selectedDate == null
                            ? "No date selected"
                            : formatter.format(_selectedDate!)),
                        IconButton(
                          onPressed: _datePicker,
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
                            onPressed: _hourPicker,
                            icon: const Icon(
                              Icons.watch_later,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
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
                        Row(
                          children: [
                            if(!isEditing)
                              TextButton(onPressed:(){_formKey.currentState!.reset();} , child: Text("Reset")),
                            ElevatedButton(onPressed: isEditing? _editTask :_submitTask , child: Text(isEditing?"Update Task":"Create Task")),
                          ],
                        ),                    
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
