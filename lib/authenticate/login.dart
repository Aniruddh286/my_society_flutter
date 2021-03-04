import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:marquee/marquee.dart';
import 'package:my_society/main.dart';
import 'dart:io';
import 'package:my_society/screens/expense.dart';
import 'package:my_society/screens/expense_user.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password;
  final auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool loginfail = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      checkInternet();
    });
  }

  Future<bool> onBackPressed() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Do you want to exit?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text("No")),
                FlatButton(
                    // onPressed: () => Navigator.pop(context, true),
                    onPressed: () => exit(0),
                    child: Text("Yes"))
              ],
            ));
  }

  Future checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('સુચના'),
                content: Text('ઈન્ટરનેટ ચાલુ કરો'),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
          // appBar: AppBar(
          //   title: Text('Login'),
          // ),
          body: Container(
        color: new Color(0xFF3FC1C9),
        //color: Colors.teal,
        padding: EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            Container(height: 20.0),
            ExpenseImageAssets(),
            Container(
              height: 20.0,
            ),
            Center(
                child: Text(
              'President Login',
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.cyan[900],
                  fontWeight: FontWeight.bold),
            )),
            Container(
              height: 20.0,
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    filled: true,
                    labelText: 'Email',
                    // labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(5.0),
                    )),
                onChanged: (value) {
                  setState(() {
                    _email = value.trim();
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password',
                    // labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                onChanged: (value) {
                  setState(() {
                    _password = value.trim();
                  });
                },
              ),
            ),
            Container(
              height: 20.0,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 45.0, right: 45.0),
              child: RaisedButton(
                  color: Colors.cyan[900],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: Colors.orange)),
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    ' Log In',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  onPressed: () {
                    //login();

                    auth
                        .signInWithEmailAndPassword(
                            email: _email, password: _password)
                        .then((_) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => DrawerApp()));
                    }).catchError((e) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('સુચના'),
                          content: Text('સાચાં Email Id અને Password દાખલ કરો'),
                        ),
                      );
                    });
                  }),
            ),
            // RaisedButton(
            //   color: Theme.of(context).accentColor,
            //   child: Text('Signup'),
            //   onPressed: () {
            //     // auth
            //     //     .createUserWithEmailAndPassword(
            //     //         email: _email, password: _password)
            //     //     .then((_) {
            //     //   Navigator.of(context).pushReplacement(
            //     //       MaterialPageRoute(builder: (context) => DrawerApp()));
            //     // });
            //   },
            // )
            Container(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 45.0, right: 45.0),
              child: RaisedButton(
                  color: Colors.cyan[900],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: Colors.orange)),
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Society Member',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  onPressed: () {
                    //login();

                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => ExpenseUser()));
                  }),
            ),
            Container(
              height: 20.0,
            ),
            Center(
              child: Column(
                children: [
                  Text(
                    'Developed by ',
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(
                    height: 5.0,
                  ),
                  Text(
                    'Aniruddh Fataniya',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )

            // Container(
            //   padding: EdgeInsets.only(top: 30.0),
            // child:
            // Align(
            //   alignment: Alignment.bottomLeft,
            //   child: Expanded(
            //       child: Container(
            //     alignment: Alignment.bottomCenter,
            //     padding: EdgeInsets.only(top: 50.0, left: 20.0),
            //     height: 100,
            //     //color: Colors.teal,
            //     child: Marquee(
            //       text: '😊 Developed By Aniruddh Fataniya 😊',
            //       blankSpace: 120.0,
            //       startPadding: 1.0,
            //       //pauseAfterRound: Duration(seconds: 1),
            //       //accelerationDuration: Duration(seconds: 1),
            //       decelerationCurve: Curves.easeOut,
            //       style: TextStyle(color: Colors.yellow),
            //     ),
            //   )),
            // )
            // ),
          ],
        ),
      )),
    );
  }

  // Future<void> login() async {
  //   final formState = _formkey.currentState;
  //   if (formState.validate()) {
  //     formState.save();
  //     try {
  //       final User user = (await FirebaseAuth.instance
  //               .signInWithEmailAndPassword(email: _email, password: _password))
  //           .user;
  //       if (!user.uid.isEmpty) {
  //         Navigator.push(
  //             context, MaterialPageRoute(builder: (context) => DrawerApp()));
  //       } else {
  //         setState(() {
  //           loginfail = true; //loginfail is bool
  //         });
  //       }
  //     } catch (e) {
  //       print(e.message);
  //     }
  //   }
  //}
}

class ExpenseImageAssets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('images/logo.png');
    Image image = Image(image: assetImage, width: 150.0, height: 150.0);
    return Center(
        child: Container(padding: EdgeInsets.only(bottom: 20.0), child: image));
  }
}
