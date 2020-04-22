import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactsWidget extends StatefulWidget {
  ContactsWidget({this.email});

  final String email;

  @override
  _ContactsWidgetState createState() => _ContactsWidgetState();
}

class _ContactsWidgetState extends State<ContactsWidget> {
  List<String> contacts = [];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String contactName, contactPhoneNum;
  final contactFormKey = GlobalKey<FormState>();
  bool showFloatingButton = true;

  final fireStoreDb = Firestore.instance;

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('contactsList') != null) {
      print("inside if");
      contacts = prefs.getStringList('contactsList');
    } else {
      print("inside else");
      contacts = [];
      // contacts.add("abc");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  addContact() {
    if (contactFormKey.currentState.validate()) {
      contactFormKey.currentState.save();
      print(contactName);
      print(contactPhoneNum);
      setState(() {
        contacts.add(contactName + "#" + contactPhoneNum);
        Navigator.pop(context);
        showFloatingButton = true;
      });
    } else {
      Navigator.pop(context);
      setState(() {
        showFloatingButton = true;
      });
      var snackbar =
          new SnackBar(content: new Text("Please enter every field"));
      scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(contacts);
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: true,
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("Contacts"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(contacts.isNotEmpty
                  ? "Your contacts"
                  : "You don't have any contacts"),
              (contacts.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: contacts.length,
                          itemBuilder: (BuildContext context, int index) {
                            var value = contacts[index].split('#');
                            return Container(
                              height: 50,
                              color: Colors.amber,
                              child: Center(child: Text(value[0].toString())),
                            );
                          }))
                  : Container())
            ],
          ),
        ),
        floatingActionButton: (showFloatingButton == true)
            ? FloatingActionButton(
                tooltip: "Add a new contact",
                onPressed: () {
                  // Add your onPressed code here!
                  setState(() {
                    showFloatingButton = false;
                  });
                  scaffoldKey.currentState
                      .showBottomSheet((context) => Container(
                            height: 400,
                            color: Colors.lightBlue,
                            child: Form(
                              key: contactFormKey,
                              child: Center(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Add a new contact",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: TextFormField(
                                          // The validator receives the text that the user has entered.
                                          decoration: const InputDecoration(
                                            icon: Icon(Icons.person),
                                            hintText:
                                                'What is the name of your contact?',
                                            labelText: 'Name *',
                                          ),
                                          onSaved: (String value) {
                                            // This optional block of code can be used to run
                                            // code when the user saves the form.
                                            contactName = value.trim();
                                          },
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20, bottom: 30),
                                        child: TextFormField(
                                          // The validator receives the text that the user has entered.
                                          decoration: const InputDecoration(
                                            icon: Icon(Icons.person),
                                            hintText: 'Number of your contact?',
                                            labelText: 'Number *',
                                          ),
                                          onSaved: (String value) {
                                            contactPhoneNum = value.trim();
                                          },
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      FlatButton(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          color: Colors.redAccent,
                                          onPressed: () {
                                            addContact();
                                          },
                                          child: Text("Submit"))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ));
                },
                child: Icon(Icons.add),
                backgroundColor: Colors.green,
              )
            : Container());
  }
}
