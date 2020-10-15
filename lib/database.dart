import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods {
  Future<void> addTeacherInfo(teacherData) async {
    var firebaseUser = await FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection("teachers").doc(firebaseUser.uid).set(teacherData).catchError((e) {
      print(e.toString());
    });
  }
  getTeacherInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("teachers")
        .where("email", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  


}