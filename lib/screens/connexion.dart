import 'package:flutter/material.dart';

class ConnexionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ConnexionScreenState();
  }
}

class ConnexionScreenState extends State<ConnexionScreen> {
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
                padding: const EdgeInsets.all(10),
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.none,
                        autocorrect: false,
                        validator: (value){
                          //creer une fonction qui reconnait le format d'un email
                        },
                      ),
                      const SizedBox(height: 20,),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        validator: (value){
                          // creer une fonction qui valide le mdp
                        } 
                        ,
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          Expanded(child: ElevatedButton(onPressed: (){}, child: Text('test elevatedbtn'))),
                          SizedBox(width: 5,),
                          Expanded(child: TextButton(onPressed: (){}, child: Text('test textbtn')))
                        ],
                      )
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
