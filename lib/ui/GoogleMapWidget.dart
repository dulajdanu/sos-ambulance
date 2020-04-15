import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sos/ui/ShowAvailableAmb.dart';

class GoogleMapWidget extends StatefulWidget {
  GoogleMapWidget({Key key}) : super(key: key);

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  Location location = new Location();
  LocationData _locationData;
  LatLng myLocation;
  int seedVal = 100;

  Geoflutterfire geo = Geoflutterfire(); //
  Location locationMy =
      new Location(); // created to pass to the load ambulance function

  BehaviorSubject<double> radius = BehaviorSubject<double>.seeded(100);
  Stream<dynamic> query;
  StreamSubscription subscription;

  GoogleMapController mapController;

  final LatLng _center = const LatLng(7.8731, 80.7718);

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  // }

  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("printing location data");
    print(_locationData);
    return Stack(
      children: <Widget>[
        GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          myLocationEnabled: true,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: GestureDetector(
              onTap: () {
                loadAvailableAmbulances();
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(40)),
                child: Text("Pick your location"),
              ),
            ),
          ),
        ),
        // Align(
        //     alignment: Alignment.bottomRight,
        //     child: Slider(
        //       min: 100.0,
        //       max: 500.0,
        //       divisions: 4,
        //       value: radius.value,
        //       label: 'Radius ${radius.value}km',
        //       activeColor: Colors.green,
        //       inactiveColor: Colors.green.withOpacity(0.2),
        //       onChanged: _updateQuery,
        //     ))
      ],
    );
  }

  // void _updateMarkers(List<DocumentSnapshot> documentList) {
  //   print(documentList);
  //   // mapController;
  //   _controller.future.documentList.forEach((DocumentSnapshot document) {
  //     GeoPoint pos = document.data['position']['geopoint'];
  //     double distance = document.data['distance'];
  //     var marker = Marker(
  //       markerId: MarkerId(document.documentID),
  //       position: LatLng(pos.latitude, pos.longitude),
  //       icon: BitmapDescriptor.defaultMarker,
  //     );

  //     mapController.addMarker(marker);
  //   });
  // }

  loadAvailableAmbulances() async {
    var pos = await locationMy.getLocation();
    GeoFirePoint myloc =
        geo.point(latitude: pos.latitude, longitude: pos.longitude);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ShowAvailable(myloc)));
  }
}
