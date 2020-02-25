import 'package:flutter/material.dart';

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
  Future<void> signout() async {
    Navigator.pop(context);
    await widget.auth.signOut();
    widget.logoutCallback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            )
          ],
        ),
      ),
      body: Text("home"),
    );
  }
}
