import 'package:flutter/material.dart';

class ConnexionScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ConnexionScreenState();
  }
}


class ConnexionScreenState extends State<ConnexionScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }
}