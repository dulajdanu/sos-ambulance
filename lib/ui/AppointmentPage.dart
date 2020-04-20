import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';

class AppointmentPage extends StatefulWidget {
  AppointmentPage({this.docID, this.latLng});

  final docID;
  final LatLng latLng;

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("new appointment"),
      ),
      body: Column(
        children: <Widget>[
          FlatButton(
              onPressed: () {
                MapsLauncher.launchCoordinates(
                    widget.latLng.latitude, widget.latLng.longitude);
              },
              child: Text("get directions"))
        ],
      ),
    );
  }
}
