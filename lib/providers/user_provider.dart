import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider extends ChangeNotifier {
  String userName = "test";
  String userEmail = "tset1";
  String userId = "testeid";
  var db = FirebaseFirestore.instance;
  Map<String, dynamic>? userData = {};
  void getUserDetails() {
    var authUser = FirebaseAuth.instance.currentUser;
    db.collection("users").doc(authUser!.uid).get().then((value) {
      userData = value.data();
      userName = userData?["name"] ?? "";
      userEmail = userData?["email"] ?? "";
      userId = userData?["id"] ?? "";
      notifyListeners();
    });
  }
}
