import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';

class AppointmentPage extends StatefulWidget {
  AppointmentPage({this.docID, this.latLng, this.patientEmail});

  final docID;
  final LatLng latLng;
  final String patientEmail;

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
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Patient details"),
            SizedBox(
              height: 20,
            ),
            Text(" Patient e mail"),
            Text(widget.patientEmail),
            FlatButton(
                onPressed: () {
                  MapsLauncher.launchCoordinates(
                      widget.latLng.latitude, widget.latLng.longitude);
                },
                child: Text("get directions"))
          ],
        ),
      ),
    );
  }
}
