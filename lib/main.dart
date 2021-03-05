import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trackchat/chat_screen.dart';
import 'package:trackchat/home-page.dart';
import 'package:trackchat/login_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blue[700],
        accentColor: Colors.cyan[700],
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'home':(context) => Home(),
        'login':(context) => Login(),
        'chat':(context) => Chat(),
      },
    );
  }
}



