import 'package:flutter/material.dart';
import 'package:globalchat/providers/user_provider.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Map<String, dynamic>? userData = {
    // "name": name,
    // "country": country,
    // "email": email,
    // "id": userId.toString(),
  };

  TextEditingController nameText = TextEditingController();

  var editProfileForm = GlobalKey<FormState>();
  @override
  void initState() {
    nameText.text = Provider.of<UserProvider>(context, listen: false).userName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          InkWell(
            onTap: () {
              if(editProfileForm.currentState!.validate()){
                //updating on the database
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.check),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: editProfileForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: nameText,
                  decoration: InputDecoration(label: Text("Nane")),
                  validator: ,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
