import 'package:flutter/material.dart';

class DirectDetails{

  int? distanceValue ;
  int? durationValue ;
  String? distanceText ;
  String? durationText ;
  String? encodedPoints ;

  DirectDetails(
      {this.distanceValue,
      this.durationValue,
      this.distanceText,
      this.durationText,
      this.encodedPoints});
}