import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

final _firebase = FirebaseAuth.instance;

class ConnexionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ConnexionScreenState();
  }
}

class ConnexionScreenState extends State<ConnexionScreen> {
  final _formKey = GlobalKey<FormState>();

  var _formMode = 'connect';
  var _enteredMail = '';
  var _enteredPassword = '';

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    _formKey.currentState!.reset();
    try {
      if(_formMode != 'connect'){
        await _firebase.createUserWithEmailAndPassword(
          email: _enteredMail, 
          password: _enteredPassword
        );
      }
      else{
        await _firebase.signInWithEmailAndPassword(
          email: _enteredMail, 
          password: _enteredPassword
        );
      }
      
    } on FirebaseAuthException catch (error) {
      if (error.code == "email-already-in-use") {
        //...
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? "Authentication failed")));
    }
  }

  String? _validateMail(String email) {
    //Verification du email avec EmailValidator
    if (EmailValidator.validate(email)) {
      return null;
    }
    ;
    return 'Please enter a valid Email';
  }

  String? _validatePassword(String password) {
    //Complexifier la demande de mot de passe possible
    if (password.trim().length < 8) {
      return 'The password must be at least 8 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 30,
              color: Theme.of(context).colorScheme.secondaryContainer,
              margin: EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        _formMode == 'connect' ? 'Login': 'Create an account',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.none,
                        autocorrect: false,
                        validator: (value) {
                          if (value != null) {
                            return _validateMail(value);
                          }
                          return 'Please enter an Email to this field';
                        },
                        onSaved: (value) {
                          _enteredMail = value!;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value != null) {
                            return _validatePassword(value);
                          }
                          return 'Please enter a password to this field';
                        },
                        onSaved: (value) {
                          _enteredPassword = value!;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                _formKey.currentState!.reset();
                              },
                              child: Text('Reset'),
                            )
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _submit, 
                              child: Text(_formMode == 'connect' ? 'Login':"Submit"),
                            )
                          ),
                        ],
                      ),
                      Row(
                        
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                if(_formMode == 'connect'){
                                  setState(() {
                                    _formMode = 'create';
                                  });
                                }
                                else{
                                  setState(() {
                                    _formMode = 'connect';
                                  });
                                  
                                }
                              },
                              child: Text(_formMode == 'connect' ? 'Create an account': 'Go to Log in', style: Theme.of(context).textTheme.labelSmall),
                            ),
                          ),
                        ],
                      ),
                    ],
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
