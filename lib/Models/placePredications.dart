import 'package:flutter/material.dart';

class PlacePredications {

  String? secondary_text;

  String? main_text;

  String? place_id;

  PlacePredications({
    this.secondary_text,
    this.main_text,
    this.place_id,
  });

  PlacePredications.fromJson({Map<String, dynamic>? json}) {

    this.place_id = json!["place_id"];
    this.secondary_text = json["structured_formatting"]["secondary_text"];
    this.main_text= json ["structured_formatting"]["main_text"];
  }
}
