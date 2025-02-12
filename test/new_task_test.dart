
import 'package:flutter/material.dart';
import 'package:flutter_intern_project/screens/new_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';




void main() {

  Future<void> pumpTaskForm(WidgetTester tester) async{
    return tester.pumpWidget(
      ProviderScope(child:MaterialApp(
        home: NewTask(),
      ),
    ));
  }

 // Task(creatorId: 'a', title: 'a', details: 'a', date: DateTime.now(), hour: TimeOfDay.now(), taskType: TaskType.chore, id: 'a')
  group('Submitting New Task Form', (){
    testWidgets('Correct Task Form', (tester)async{
        
      await pumpTaskForm(tester);
      
      final titleField = find.ancestor(of: find.text('Title'), matching: find.byType(TextFormField));
      await tester.enterText(titleField, 'Title');
      await tester.pump(Duration(seconds: 10));
      
      final detailsField = find.ancestor(of: find.text('Details'), matching: find.byType(TextFormField));
      await tester.enterText(detailsField, 'Details');
      await tester.pump(Duration(seconds: 10));


      // When i tap it should use a firebase func that doesnt exist in this context
      await tester.tap(find.text('Create Task'));
      await tester.pump(Duration(seconds: 15));

      expect(find.text('New Task'), findsOne);
      expect(find.text('Enter a valid title'), findsNothing);
      expect(find.text('Enter some valid details'), findsNothing);
      

    });


    testWidgets('Empty Task Form', (tester)async{
        
      await pumpTaskForm(tester);

      await tester.tap(find.text('Create Task'));
      await tester.pump(Duration(seconds: 15));


      expect(find.text('Enter a valid title'), findsOne);
      expect(find.text('Enter some valid details'), findsOne);
      
    });


  });
  
}