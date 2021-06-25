import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber/Asseistents/Request_Assistants.dart';
import 'package:uber/ConfigMaps.dart';
import 'package:uber/DataHandler/appData.dart';
import 'package:uber/Models/Address.dart';
import 'package:uber/Models/directDetails.dart';

class AssistantMethod {


  static Future<String> searchCoordinateAddress(BuildContext context, {Position? position}) async {

    String? pleaseAddress ;
    String? st1 , st2 ,st3 ,st4 ;
    String? ID ;

    String URL = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position!.latitude.toString()},${position.longitude.toString()}&key=${ConfigMaps.mapKey}";

    var response = await RequestAssistants.getRequest(url: URL);

    if (response != "Failed") {
     // pleaseAddress = response["results"][0]["formatted_address"];
      st1 = response["results"][0]["address_components"][1]["long_name"];
      st2 = response["results"][0]["address_components"][2]["long_name"];
      st3 = response["results"][0]["address_components"][0]["long_name"];
      st4 = response["results"][0]["address_components"][3]["long_name"];
      ID  = response["results"][0]["place_id"];

      pleaseAddress = st1! + "," + st2! + "," + st3! + "," + st4! ;

      Provider.of<AppData>(context, listen: false).UpdatePickUpLocationAddress(
          pickUpAddress: new Address(
              Id: ID,
              latitude: position.latitude,
              longtude: position.longitude,
              PlaceName: pleaseAddress,
          ));
    }
    return pleaseAddress!;
  }


  static Future<DirectDetails?> obtainPlaceDirectionDetails({LatLng? initialPosition, LatLng? finalPosition}) async{

    //Example Directions requests // https://developers.google.com/maps/documentation/directions/get-directions
    String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition!.latitude},${initialPosition.longitude}&destination=${finalPosition!.latitude},${finalPosition.longitude}&key=${ConfigMaps.mapKey}";

    var res = await RequestAssistants.getRequest(url: directionUrl);

    if(res == "Failed")
        return null;
    if(res["status"] == "OK"){

      DirectDetails directDetails = new DirectDetails();

      directDetails.encodedPoints = res["routes"][0]["overview_polyline"]["points"];

      directDetails.distanceText  = res["routes"][0]["legs"][0]["distance"]["text"];
      directDetails.distanceValue = res["routes"][0]["legs"][0]["distance"]["value"];

      directDetails.durationText  = res["routes"][0]["legs"][0]["duration"]["text"];
      directDetails.durationValue = res["routes"][0]["legs"][0]["duration"]["value"];

      return directDetails ;
    }
  }


  static int calculatefares(DirectDetails details){

    double timeTraveledfare = (details.durationValue!.toDouble() / 60) *0.20 ;

    double distanceTraveledfare = (details.distanceValue!.toDouble() / 1000) *0.20 ;

    double totalFareAmount = timeTraveledfare + distanceTraveledfare ;

   // double localAmountInegypt = totalFareAmount * 15.60 ;

    return totalFareAmount.truncate();
  }
}
