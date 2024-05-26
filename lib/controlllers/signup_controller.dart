import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/screens/splash_screen.dart';

class SignupController {
  static Future<void> createAccount({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String country,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      SnackBar sucessSnackbar = SnackBar(
        content: Text("Account has been created Successfully"),
      );
      var userId = FirebaseAuth.instance.currentUser!.uid;
      var db = FirebaseFirestore.instance;
      Map<String, dynamic> data = {
        "name": name,
        "country": country,
        "email": email,
        "id": userId.toString(),
      };
      try {
        await db.collection("users").doc(userId.toString()).set(data);
      } catch (e) {
        print(e.toString());
      }
      ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return SplashScreen();
      }), (route) {
        return false;
      });
    } catch (e) {
      debugPrint(e.toString());
      SnackBar messageSnackbar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(e.toString()),
      );
      ScaffoldMessenger.of(context).showSnackBar(messageSnackbar);
    }
  }
}
