import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uber/AllWidget/ProgressDialog.dart';
import 'package:uber/main.dart';
import 'package:uber/screens/LoginScreen.dart';
import 'package:uber/screens/mainscreen.dart';



class RegisterationScreen extends StatelessWidget {

  static const String IDSCREEN ="register";

  FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController nameTextEditingController = TextEditingController() ;
  TextEditingController emailTextEditingController = TextEditingController() ;
  TextEditingController phoneTextEditingController = TextEditingController() ;
  TextEditingController passwordTextEditingController = TextEditingController() ;

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
            Text("Register As a Rider", textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0, fontFamily: "Barnd-Semiblod"),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: nameTextEditingController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: "Name",
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
                  SizedBox(
                    height: 1.0,),
                  TextField(
                    controller: phoneTextEditingController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        labelText: "Phone",
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
                  SizedBox(
                    height: 1.0,),
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
                    child: Text("Create Account",style: TextStyle(color: Colors.black,fontSize: 18,fontFamily: "Barnd-Semiblod"),),
                    onPressed: ()async {

                      if(nameTextEditingController.text.isEmpty){
                        print("Name is Empty");
                      }else if(emailTextEditingController.text.isEmpty){
                          print("Email is Empty");
                      }else if (phoneTextEditingController.text.isEmpty){
                        print("Phone is Empty");
                      }else if(passwordTextEditingController.text.isEmpty){
                        print("Password  is Empty");
                      }else if(passwordTextEditingController.text.length <= 6){
                        print("Please Enter more 6 number");
                      }else{
                        await registerNewUser(context);
                      }
                    },
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all<double>(2),
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal:85,vertical: 14)),
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
                        child: Text(
                            "Already an have an Account? Login Here."),
                      ),
                      onTap: ()=>Navigator.of(context).pushReplacementNamed(LoginScreen.IDSCREEN),
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

  Future<void> registerNewUser(BuildContext context) async{

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_)
      => ProgressDialog(message: "Authentication please wait..."),
    );


    UserCredential Uzer = await _auth.createUserWithEmailAndPassword(
      email: emailTextEditingController.text.toString().trim().toLowerCase() ,
      password:  passwordTextEditingController.text.toString(),
    ).catchError((err){
      Navigator.pop(context);
      print("Error ${err.toString()}");
    });

    if(Uzer.user != null){

      Map<String , String> userDataMap ={
        "name" : nameTextEditingController.text.toString().trim().toLowerCase(),
        "email" : emailTextEditingController.text.toString().trim().toLowerCase(),
        "phone": phoneTextEditingController.text.toString().trim(),
        "password":passwordTextEditingController.text.toString().trim()
      };

      MyApp.uersRef.child(Uzer.user!.uid).set(userDataMap);
      Navigator.pushReplacementNamed(context, MainScreen.IDSCREEN);
      print("Congratulation");

    }else{
      Navigator.pop(context);
      print("User has not been Created");
    }

  }
}


