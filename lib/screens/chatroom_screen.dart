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
      "sender_id": Provider.of<UserProvider>(context, listen: false).userId,
      "chatroom_id": widget.chatroomId,
      "timestamp": FieldValue.serverTimestamp()
    };
    messageText.text = "";
    try {
      await db.collection("messages").add(message);
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
            //Stream builder reflects the changes from DB in real time
            child: StreamBuilder(
                stream: db
                    .collection("messages")
                    .where("chatroom_id", isEqualTo: widget.chatroomId)
                    .limit(5)
                    .orderBy("timestamp", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text("Some Error has occured");
                  }
                  var allMessages = snapshot.data?.docs ?? [];
                  if (allMessages.length < 1) {
                    return Center(
                      child: Text("No Messages here"),
                    );
                  }
                  return ListView.builder(
                      itemCount: allMessages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: singleChatItem(allMessages, index),
                        );
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

  Column singleChatItem(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> allMessages,
      int index) {
    bool isSender = allMessages[index]["sender_id"] ==
        Provider.of<UserProvider>(context, listen: false).userId;
    return Column(
      crossAxisAlignment:
          isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            allMessages[index]["sender_name"],
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: isSender ? Colors.grey[300] : Colors.blueGrey[900],
              borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              allMessages[index]["text"],
              style: TextStyle(
                color: isSender ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
