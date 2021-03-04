import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:my_society/models/expense_model.dart';
import 'package:my_society/providers/expense_provider.dart';
import 'package:my_society/providers/house_provider.dart';
import 'package:my_society/screens/add_expense.dart';
import 'package:my_society/screens/add_house_detail.dart';
import 'package:my_society/screens/expense.dart';
import 'package:my_society/screens/expense_user.dart';
//import 'package:my_society/authenticate/register.dart';

import 'package:my_society/screens/house_detail.dart';
import 'package:my_society/screens/house_detail_user.dart';

import 'package:my_society/screens/report.dart';
import 'package:my_society/screens/splash_screen.dart';
import 'package:my_society/services/authentication_service.dart';
import 'package:my_society/services/firestore_service.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'authenticate/login.dart';
//import 'package:my_society/authenticate/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // final firestoreService = FireStoreService();

  // var materialApp = MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(create: (context) => ExpenseProvider()),
  //       StreamProvider(create: (context) => firestoreService.getExpense()),
  //     ],
  //     child: MaterialApp(
  //       title: "Society Management",
  //       debugShowCheckedModeBanner: false,
  //       home: Expense(),
  //       theme: ThemeData(
  //           brightness: Brightness.light,
  //           primaryColor: Colors.indigo[900],
  //           accentColor: Colors.indigoAccent,
  //           primaryColorDark: Colors.indigo[700]),
  //     ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final firestoreService = FireStoreService();
    //final report = ReportState();
    //report.startDate = DateTime.now();
    //report.endDate = DateTime.now();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExpenseProvider()),
        StreamProvider(create: (context) => firestoreService.getExpense()),
        // StreamProvider(
        //     create: (context) => firestoreService.getDateWiseExpense(
        //         report.startDate, report.endDate)),
        ChangeNotifierProvider(create: (context) => HouseProvider()),
        StreamProvider(create: (context) => firestoreService.getHouse()),
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        )
      ],
      child: MaterialApp(
        title: 'My Society',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.teal,
            accentColor: Colors.teal[400],
            primaryColorDark: Colors.teal[900]),
        home: Splash(),
      ),
    );
  }
}

class DrawerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        drawer: DrawerCodeOnly(),
        //appBar: AppBar(title: Text("શ્રી હરિ બંગ્લોઝ")),
        body: Expense(
          expenseModel: ExpenseModel(
              expenseAmount: 0.0,
              //expenseDate: '1/1/2020',
              expenseDescription: '',
              expenseId: '',
              expenseType: ''),
        ));
  }
}

class DrawerCodeOnly extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Container(
              alignment: Alignment.bottomLeft,
              child: Text('શ્રી હરિ બંગ્લોઝ',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold)),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/shreehari_icon.jpg'),
                  fit: BoxFit.fill),
            ),
          ),
          ListTile(
            title: Text(
              'લેણદેણની વિગત',
              style: TextStyle(
                  color: Colors.blue[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0),
            ),
            leading: Icon(Icons.monetization_on_rounded, color: Colors.orange),
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft, child: Expense()));
            },
          ),
          ListTile(
            title: Text('લેણદેણ ઉમેરો',
                style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0)),
            leading: Icon(Icons.add_box_rounded, color: Colors.orange),
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: AddExpense()));
            },
          ),
          ListTile(
            title: Text('ઘરની વિગત',
                style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0)),
            leading: Icon(Icons.people, color: Colors.orange),
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: HouseDetail()));
            },
          ),
          ListTile(
            title: Text('ઘર ઉમેરો',
                style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0)),
            leading: Icon(Icons.add_business_rounded, color: Colors.orange),
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: AddHouseDetail()));
            },
          ),
          ListTile(
            title: Text('રિપોર્ટ',
                style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0)),
            leading: Icon(Icons.menu_book, color: Colors.orange),
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft, child: Report()));
            },
          ),

          Divider(),
          ListTile(
            title: Text('Sign Out',
                style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0)),
            leading: Icon(
              Icons.exit_to_app_rounded,
              color: Colors.orange,
            ),
            onTap: () {
//              auth.signOut();
              context.read<AuthenticationService>().signOut();
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: LoginScreen()));
            },
          ),
          Divider(),
          Container(
            height: 20.0,
          ),
          Center(
            child: Column(
              children: [
                Text(
                  'Developed by ',
                  style: TextStyle(color: Colors.teal),
                ),
                Container(
                  height: 5.0,
                ),
                Text(
                  'Aniruddh Fataniya',
                  style: TextStyle(
                      color: Colors.teal, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
          // Align(
          //   alignment: Alignment.bottomLeft,
          //   child: Expanded(
          //       child: Container(
          //     alignment: Alignment.bottomCenter,
          //     padding: EdgeInsets.only(top: 50.0, left: 20.0),
          //     height: 200,
          //     //color: Colors.teal,
          //     child: Marquee(
          //       text: '😊 Developed By Aniruddh Fataniya 😊',
          //       blankSpace: 120.0,
          //       startPadding: 5.0,
          //       //pauseAfterRound: Duration(seconds: 1),
          //       //accelerationDuration: Duration(seconds: 1),
          //       decelerationCurve: Curves.easeOut,
          //       style: TextStyle(color: Colors.orange),
          //     ),
          //   )),
          // )
        ],
      ),
    );
  }
}

class DrawerCodeOnlyUser extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Container(
              alignment: Alignment.bottomLeft,
              child: Text('શ્રી હરિ બંગ્લોઝ',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold)),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/shreehari_icon.jpg'),
                  fit: BoxFit.fill),
            ),
          ),
          ListTile(
            title: Text('લેણદેણની વિગત',
                style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0)),
            leading: Icon(Icons.monetization_on_rounded, color: Colors.orange),
            onTap: () {
              // Navigator.push(context,
              //     new MaterialPageRoute(builder: (context) => ExpenseUser()));
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: ExpenseUser()));
            },
          ),
          ListTile(
            title: Text('ઘરની વિગત',
                style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0)),
            leading: Icon(Icons.people, color: Colors.orange),
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: HouseDetailUser()));
            },
          ),
          Divider(),
          Container(
            height: 20.0,
          ),
          Center(
            child: Column(
              children: [
                Text(
                  'Developed by ',
                  style: TextStyle(color: Colors.teal),
                ),
                Container(
                  height: 5.0,
                ),
                Text(
                  'Aniruddh Fataniya',
                  style: TextStyle(
                      color: Colors.teal, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return Expense();
    }
    return LoginScreen();
  }
}
