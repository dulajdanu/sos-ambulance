import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class ShowAvailable extends StatefulWidget {
  ShowAvailable(this.myLoc);

  final GeoFirePoint myLoc;

  @override
  _ShowAvailableState createState() => _ShowAvailableState();
}

class _ShowAvailableState extends State<ShowAvailable> {
  // final fireStoreDb = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  var collectionReference = Firestore.instance.collection('medical');

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
}
