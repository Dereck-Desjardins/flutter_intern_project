import 'package:flutter/material.dart';
import 'package:flutter_intern_project/screens/connexion.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';



void main() {


  Future<void> pumpConnexionForm(WidgetTester tester) async{
    return tester.pumpWidget(
      ProviderScope(child:MaterialApp(
        home: ConnexionScreen(),
      ),
    ));
  }


  group('Submitting Connexion Form', (){
    testWidgets('Empty fields', (tester) async{
      
      await pumpConnexionForm(tester);
      await tester.tap(find.text('Login'));
      await tester.pump(Duration(seconds: 15));
      
      expect(find.text('Please enter a valid Email'), findsOne);
      expect(find.text('The password must be at least 8 characters'), findsOne);
     
    });

    test('test email',(){
      

       

    });

    
  });

}