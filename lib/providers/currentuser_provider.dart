import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserProvider = Provider.autoDispose ((ref){
  if(FirebaseAuth.instance.currentUser != null){
    return FirebaseAuth.instance.currentUser;
  }
  return null;

});