import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:uber/AllWidget/Divider.dart';
import 'package:uber/AllWidget/ProgressDialog.dart';
import 'package:uber/Asseistents/Request_Assistants.dart';
import 'package:uber/ConfigMaps.dart';
import 'package:uber/DataHandler/appData.dart';
import 'package:uber/Models/Address.dart';
import 'package:uber/Models/placePredications.dart';

class SearchScreen extends StatefulWidget {

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController pickUptextEditingController  = TextEditingController();
  TextEditingController dropOfftextEditingController = TextEditingController();

  List<PlacePredications> placePredicationslist = [];

  @override
  Widget build(BuildContext context) {

    String placeAddress = Provider.of<AppData>(context).pickUpLocation!.PlaceName.toString() ;
    pickUptextEditingController.text = placeAddress ;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 215,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7,0.7)
                ),
              ]
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 20.0,bottom: 20.0,left: 20.0,right: 25.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10.0,),
                  Stack(
                    children: <Widget>[
                      InkWell(
                        onTap:()=> Navigator.pop(context) ,
                        child: Icon(Icons.arrow_back)
                      ),
                      Center(
                        child: Text("Set Drop Off" , style: TextStyle(fontSize: 18.0 , fontFamily: "Bolt-Regular"),),
                      )
                    ],
                  ),

                  SizedBox(height: 16.0,),
                  Row(
                    children: <Widget>[
                      Image.asset("images/posimarker.png",height: 20.0,width: 20.0,),
                      SizedBox(width: 18,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5.0)
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              controller: pickUptextEditingController,
                              decoration: InputDecoration(
                                hintText: "PickUp location",
                                hintStyle: TextStyle(color: Colors.white),
                                fillColor: Colors.blue,
                                border: InputBorder.none,
                                filled: true,
                                isDense: true,
                                contentPadding: EdgeInsets.only(top: 8 , left: 11 ,bottom: 8)
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.0,),
                  Row(
                    children: <Widget>[
                      Image.asset("images/desticon.png",height: 20.0,width: 20.0,),
                      SizedBox(width: 18,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5.0)
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              controller: dropOfftextEditingController,
                              onChanged: (val)=> findPlace(placeName: val.trim()),
                              decoration: InputDecoration(
                                  hintText: "Where to?",
                                  hintStyle: TextStyle(color: Colors.white),
                                  fillColor: Colors.blue,
                                  border: InputBorder.none,
                                  filled: true,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(top: 8 , left: 11 ,bottom: 8)
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: placePredicationslist.length > 0
                ? Padding(padding: EdgeInsets.symmetric(horizontal: 8.0)
              ,child: ListView.separated(
                itemCount: placePredicationslist.length,
                separatorBuilder: (_,space)=> DividerWidget(),
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                itemBuilder: (_,index)
                => PredictionsTitle(placePredications: placePredicationslist[index]),
              ),
            )
                : Container(),
          ),
        ],
      ),
    );
  }


  Future<void> findPlace({String? placeName}) async{

    if(placeName!.length > 1){

      String autoCompletteUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${placeName}&key=${ConfigMaps.mapKey}&sessiontoken=1234567890";// +"&components=country:EG";

      var res = await RequestAssistants.getRequest(url: autoCompletteUrl);

      if(res == "Failed")
         return;

      if(res["status"] == "OK"){

        List predictions = res["predictions"] as List ;

        var placeList = predictions.map((e) => PlacePredications.fromJson(json: e)).toList();

        setState(()=> placePredicationslist = placeList);

      }

    }

  }
}

class PredictionsTitle extends StatelessWidget {

  final PlacePredications? placePredications ;

  PredictionsTitle({required this.placePredications});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(5),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        splashColor: Colors.blue.shade50,
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Row(
                children: <Widget>[
                  Icon(Icons.add_location),
                  SizedBox(width: 14,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(placePredications!.main_text.toString(),style: TextStyle(fontSize: 18),overflow: TextOverflow.ellipsis,),
                        SizedBox(height: 3.0,),
                        Text(placePredications!.secondary_text.toString(),style: TextStyle(fontSize: 12,color: Colors.grey),overflow: TextOverflow.ellipsis,),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
        onTap: ()=> getPlaceAddressDetails(context,placeId: placePredications!.place_id.toString()),
      )
    );
  }

  Future<void> getPlaceAddressDetails(BuildContext context ,{String? placeId})async{

    showDialog(context: context,
        builder: (context )=> ProgressDialog(message: "Setting Drop Off, please wait..."),
    );

    String placeDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=${placeId}&key=${ConfigMaps.mapKey}";

    var res = await RequestAssistants.getRequest(url: placeDetailsUrl);

    Navigator.pop(context);

    if(res == "Failed")
        return;

    if(res["status"] == "OK"){

      Address address = new Address();

      address.PlaceName = res["result"]["name"];
      address.Id = placeId ;
      address.latitude = res["result"]["geometry"]["location"]["lat"];
      address.longtude = res["result"]["geometry"]["location"]["lng"];

      Provider.of<AppData>(context,listen: false).UpdateDropOffLocationAddress(dropOffLocationAddress: address);

      print("Drop Off Location :: ${address.PlaceName}");

      Navigator.pop(context, "obtainDirection");
    }

  }
}

