import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AmbDashboard extends StatefulWidget {
  AmbDashboard({Key key}) : super(key: key);

  @override
  _AmbDashboardState createState() => _AmbDashboardState();
}

class _AmbDashboardState extends State<AmbDashboard> {
  final TextStyle whiteText = TextStyle(color: Colors.white);
  String email, uname;
  bool isOnline = true;
  String onlineStatus = "Online";
  static var now = new DateTime.now();
  final firestoreDb = Firestore.instance;

  var dateToday = DateFormat("dd-MM-yyyy").format(now);

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
    return _buildBody(context);
  }

  changeOnlineStatus(bool val) async {
    await firestoreDb
        .collection('medical')
        .document(email)
        .updateData({'online': val}).then((onValue) {
      print('online status changed successfully');
    }).catchError((v) {
      print(v.toString());
    });
  }

  cancelAppointment(String docID) {
    print(docID);
    setState(() {
      firestoreDb
          .collection('medical')
          .document(email)
          .collection('orders')
          .document(dateToday)
          .collection('appointments')
          .document(docID)
          .updateData({'status': 2}).then((onValue) {
        print("you cancelled the appointment successfully");
      }).catchError((onError) {
        print(onError.toString());
      });
    });
  }

  acceptAppointment(String docID) {
    print("you have accepted the appointment");
    print(docID);
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              _buildHeader(),
              const SizedBox(height: 50.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 190,
                          color: Colors.blue,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                  child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Status',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white70),
                                  ),
                                  Switch(
                                    value: isOnline,
                                    onChanged: (value) {
                                      setState(() {
                                        isOnline = value;
                                        if (isOnline == false) {
                                          onlineStatus = "Offline";
                                          changeOnlineStatus(false);
                                        } else {
                                          onlineStatus = "Online";
                                          changeOnlineStatus(true);
                                        }
                                      });
                                    },
                                    activeTrackColor: Colors.lightGreenAccent,
                                    activeColor: Colors.green,
                                  ),
                                  Text(onlineStatus,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white70))
                                ],
                              ))
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          height: 120,
                          color: Colors.green,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  "Date",
                                  style: Theme.of(context)
                                      .textTheme
                                      .display1
                                      .copyWith(
                                        color: Colors.white,
                                        fontSize: 24.0,
                                      ),
                                ),
                                trailing: Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  dateToday,
                                  style: whiteText,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  "0 visits today",
                                  style: whiteText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 120,
                          color: Colors.red,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              StreamBuilder(
                                stream: firestoreDb
                                    .collection('medical')
                                    .document(email)
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.active) {
                                    if (snapshot.hasData) {
                                      return ListTile(
                                        title: Text(
                                          snapshot.data['visits'].toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .display1
                                              .copyWith(
                                                color: Colors.white,
                                                fontSize: 24.0,
                                              ),
                                        ),
                                        trailing: Icon(
                                          Icons.check_box,
                                          color: Colors.white,
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  } else {
                                    return ListTile(
                                      title: Text(
                                        "Loading",
                                        style: Theme.of(context)
                                            .textTheme
                                            .display1
                                            .copyWith(
                                              color: Colors.white,
                                              fontSize: 24.0,
                                            ),
                                      ),
                                      trailing: Icon(
                                        Icons.check_box,
                                        color: Colors.white,
                                      ),
                                    );
                                  }
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  'No of visits',
                                  style: whiteText,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          height: 190,
                          color: Colors.yellow,
                          child: StreamBuilder(
                            stream: firestoreDb
                                .collection('medical')
                                .document(email)
                                .collection('orders')
                                .document(dateToday)
                                .collection('appointments')
                                .where('status', isEqualTo: 0)
                                .snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.active) {
                                if (snapshot.data.documents.length != 0) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ListTile(
                                        // title: Text(
                                        //   "0 app",
                                        //   style:
                                        //       Theme.of(context).textTheme.display1.copyWith(
                                        //             fontSize: 24.0,
                                        //             color: Colors.black,
                                        //           ),
                                        // ),
                                        trailing: Icon(
                                          Icons.crop_landscape,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Text(
                                          'You have a appointment now',
                                        ),
                                      )
                                    ],
                                  );
                                } else {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ListTile(
                                        // title: Text(
                                        //   "0 app",
                                        //   style:
                                        //       Theme.of(context).textTheme.display1.copyWith(
                                        //             fontSize: 24.0,
                                        //             color: Colors.black,
                                        //           ),
                                        // ),
                                        trailing: Icon(
                                          Icons.crop_landscape,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Text(
                                          'No appointments now',
                                        ),
                                      )
                                    ],
                                  );
                                }
                              }
                              return Container(
                                child: Text("wait"),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Center(
          child: StreamBuilder(
            stream: firestoreDb
                .collection('medical')
                .document(email)
                .collection('orders')
                .document(dateToday)
                .collection('appointments')
                // .where('status', isEqualTo: 0)
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                print(snapshot.hasData);
                print(snapshot.data.documents);
                if (!snapshot.data.documents.isEmpty) {
                  DocumentSnapshot documentSnapshotOfthePatient;
                  for (DocumentSnapshot doc in snapshot.data.documents) {
                    if (doc['status'] == 0) {
                      documentSnapshotOfthePatient = doc;
                      break;
                    }
                  }
                  if (documentSnapshotOfthePatient != null) {
                    return Container(
                        height: 250,
                        width: 250,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                "A patient needs your help",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(documentSnapshotOfthePatient['email']),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FlatButton(
                                    color: Colors.green,
                                    onPressed: () {
                                      acceptAppointment(
                                          documentSnapshotOfthePatient
                                              .documentID);
                                    },
                                    child: Text("Accept")),
                                SizedBox(
                                  width: 10,
                                ),
                                FlatButton(
                                    color: Colors.redAccent,
                                    onPressed: () {
                                      cancelAppointment(
                                          documentSnapshotOfthePatient
                                              .documentID);
                                    },
                                    child: Text("Cancel"))
                              ],
                            )
                          ],
                        ));
                  } else {
                    return Container();
                  }

                  // print(snapshot.data.documents.first.data);

                } else {
                  return Container();
                }
              } else {
                return Container();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: <Widget>[
        Container(
            height: 100,
            width: 100,
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/amb.jpg'),
            )),
        const SizedBox(width: 20.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                uname.toString(),
                style: whiteText.copyWith(fontSize: 20.0),
              ),
              const SizedBox(height: 20.0),
              Text(
                email.toString(),
                style: TextStyle(color: Colors.grey, fontSize: 16.0),
              ),
            ],
          ),
        )
      ],
    );
  }
}
