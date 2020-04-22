import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';

class AppointmentPage extends StatefulWidget {
  AppointmentPage({this.docID, this.latLng, this.patientEmail, this.ambEmail});

  final docID;
  final LatLng latLng;
  final String patientEmail;
  final String ambEmail;

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final firestoreDb = Firestore.instance;
  static var now = new DateTime.now();

  var dateToday = DateFormat("dd-MM-yyyy").format(now);

  completeAppointment(String docId) {
    firestoreDb
        .collection('medical')
        .document(widget.ambEmail)
        .collection('orders')
        .document(dateToday)
        .collection('appointments')
        .document(docId)
        .updateData({'status': 1}).then((onValue) {
      print("appointment completed successfully");
    }).catchError((onError) {
      print(onError.toString());
    });

    firestoreDb
        .collection("medical")
        .document(widget.ambEmail)
        .updateData({'visits': FieldValue.increment(1)}).then((onValue) {
      print("visits incremented");
    }).catchError((onError) {
      print(onError.toString());
    });

    firestoreDb
        .collection('medical')
        .document(widget.ambEmail)
        .collection('orders')
        .document(dateToday)
        .updateData({'visits': FieldValue.increment(1)}).then((onValue) {
      print("visits of a date incremented  successfully");
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("new appointment"),
      ),
      body: Center(
        child: StreamBuilder(
          stream: firestoreDb
              .collection('users')
              .document(widget.patientEmail)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              return Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Patient details",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    " Patient e mail",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  Text(widget.patientEmail),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    " Patient username",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  Text(snapshot.data['uname'].toString()),
                  FlatButton(
                      color: Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      onPressed: () {
                        MapsLauncher.launchCoordinates(
                            widget.latLng.latitude, widget.latLng.longitude);
                      },
                      child: Text("get directions")),
                  SizedBox(
                    height: 30,
                  ),
                  FlatButton(
                      color: Colors.redAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      onPressed: () {
                        completeAppointment(widget.docID);
                      },
                      child: Text("Complete"))
                ],
              );
            } else {
              return Center(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Text("Data is loading"),
                      SizedBox(
                        height: 20,
                      ),
                      CircularProgressIndicator()
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
