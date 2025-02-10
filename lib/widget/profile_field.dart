import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_intern_project/providers/currentuser_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileField extends ConsumerStatefulWidget{
  const ProfileField({super.key, required this.fieldName, required this.fieldValue, this.condition});

  final String fieldName;
  final String fieldValue;
  final Function? condition;


  @override
  ConsumerState<ProfileField> createState() => _ProfileFieldState();
}

class _ProfileFieldState extends ConsumerState<ProfileField> { 
  bool _isEdit = false;
  final _formKey = GlobalKey<FormState>();
  String _fieldUpdated = '';

  void _saveField() async{

    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      //save changed value in firebase
      final currentUser = ref.watch(currentUserProvider);
      await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).update({widget.fieldName: _fieldUpdated});
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
      spacing: 20,
      children: [
        Text('${widget.fieldName.toUpperCase()}:', style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),),
        if(!_isEdit)
          Row(
            spacing: 20 ,
            children: [  
            Text(
              widget.fieldValue, 
              style: Theme.of(context).textTheme.bodyLarge!,
              overflow: TextOverflow.ellipsis,
            ),
            if(widget.fieldName != 'email' && widget.fieldName != 'password')
              IconButton(onPressed: ()=>_isEdit = !_isEdit, icon: Icon(Icons.edit),),
            if(widget.fieldName == 'password')
              SizedBox(width:50, height: 40,)
            

          ],),
        if(_isEdit)
            Expanded(
              child: Form(
                key: _formKey,

                child: Row(children: [  
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