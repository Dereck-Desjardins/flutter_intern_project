import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UnverifiedScreen extends StatelessWidget{
  const UnverifiedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Your email is actually not verified', style: Theme.of(context).textTheme.titleLarge!,),
              const Text('Please check your mailbox to verify your account'),
              const SizedBox(height: 15,),
              ElevatedButton.icon(onPressed: () => FirebaseAuth.instance.signOut(), label: Text('Logout'),icon: Icon(Icons.logout),)
            ],
          ),
        ),
      ),
    );
  }  
}