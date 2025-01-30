import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intern_project/screens/profile.dart';

class mainDrawer extends StatelessWidget{
  const mainDrawer ({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        children: [
          DrawerHeader(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
            ),
            
            child: Row(children: [
              Text('Menu', style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Theme.of(context).colorScheme.primaryContainer,
              )),
            ]),

          ),
          Column(
            children: [
              ListTile(
                leading: Icon(Icons.person,
                
                ),
                title: Text('Profil', style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ProfileScreen()),);
                },
              ),
              const SizedBox(height: 15,),
              
              
              ListTile(
                leading: Icon(Icons.notification_add,
                
                ),
                title: Text('Reminders', style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,),
                ),
              ),
              const SizedBox(height: 15,),
              
              
              ListTile(
                leading: Icon(Icons.logout,
                
                ),
                title: Text('Logout', style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,),
                ),
                onTap: (){FirebaseAuth.instance.signOut();},
              ),
            ],
          )

        ],
      ),
      
    );
  }
}