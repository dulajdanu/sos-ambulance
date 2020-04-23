import 'package:flutter/material.dart';
import 'package:sos/ui/AmbDashboard.dart';
import 'package:sos/ui/GoogleMapWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos/ui/contacts.dart';
import '../authentication.dart';

class Home extends StatefulWidget {
  Home({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isUser;
  String userMail;

  getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('user') == true) {
      setState(() {
        isUser = true;
        userMail = prefs.getString('email');
      });
    } else {
      setState(() {
        isUser = false;
        userMail = prefs.getString('email');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> signout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Navigator.pop(context);
    await widget.auth.signOut();
    prefs.clear();
    print("shared preferences data cleared");
    widget.logoutCallback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        title: Text("SOS APP"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Icon(
                  Icons.person,
                  size: 80,
                )),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                ListTile(
                  title: Text("PROFILE"),
                  leading: Icon(Icons.supervised_user_circle),
                  // onTap: signout,
                ),
                (isUser == true)
                    ? ListTile(
                        title: Text("CONTACTS"),
                        leading: Icon(Icons.call),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ContactsWidget(
                                        email: userMail,
                                      )));
                        },
                      )
                    : Container(),
                ListTile(
                  title: Text("LOGOUT"),
                  leading: Icon(Icons.exit_to_app),
                  onTap: signout,
                ),
              ],
            ),
          ],
        ),
      ),
      body: (isUser == true) ? GoogleMapWidget() : AmbDashboard(),
    );
  }
}
