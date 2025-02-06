import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intern_project/widget/profile_field.dart';

class ProfileScreen extends StatefulWidget{
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = '';
  String _lastName = '';
  String _email = '';
  String _password = '';

  bool _nameEdit = false;
  bool _lastNameEdit = false;
  bool _emailEdit = false;
  bool _passwordEdit = false;


  void _getProfileInfos() async{
    final userProfileInfos = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    if(this.mounted){
      setState(() {
        _userName = userProfileInfos['name'];  
        _lastName = userProfileInfos['surname'];
        _password = userProfileInfos['password'];
        _email = userProfileInfos['email'];
      });
    }

  }

  
  
  @override
  Widget build(BuildContext context) {
       _getProfileInfos();

        return Scaffold(
          backgroundColor:Theme.of(context).colorScheme.primaryContainer ,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text('Profile', style: TextStyle(color: Theme.of(context).colorScheme.primaryContainer)),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 5, left: 5, right: 10),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      spacing: 5,
                      children: [
                        ProfileField(fieldName: 'email', fieldValue: _email),
                        ProfileField(fieldName: 'name', fieldValue: _userName, condition: (value)=> value!.length>=3&&value!.length<20,),
                        ProfileField(fieldName: 'surname', fieldValue: _lastName, condition: (value)=> value!.length>=3&&value!.length<20,),
                        ProfileField(fieldName: 'password', fieldValue: _password, condition: (value)=> value!.length>=8&&value!.length<20,),    
                        Row(
                          children: [

                          ],
                        ) 
                      ],
                    ),
                  ),
                ),
              ),
          ),
          );

        
  }
}