import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/providers/user_provider.dart';
import 'package:globalchat/screens/chatroom_screen.dart';
import 'package:globalchat/screens/profile_screen.dart';
import 'package:globalchat/screens/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var user = FirebaseAuth.instance.currentUser;

  var db = FirebaseFirestore.instance;
  var authUser = FirebaseAuth.instance.currentUser;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> chatroomList = [];
  List<String> chatroomIds = [];

  void getChatrooms() {
    db.collection("chatroom").get().then((value) {
      for (var singleChatroomData in value.docs) {
        chatroomList.add(singleChatroomData.data());
        chatroomIds.add(singleChatroomData.id.toString());
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    getChatrooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
            title: Text("GlobalChat"),
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  scaffoldKey.currentState!.openDrawer();
                },
                child: CircleAvatar(
                  child: Text(userProvider.userName[0]),
                ),
              ),
            )),
        drawer: Drawer(
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 30),
                ListTile(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ProfileScreen();
                      }),
                    );
                  },
                  leading: CircleAvatar(child: Text(userProvider.userName[0])),
                  title: Text(
                    userProvider.userName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(userProvider.userEmail),
                ),
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
        body: ListView.builder(
            itemCount: chatroomList.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return ChatroomScreen(
                        chatroomName:
                            chatroomList[index]['chatroom_name'] ?? '',
                        chatroomId: chatroomIds[index],
                      );
                    }),
                  );
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.blueGrey[900],
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(chatroomList[index]['chatroom_name'] ?? ''),
                subtitle: Text(chatroomList[index]['desc'] ?? ''),
              );
            }));
  }
}
