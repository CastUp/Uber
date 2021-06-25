import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {

  final String? message ;

  ProgressDialog({this.message});


  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.yellow,
      child: Container(
        margin: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              SizedBox(width: 6.0,),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),
              SizedBox(width: 26,),
              Expanded(
                  child: Text(message! ,style: TextStyle(color: Colors.black),textAlign: TextAlign.center,)),
            ],
          ),
        ),
      ),
    );
  }
}
