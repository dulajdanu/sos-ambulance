import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowAvailable extends StatefulWidget {
  ShowAvailable(this.myLoc);

  final GeoFirePoint myLoc;

  @override
  _ShowAvailableState createState() => _ShowAvailableState();
}

class _ShowAvailableState extends State<ShowAvailable> {
  final fireStoreDb = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  var collectionReference = Firestore.instance.collection('medical');
  static var now = new DateTime.now();
  var dateToday = DateFormat("dd-MM-yyyy").format(now);
  String email, uname;
  Location location = new Location();
  LocationData _locationData;
  String appointmentid = "";
  String ambId = "";
  bool gotResponse = false;

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email');
      uname = prefs.getString('uname');
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.grey.shade800,
        appBar: AppBar(
          title: Text('Available Ambulances'),
        ),
        body: Container(
          child: StreamBuilder(
            stream: geo
                .collection(collectionRef: collectionReference)
                .within(center: widget.myLoc, radius: 10, field: 'position'),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.data.isEmpty) {
                  return Container(
                    child: Center(
                        child: Text(
                      'Sorry no  ambulances were found in your area',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                  );
                } else {
                  print(snapshot.data);

                  // print(ds.data);
                  return Stack(
                    children: <Widget>[
                      ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          print('printing documents');
                          DocumentSnapshot ds = snapshot.data[index];
                          if (ds.data['online'] == false) {
                            return Container();
                          } else {
                            return GestureDetector(
                              onTap: () {
                                print('this ambulance selected');
                                addAppointment(snapshot.data[index].documentID);
                              },
                              child: ListTile(
                                title: Text(snapshot.data[index]['uname']),
                                trailing: Icon(Icons.local_hospital),
                                // subtitle: Text(snapshot.data.),
                              ),
                            );
                          }
                        },
                      ),
                      (appointmentid != "")
                          ? Center(
                              child: Material(
                              borderRadius: BorderRadius.circular(20),
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Waiting for the response",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    StreamBuilder(
                                      stream: fireStoreDb
                                          .collection('medical')
                                          .document(ambId)
                                          .collection('orders')
                                          .document(dateToday)
                                          .collection('appointments')
                                          .document(appointmentid)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.active) {
                                          DocumentSnapshot ds = snapshot.data;
                                          if (ds.data['status'] == 2) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                      "Sorry the ambulance rejected the request"),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20),
                                                    child: FlatButton(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20,
                                                                vertical: 10),
                                                        color: Colors.red,
                                                        onPressed: () {
                                                          Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      ShowAvailable(
                                                                          widget
                                                                              .myLoc)));
                                                        },
                                                        child:
                                                            Text("Try Again")),
                                                  )
                                                ],
                                              ),
                                            );
                                          } else if (ds.data['status'] == 3) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              child: Column(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20),
                                                    child: Text(
                                                        "The ambulance accepted the request and it will arrive soon"),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 20),
                                                    child: FlatButton(
                                                        color: Colors.green,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 10,
                                                                horizontal: 20),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                            "Navigate to home")),
                                                  )
                                                ],
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ))
                          : Container()
                    ],
                  );
                  // return Container(
                  //   child: Text('has data'),
                  // );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }

  addAppointment(String ambulanceId) async {
    _locationData = await location.getLocation();

    await fireStoreDb
        .collection('medical')
        .document(ambulanceId)
        .collection('orders')
        .document(dateToday)
        .setData({}, merge: true);

    await fireStoreDb
        .collection('medical')
        .document(ambulanceId)
        .collection('orders')
        .document(dateToday)
        .collection('appointments')
        .add({
      'email': email,
      'uname': uname,
      'status': 0,
      'time': FieldValue.serverTimestamp(),
      'lat': _locationData.latitude,
      'lon': _locationData.longitude,
    }).then((onValue) {
      print(onValue.documentID + " this is the new doc id of appointment");
      setState(() {
        appointmentid = onValue.documentID;
        ambId = ambulanceId;
      });
      print("new appointment added succesffuly");
    }).catchError((onError) {
      print(onError.toString());
    });
  }
}
