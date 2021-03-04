import 'dart:async';
//import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_society/authenticate/login.dart';
import 'package:my_society/main.dart';
import 'package:page_transition/page_transition.dart';

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SplashState();
  }
}

class SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () {
      // Navigator.push(context, _createRoute());
      Navigator.push(context,
          PageTransition(type: PageTransitionType.fade, child: Authenticate()));
    });
  }

  @override
  Widget build(BuildContext context) {
    // Timer(
    //     Duration(seconds: 3),
    //     () => Navigator.push(
    //         context, MaterialPageRoute(builder: (context) => Authenticate())));
    // TODO: implement build
    return Scaffold(
        body: Container(
      color: Colors.cyan[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'images/logo.png',
            height: 160.0,
          ),
          SizedBox(height: 30.0),
          Text(
            'શ્રી હરિ બંગ્લોઝ',
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.orange[300]),
          ),
          SizedBox(height: 30.0),
          //SpinKitRipple(color: Colors.white),
          SpinKitThreeBounce(
            color: Colors.orange,
          )
        ],
      ),
    ));
  }

//   Route _createRoute() {
//     return PageRouteBuilder(
//       pageBuilder: (context, animation, secondaryAnimation) => Authenticate(),
//       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         var begin = Offset(0.0, 1.0);
//         var end = Offset.zero;
//         var curve = Curves.ease;

//         var tween =
//             Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

//         return SlideTransition(
//           position: animation.drive(tween),
//           child: child,
//         );
//       },
//     );
//   }
}
