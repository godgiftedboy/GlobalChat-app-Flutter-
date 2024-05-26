// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/providers/user_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ChatroomScreen extends StatefulWidget {
  String chatroomName;
  String chatroomId;
  ChatroomScreen({
    super.key,
    required this.chatroomName,
    required this.chatroomId,
  });

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  var db = FirebaseFirestore.instance;
  TextEditingController messageText = TextEditingController();
  Future<void> sendMessage() async {
    if (messageText.text.isEmpty) {
      return;
    }
    Map<String, dynamic> message = {
      "text": messageText.text,
      "sender_name": Provider.of<UserProvider>(context, listen: false).userName,
      "chatroom_id": widget.chatroomId,
      "timestamp": FieldValue.serverTimestamp()
    };
    try {
      await db.collection("messages").add(message);
      messageText.text = "";
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatroomName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: db.collection("messages").snapshots(),
                builder: (context, snapshot) {
                  var allMessages = snapshot.data?.docs ?? [];
                  return ListView.builder(
                      itemCount: allMessages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Text(allMessages[index]["text"]);
                      });
                }),
          ),
          Container(
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: messageText,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Write message here"),
                  )),
                  InkWell(
                    onTap: () {
                      sendMessage();
                    },
                    child: Icon(Icons.send),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
