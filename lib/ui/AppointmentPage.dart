import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget {
  AppointmentPage({this.docID});

  final docID;

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
      body: Text(widget.docID),
    );
  }
}
