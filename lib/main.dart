import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uber/DataHandler/appData.dart';
import 'package:uber/screens/LoginScreen.dart';
import 'package:uber/screens/Registeration_Screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uber/screens/mainscreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> AppData()),
      ],
      builder: (_,child)=> MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  static DatabaseReference uersRef = FirebaseDatabase.instance.reference().child("Users");

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark));

    return MaterialApp(
      title: 'Taxi Rider App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Barnd-Semiblod",
        primarySwatch: Colors.blue,
      ),
      routes: {
        LoginScreen.IDSCREEN: (_) => LoginScreen(),
        RegisterationScreen.IDSCREEN: (_) => RegisterationScreen(),
        MainScreen.IDSCREEN: (_) => MainScreen(),
      },
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)
        => snapshot.connectionState == ConnectionState.active
           ? !snapshot.hasData ? LoginScreen(): MainScreen() : LoginScreen(),
      ),
    );
  }
}
