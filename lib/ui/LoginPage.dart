/**
 * Author: Sudip Thapa  
 * profile: https://github.com/sudeepthapa
  */
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:sos/ui/forgetPassword.dart';
import '../authentication.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class LoginSevenPage extends StatefulWidget {
  LoginSevenPage({this.auth, this.loginCallback});

  final Auth auth;
  final VoidCallback loginCallback;
  @override
  _LoginSevenPageState createState() => _LoginSevenPageState();
}

class _LoginSevenPageState extends State<LoginSevenPage> {
  final GlobalKey<FormState> _loginFormKeyValue = GlobalKey<FormState>();
  final GlobalKey<FormState> _singUpFormKeyValue = GlobalKey<FormState>();
  Geoflutterfire geo = Geoflutterfire();
  Location location = new Location();

  String email, passowrd, uname;
  bool _isLoading, pressed, isPatient;
  String _errorMessage;
  bool error = false;
  bool isAmb = false;

  void login() async {
    if (_loginFormKeyValue.currentState.validate()) {
      _loginFormKeyValue.currentState.save();
      // print(email);
      // print(passowrd);
      setState(() {
        _isLoading = true;
        _errorMessage = "";
      });
      try {
        String userId = "";
        print("inside try");
        print(widget.auth);
        userId = await widget.auth.signIn(email, passowrd, isAmb);
        print("after");
        print('Signed in: $userId');
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null) {
          widget.loginCallback();
        }
      } catch (e) {
        // print('Error : $e');
        print(e);
        setState(() {
          _isLoading = false;
          // _errorMessage = e.message;
          _loginFormKeyValue.currentState.reset();
          error = true;
        });
      }
    }
    //  Navigator.pushReplacement(
    //                       context,
    //                       MaterialPageRoute(builder: (context) => Home()),
    //                     );
  }

  signup() async {
    if (_singUpFormKeyValue.currentState.validate()) {
      _singUpFormKeyValue.currentState.save();
      print(uname);
      print(email);
      print(passowrd);
      setState(() {
        _isLoading = true;
        _errorMessage = "";
      });
      try {
        var pos = await location.getLocation();
        GeoFirePoint point =
            geo.point(latitude: pos.latitude, longitude: pos.longitude);
        String userId = "";
        print("inside try");
        print(widget.auth);
        userId = await widget.auth.signUp(email, passowrd, uname, isAmb, point);
        print("after");
        print('Signed in: $userId');
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null) {
          widget.loginCallback();
        }
      } catch (e) {
        // print('Error : $e');
        print(e);
        setState(() {
          _isLoading = false;
          // _errorMessage = e.message;
          _singUpFormKeyValue.currentState.reset();
          error = true;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _errorMessage = "";
    _isLoading = false;
    super.initState();
    pressed = false;
  }

  void resetForm() {
    _loginFormKeyValue.currentState.reset();
    _errorMessage = "";
    error = false;
  }

  @override
  Widget build(BuildContext context) {
    if (pressed == false) {
      return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              _showForm(),
              _showCircularProgress(),
              showError()
            ],
          ));
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            _showForm2(),
            _showCircularProgress(),
            showError()
          ],
        ),
      );
    }
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget showError() {
    if (error) {
      // final snackbar = SnackBar(
      //   content: Text("Username or password is incorrect"),
      // );
      // Scaffold.of(context).showSnackBar(snackbar);
      return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "E mail or Password is Incorrect",
            style: TextStyle(fontSize: 15, color: Colors.red),
          ),
        ),
      );
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showForm() {
    return Form(
      key: _loginFormKeyValue,
      child: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipPath(
                clipper: WaveClipper2(),
                child: Container(
                  child: Column(),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0x22ff3a5a), Color(0x22fe494d)])),
                ),
              ),
              ClipPath(
                clipper: WaveClipper3(),
                child: Container(
                  child: Column(),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0x44ff3a5a), Color(0x44fe494d)])),
                ),
              ),
              ClipPath(
                clipper: WaveClipper1(),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                      ),
                      // Icon(
                      //   Icons.branding_watermark,
                      //   color: Colors.white,
                      //   size: 60,
                      // ),
                      // Image(
                      //   image: AssetImage('assets/images/logo.jpeg'),
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 10),
                        child: Text(
                          "Emergency Ambulance System",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 30),
                        ),
                      ),
                      Center(
                        child: Icon(
                          Icons.local_hospital,
                          size: 90,
                        ),
                      )
                    ],
                  ),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xffff3a5a), Color(0xfffe494d)])),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Email is required";
                  }
                },
                onSaved: (val) => email = val.trim(),
                cursorColor: Colors.deepOrange,
                decoration: InputDecoration(
                    hintText: "Username",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.email,
                        color: Colors.red,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Password cannot be empty";
                  }
                },
                onSaved: (val) => passowrd = val.trim(),
                cursorColor: Colors.deepOrange,
                decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.lock,
                        color: Colors.red,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 20,
              ),
              Checkbox(
                  value: isAmb,
                  onChanged: (bool val) {
                    print(val);
                    setState(() {
                      isAmb = val;
                    });
                  }),
              SizedBox(
                width: 10,
              ),
              Text("Medical Officer")
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Color(0xffff3a5a)),
                child: FlatButton(
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                  onPressed: () {
                    login();
                  },
                ),
              )),
          SizedBox(
            height: 20,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Color(0xffff3a5a)),
                child: FlatButton(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                  onPressed: () {
                    setState(() {
                      pressed = true;
                    });
                  },
                ),
              )),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ForgetPass(Auth())),
              );
            },
            child: Center(
              child: Text(
                "FORGOT PASSWORD ?",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

  Widget _showForm2() {
    return Form(
      key: _singUpFormKeyValue,
      child: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipPath(
                clipper: WaveClipper2(),
                child: Container(
                  child: Column(),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0x22ff3a5a), Color(0x22fe494d)])),
                ),
              ),
              ClipPath(
                clipper: WaveClipper3(),
                child: Container(
                  child: Column(),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0x44ff3a5a), Color(0x44fe494d)])),
                ),
              ),
              ClipPath(
                clipper: WaveClipper1(),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                      ),
                      // Icon(
                      //   Icons.branding_watermark,
                      //   color: Colors.white,
                      //   size: 60,
                      // ),
                      // Image(
                      //   image: AssetImage('assets/images/logo.jpeg'),
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 10),
                        child: Text(
                          "Emergency Ambulance System",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 30),
                        ),
                      ),
                      Center(
                        child: Icon(
                          Icons.local_hospital,
                          size: 90,
                        ),
                      )
                    ],
                  ),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xffff3a5a), Color(0xfffe494d)])),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Username is required";
                  }
                },
                onSaved: (val) => uname = val.trim(),
                cursorColor: Colors.deepOrange,
                decoration: InputDecoration(
                    hintText: "Username",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.email,
                        color: Colors.red,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Email is required";
                  }
                },
                onSaved: (val) => email = val.trim(),
                cursorColor: Colors.deepOrange,
                decoration: InputDecoration(
                    hintText: "E Mail",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.email,
                        color: Colors.red,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Password cannot be empty";
                  }
                },
                onSaved: (val) => passowrd = val.trim(),
                cursorColor: Colors.deepOrange,
                decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.lock,
                        color: Colors.red,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 32),
          //   child: Material(
          //       color: Colors.redAccent,
          //       elevation: 2.0,
          //       borderRadius: BorderRadius.all(Radius.circular(30)),
          //       child: FlatButton(
          //           onPressed: () {
          //             print('get location');
          //           },
          //           child: Text("Get your location"))),
          // ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 20,
              ),
              Checkbox(
                  value: isAmb,
                  onChanged: (bool val) {
                    print(val);
                    setState(() {
                      isAmb = val;
                    });
                  }),
              SizedBox(
                width: 10,
              ),
              Text("Medical Officer")
            ],
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Color(0xffff3a5a)),
                child: FlatButton(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                  onPressed: () {
                    // login();
                    signup();
                  },
                ),
              )),
          SizedBox(
            height: 10,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Color(0xffff3a5a)),
                child: FlatButton(
                  child: Text(
                    "Back To Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                  onPressed: () {
                    setState(() {
                      pressed = false;
                    });
                  },
                ),
              )),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 29 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 60);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 15 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 40);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * .7, size.height - 40);
    var firstControlPoint = Offset(size.width * .25, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 45);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
