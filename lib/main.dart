import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:om_united/Authentications/Login.dart';
import 'package:om_united/utilis/Firebase_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Model/User.dart';
import 'Pages/HomePage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (!kIsWeb)   {
    FirebaseApi a = FirebaseApi();
    String token = await a.initNotificattions();
    await prefs.setString('token', token);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
  // HttpOverrides.global = MyHttpOverrides();
  runApp(  MyApp( email: prefs.getString("email")!=null?prefs.getString("email")!:"",pass:  prefs.getString("pass")!=null?prefs.getString("pass")!:"", ));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatelessWidget {
  final String email;
  final String pass;
  const MyApp({super.key,required this.email,required this.pass});


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return MaterialApp(
      title: 'OM United',
      debugShowCheckedModeBanner: false,
      home: getHome(email,pass),

    );
  }
}
Widget getHome(email,pass)  {
if(email != "" && pass != ""){
  try {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: email,
        password: pass)
    ;
  } catch (rx) {}
  return HomePage();
}else{
  print("not logged");
  return Login();
}

}


// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }
/*
Platform  Firebase App Id
web       1:612794064156:web:b8c5f97ee7a3c05d7f6ed9
android   1:612794064156:android:273865845a11a8567f6ed9
ios       1:612794064156:ios:7042cfbf5cbd957f7f6ed9*/