import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredMail = '';


  void _sendPasswordReset(){
    
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    _formKey.currentState!.reset();

    FirebaseAuth.instance.sendPasswordResetEmail(email: _enteredMail);
    
    ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Email sent to $_enteredMail')));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: AppBar(
        title: Text('Password Retrieval', style: TextStyle(color: Colors.white),),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:15, right: 15, top: 250),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      spacing: 15,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                          autocorrect: false,
                          validator: (value) {
                            if (value != null) {
                              if(EmailValidator.validate(value)){
                                return null;
                              }
                            }
                            return 'Please enter an Email to this field';
                          },
                          onSaved: (value) {
                            _enteredMail = value!;
                          },
                        ),
                        ElevatedButton(onPressed: _sendPasswordReset, child: Text('Send reset password to this email'))
                      ],
                    )
                  
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}