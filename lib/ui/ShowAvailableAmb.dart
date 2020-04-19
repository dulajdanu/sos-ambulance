import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:intl/intl.dart';
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
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email');
      uname = prefs.getString('uname');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  return ListView.builder(
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
                            title: Text(snapshot.data[index].documentID),
                            // subtitle: Text(snapshot.data.),
                          ),
                        );
                      }
                    },
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
      'time': FieldValue.serverTimestamp()
    }).then((onValue) {
      print("new appointment added succesffuly");
    }).catchError((onError) {
      print(onError.toString());
    });
  }
}
