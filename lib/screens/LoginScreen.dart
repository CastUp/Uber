import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber/AllWidget/ProgressDialog.dart';
import 'package:uber/main.dart';
import 'package:uber/screens/Registeration_Screen.dart';
import 'package:uber/screens/mainscreen.dart';

class LoginScreen extends StatefulWidget {

  static const String IDSCREEN ="login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  TextEditingController passwordTextEditingController = TextEditingController() ;
  TextEditingController emailTextEditingController = TextEditingController() ;

  FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(height: 35.0,),
            Image(
              image: AssetImage("images/logo.png"),
              width: 390,
              height: 350,
              alignment: Alignment.center,
            ),
            SizedBox(height: 1.0,),
            Text("Login As a Rider", textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0, fontFamily: "Barnd-Semiblod"),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 1.0,),
                  TextField(
                    controller: emailTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                            fontSize: 14.0
                        ),
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0
                        )
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(height: 1.0,),
                  TextField(
                    controller: passwordTextEditingController,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                            fontSize: 14.0
                        ),
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0
                        )
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(height: 20.0,),
                  TextButton(
                    child: Text("Login",style: TextStyle(color: Colors.black,fontSize: 20,fontFamily: "Barnd-Semiblod"),),
                    onPressed: () async {
                      if(emailTextEditingController.text.isEmpty){
                        print("Email is Empty");
                      }else if(passwordTextEditingController.text.isEmpty){
                        print("Password  is Empty");
                      }else if(passwordTextEditingController.text.length <= 6){
                        print("Please Enter more 6 number");
                      }else{
                        await loginAndauthUser(context);
                      }
                    },
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(2),
                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal:120,vertical: 14)),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ))
                    ),
                  ),
                  SizedBox(height: 15,),
                  Material(
                    elevation: 0,
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      splashColor: Colors.yellow.shade100,
                      child:Container(
                        width: double.infinity,
                        height: 40,
                        alignment: Alignment.center,
                        child: Text("Do not have an Account? Register Here."),
                      ),
                      onTap: ()=> Navigator.of(context).pushReplacementNamed(RegisterationScreen.IDSCREEN),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

   Future<void> loginAndauthUser(BuildContext context) async {


    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_)
        => ProgressDialog(message: "Registering please wait..."),
    );

    UserCredential Uzer = await _auth.signInWithEmailAndPassword(
        email: emailTextEditingController.text.trim().toLowerCase(),
        password: passwordTextEditingController.text.trim()
    ).catchError((err){
      Navigator.pop(context);
      print("Error ${err}");
    });

    if(Uzer != null){
      MyApp.uersRef.child(Uzer.user!.uid).once().then((DataSnapshot snapshot)
      {
        if(snapshot != null){
          Navigator.pushReplacementNamed(context, MainScreen.IDSCREEN);
          print("Welcome back ${snapshot.value["name"].toString().replaceRange(0, 1, snapshot.value["name"].toString().substring(0,1).toUpperCase())}");
        }else{
          _auth.signOut();
          Navigator.pop(context);
          print("Error");
        }
      });
    }else{
      Navigator.pop(context);
    }
  }
}
