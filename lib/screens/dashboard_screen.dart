import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/screens/profile_screen.dart';
import 'package:globalchat/screens/splash_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GlobalChat"),
      ),
      drawer: Drawer(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 20),
              ListTile(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return ProfileScreen();
                    }),
                  );
                },
                leading: Icon(Icons.person),
                title: Text("Profile"),
              ),
              ListTile(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return SplashScreen();
                  }), (route) {
                    return false;
                  });
                },
                leading: Icon(Icons.logout),
                title: Text("Logout"),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Text(user?.email ?? "".toString()),
          ),
        ],
      ),
    );
  }
}
