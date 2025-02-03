import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileField extends StatefulWidget{
  const ProfileField({super.key, required this.fieldName, required this.fieldValue, this.condition});

  final String fieldName;
  final String fieldValue;
  final Function? condition;


  @override
  State<ProfileField> createState() => _ProfileFieldState();
}

class _ProfileFieldState extends State<ProfileField> { 
  bool _isEdit = false;
  final _formKey = GlobalKey<FormState>();
  String _fieldUpdated = '';

  void _saveField() async{

    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      //save changed value in firebase
      final currentUser = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({widget.fieldName: _fieldUpdated});
      if(widget.fieldName == 'password'){
        currentUser.updatePassword(_fieldUpdated);
      }
      _isEdit = !_isEdit;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Your ${widget.fieldName} has been updated')));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${widget.fieldName.toUpperCase()}:', style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),),
        if(!_isEdit)
          Row(children: [  
            Text(widget.fieldValue, style: Theme.of(context).textTheme.bodyLarge!,),
            SizedBox(width: 60,),
            if(widget.fieldName != 'email')
              IconButton(onPressed: ()=>_isEdit = !_isEdit, icon: Icon(Icons.edit),),
            if(widget.fieldName == 'email')
              const SizedBox(width: 48, height: 50,),
            
          ],),
        if(_isEdit)
            Expanded(
              child: Form(
                key: _formKey,

                child: Row(children: [  
                    const SizedBox(width: 15,),
                    Expanded(child: 
                      TextFormField(
                        initialValue: widget.fieldValue, 
                        validator: (value) {
                          if(value!=null  &&  widget.condition!(value)){
                            return null;
                          }
                          return 'Please enter a valid ${widget.fieldName}';
                        },
                        onSaved: (newValue) => _fieldUpdated = newValue!,
                      ),
                    ),
                    IconButton(onPressed: ()=>_isEdit = !_isEdit, icon: Icon(Icons.cancel_outlined),),
                    IconButton(onPressed: (){_saveField();}, icon: Icon(Icons.check),),
                  ],
                ),
              ),
            ),                                 
      ],
    );
  }
}