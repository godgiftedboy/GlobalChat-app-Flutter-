import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/fcm_services.dart';
import 'package:globalchat/notification_services.dart';
import 'package:globalchat/secrets/firebase_options.dart';
import 'package:globalchat/providers/user_provider.dart';
import 'package:globalchat/screens/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Show local notification
  await NotificationService.initialize();

  //Initilize FireBase Notification

  FcmServices.initializeFirebase();
  FirebaseMessaging.instance
      .getToken()
      .then((value) => {debugPrint("getToken: $value")});
  runApp(ChangeNotifierProvider(
      create: (context) => UserProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        fontFamily: "Poppins",
      ),
      home: SplashScreen(),
    );
  }
}
