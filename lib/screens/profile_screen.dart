import 'package:flutter/material.dart';
import 'package:globalchat/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData = {
    // "name": name,
    // "country": country,
    // "email": email,
    // "id": userId.toString(),
  };

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              child: Text(userProvider.userName[0]),
              radius: 50,
            ),
            SizedBox(height: 8),
            Text(
              userProvider.userName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(userProvider.userEmail),
            SizedBox(height: 15),
            ElevatedButton(onPressed: () {}, child: Text("Edit Profile")),
          ],
        ),
      ),
    );
  }
}
