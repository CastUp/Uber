import 'package:flutter/material.dart';
import 'package:uber/Models/Address.dart';

class AppData with ChangeNotifier{

  Address? pickUpLocation , DropOffLocation;

  void UpdatePickUpLocationAddress({Address? pickUpAddress}){

    this.pickUpLocation = pickUpAddress ;
    notifyListeners();
  }

  void UpdateDropOffLocationAddress({Address? dropOffLocationAddress}){

    this.DropOffLocation = dropOffLocationAddress ;
    notifyListeners();
  }

}