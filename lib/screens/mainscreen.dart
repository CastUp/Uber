import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:provider/provider.dart';
import 'package:uber/AllWidget/Divider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uber/AllWidget/ProgressDialog.dart';
import 'package:uber/Asseistents/AssistantMethod.dart';
import 'package:uber/ConfigMaps.dart';
import 'package:uber/DataHandler/appData.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uber/Models/directDetails.dart';
import 'package:uber/screens/SearchScreen.dart';



class MainScreen extends StatefulWidget {

  static const String IDSCREEN ="main";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin{

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  Completer<GoogleMapController> _controllerGoogleMap =  Completer();
  GoogleMapController? _newGoogleMapController ;
  Position? currentPosition ;
  var geolocator = Geolocator();

  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polyLineSet = {};

  Set<Marker> markers = {};
  Set<Circle> circles = {};



  double searchContainerHeight = 275 ;
  double rideDetailsContainerHeight = 0 ;

  DirectDetails? trapdirectDetails ;

  bool drawerOpen = true ;

  resetApp(BuildContext context){

    setState(() {
      drawerOpen = true ;
      searchContainerHeight = 275 ;
      rideDetailsContainerHeight = 0 ;

      polyLineSet.clear();
      markers.clear();
      circles.clear();
      pLineCoordinates.clear();
    });

    locatePosition(context);
  }

  Future<void> displayRideDetailsContainer(BuildContext context) async{

    await getPlaceDirection(context);

    setState(() {
      searchContainerHeight = 0 ;
      rideDetailsContainerHeight = 275.0 ;
      drawerOpen = false ;
    });
  }

  Future<void> locatePosition(BuildContext context)async{


   Position  position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

   currentPosition = position ;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = new CameraPosition(target: latLngPosition , zoom: 14 ,tilt: 59.440717697143555,bearing: 360);
    _newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await AssistantMethod.searchCoordinateAddress(context ,position: position );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldState,
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*.38 ),
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: ConfigMaps.initialCamera,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              polylines: polyLineSet,
              markers: markers,
              circles: circles,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                _newGoogleMapController = controller ;
                locatePosition(context);
              },
            ),
          ),
          Positioned(
            top: 50,
            left: 22,
            child: InkWell(
              onTap: (){
                drawerOpen ? _scaffoldState.currentState!.openDrawer() : resetApp(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.0),
                  boxShadow: [
                     BoxShadow(
                       color: Colors.black,
                       spreadRadius: .50,
                       blurRadius: 6.0,
                       offset: Offset(0.7,0.7)
                     )
                  ]
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(drawerOpen ? Icons.menu : Icons.close,color: Colors.black,),
                  radius: 20.0,
                ),
              ),
            ),
          ),
          Positioned(
            left: 70,
            top: 55,
            child: Text("GO BUS?," ,style: TextStyle(color: Colors.red.shade600 ,fontSize: 21),),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: Duration(milliseconds: 160),
              child: Container(
                height: searchContainerHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(18) , topRight: Radius.circular(18)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 10.0,
                      spreadRadius: .5,
                      offset: Offset(0.7,0.7)
                    )
                  ]
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24 , vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 6.0,),
                      Text("Hi there," , style: TextStyle(fontSize: 12.0),),
                      Text("Where to?" , style: TextStyle(fontSize: 20.0 , fontFamily: "Barnd-Semiblod"),),
                      SizedBox(height: 20.0,),
                      InkWell(
                        onTap: () async{
                          if(Provider.of<AppData>(context ,listen: false).pickUpLocation!.PlaceName.toString() != null) {
                            var res = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchScreen()));
                            if(res == "obtainDirection"){
                              await displayRideDetailsContainer(context);
                            }
                          }
                        } ,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 6.0,
                                    spreadRadius: .5,
                                    offset: Offset(0.7,0.7)
                                )
                              ]
                          ),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.search , color: Colors.deepPurple,),
                              SizedBox(width: 10,),
                              Text("Search Drop Off")
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.home, color: Colors.green,),
                          SizedBox(width: 12,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Consumer<AppData>(
                                  builder: (_,value, child)
                                  =>Text( value.pickUpLocation == null ? "Add Home" : value.pickUpLocation!.PlaceName.toString()),
                                ),
                                SizedBox(height: 4,),
                                Text("Your living home address" ,
                                     style: TextStyle(color: Colors.grey[500],fontSize: 12.0),)
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10,),
                      DividerWidget(),
                      SizedBox(height: 16,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.work, color: Colors.deepPurple,),
                          SizedBox(width: 12,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Add Work"),
                                SizedBox(height: 4,),
                                Text("Your office home address" ,
                                  style: TextStyle(color: Colors.grey[500],fontSize: 12.0),)
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: Duration(milliseconds: 160),
              child: Container(
                 height: rideDetailsContainerHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0),topRight: Radius.circular(16.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16,
                      spreadRadius: .5,
                      offset: Offset(0.70,0.70)
                    )
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 17.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        color: Colors.white.withOpacity(.6),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: <Widget>[
                              Image.asset("images/taxi.png" ,height: 70,width: 80,),
                              SizedBox(width: 16.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Car",style: TextStyle(fontSize: 18,fontFamily: "Barnd-Semiblod"),),
                                  Text(trapdirectDetails != null ? trapdirectDetails!.distanceText.toString() : "",style: TextStyle(fontSize: 16,color: Colors.red.shade600),),
                                  SizedBox(height: 4,),
                                  Text(trapdirectDetails != null ? "${trapdirectDetails!.durationText}": "",style: TextStyle(fontSize: 18,fontFamily: "Barnd-Semiblod"),),
                                ],
                              ),
                              Expanded(child: Container()),
                              Text(trapdirectDetails != null ? "\$${AssistantMethod.calculatefares(trapdirectDetails!)}": "",style: TextStyle(fontSize: 18,fontFamily: "Barnd-Semiblod"),),

                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20.0,),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: <Widget>[
                             Icon(FontAwesomeIcons.moneyBillWaveAlt, size: 18 , color: Colors.black54,),
                            SizedBox(width: 16.0,),
                            Text("Cash"),
                            SizedBox(width: 16.0,),
                            Icon(Icons.keyboard_arrow_down,size: 16.0,color: Colors.black54,),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.0,),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: ElevatedButton(
                          child: Padding(
                            padding: EdgeInsets.all(17.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Request",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                                Icon(FontAwesomeIcons.taxi,size: 26.0,color: Colors.white,),
                              ],
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                          ),
                          onPressed: (){print("Done");},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width*.65,
        child: Drawer(
          elevation: 2,
          child: ListView(
            children: <Widget>[
              Container(
                height: 165.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  child:Row(
                    children: <Widget>[
                      Image.asset("images/user_icon.png",height: 65,width: 65,),
                      SizedBox(width: 16,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Hazem Ibrahim",style: TextStyle(fontSize: 16,fontFamily: "Barnd-Semiblod"),),
                          SizedBox(height: 6.0,),
                          Text("Visit Profile ")
                        ],
                      ),
                    ],
                  ) ,
                ),
              ),
              SizedBox(height: 12.0,),
              ListTile(
                leading: Icon(Icons.history),
                title: Text("History",style: TextStyle(fontSize: 15),),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Visit profile",style: TextStyle(fontSize: 15),),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("About",style: TextStyle(fontSize: 15),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getPlaceDirection(BuildContext context) async{

    var initialPos = Provider.of<AppData>(context,listen: false).pickUpLocation;
    var finalPos   = Provider.of<AppData>(context,listen: false).DropOffLocation;

    var pickUpLatLng  = LatLng(initialPos!.latitude!, initialPos.longtude!);
    var dropOffLatLng = LatLng(finalPos!.latitude!, finalPos.longtude!);

    showDialog(context: context,
      builder: (context )=> ProgressDialog(message: "please wait..."),
    );

    var details = await AssistantMethod.obtainPlaceDirectionDetails(initialPosition: pickUpLatLng,finalPosition: dropOffLatLng);

    setState(() {
      trapdirectDetails = details ;
    });

    Navigator.pop(context);

    //==============================================================

    PolylinePoints polylinePoints = new PolylinePoints();

    List<PointLatLng> decodedPolyLinePointResult = polylinePoints.decodePolyline(details!.encodedPoints.toString());

    pLineCoordinates.clear();
    if(decodedPolyLinePointResult.isNotEmpty){

      decodedPolyLinePointResult.forEach((PointLatLng pointLatLng ) {

        pLineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));

      });
    }

    polyLineSet.clear();
    setState(() {
      Polyline polyline = Polyline(

          polylineId: PolylineId("polylineID"),
          color: Colors.blue.shade600,
          width: 3,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true,
          points: pLineCoordinates
      );
      polyLineSet.add(polyline);
    });

    LatLngBounds latLngBounds ;

    if(pickUpLatLng.latitude > dropOffLatLng.latitude && pickUpLatLng.longitude > dropOffLatLng.longitude){

      latLngBounds = LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);

    }else if(pickUpLatLng.longitude > dropOffLatLng.longitude){

      latLngBounds = LatLngBounds(southwest: LatLng(pickUpLatLng.latitude,dropOffLatLng.longitude), northeast: LatLng(dropOffLatLng.latitude,pickUpLatLng.longitude));

    }else if(pickUpLatLng.latitude > dropOffLatLng.latitude){

      latLngBounds = LatLngBounds(southwest: LatLng(dropOffLatLng.latitude,pickUpLatLng.longitude), northeast: LatLng(pickUpLatLng.latitude,dropOffLatLng.longitude));

    }else{

      latLngBounds = LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    _newGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70.0));

    //========================================================

    markers.clear();
    Marker pickUpLocationMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: initialPos.PlaceName ,snippet: "My Location"),
      position: pickUpLatLng,
      markerId: MarkerId("pickupID"),
    );

    Marker dropOffLocationMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: finalPos.PlaceName ,snippet: "Drop Off Location"),
      position: dropOffLatLng,
      markerId: MarkerId("dropoffID"),

    );

    setState(() {
      markers.add(pickUpLocationMarker);
      markers.add(dropOffLocationMarker);
    });

    circles.clear();
    Circle pickUpLocCircle = Circle(
      fillColor: Colors.lightBlue.shade50.withOpacity(.4),
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 2,
      strokeColor: Colors.lightBlue.shade200,
      circleId: CircleId("pickupID")
    );

    Circle dropOffLocCircle = Circle(
        fillColor: Colors.red.shade50.withOpacity(.4),
        center: dropOffLatLng,
        radius: 12,
        strokeWidth: 2,
        strokeColor: Colors.red.shade200,
        circleId: CircleId("dropoffID")
    );

    setState(() {
      circles.add(pickUpLocCircle);
      circles.add(dropOffLocCircle);
    });
  }


  @override
  void dispose() {
    _newGoogleMapController!.dispose();
    super.dispose();
  }
}
