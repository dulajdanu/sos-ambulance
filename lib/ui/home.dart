import 'package:flutter/material.dart';
import 'package:sos/ui/AmbDashboard.dart';
import 'package:sos/ui/GoogleMapWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('user') == true) {
      setState(() {
        isUser = true;
      });
    } else {
      setState(() {
        isUser = false;
      });
    }
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  Future<void> signout() async {
    Navigator.pop(context);
    await widget.auth.signOut();
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
            DrawerHeader(child: Text("SOS APP")),
            ListTile(
              title: Text("LOGOUT"),
              leading: Icon(Icons.exit_to_app),
              onTap: signout,
            ),
            ListTile(
              title: Text("PROFILE"),
              leading: Icon(Icons.supervised_user_circle),
              onTap: signout,
            )
          ],
        ),
      ),
      body: (isUser == true) ? GoogleMapWidget() : AmbDashboard(),
    );
  }
}
