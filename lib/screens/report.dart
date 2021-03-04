import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:my_society/main.dart';
import 'package:my_society/models/expense_model.dart';
import 'package:my_society/providers/expense_provider.dart';
import 'package:my_society/services/firestore_service.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pdf/pdf.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
//import 'package:pdf/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:google_fonts/google_fonts.dart';

import 'package:path_provider/path_provider.dart';

class Report extends StatefulWidget {
  final ExpenseModel expenseModel;
  Report({this.expenseModel});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ReportState();
  }
}

class ReportState extends State<Report> {
  //var startDate = FieldValue.serverTimestamp().toString();
  // DateTime sd = DateTime.parse(startDate);
  //Timestamp myTimeStamp = Timestamp.fromDate(startDate);
  //Timestamp sd = DateTime.now().millisecond;
  DateTime startDate;
  DateTime endDate;

  //var font = pw.Font.ttf();
  static const scale = 100.0 / 72.0;
  static const margin = 4.0;
  static const padding = 1.0;
  static const wmargin = (margin + padding) * 2;
  static final controller = ScrollController();
  final firestoreService = FireStoreService();
  final doc = pw.Document();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // new Future.delayed(Duration.zero, () {
    //   final expenseProvider =
    //       Provider.of<ExpenseProvider>(context, listen: false);
    //   expenseProvider.loadValues(widget.expenseModel);
    // });
    startDate = DateTime.now();

    endDate = DateTime.now().add(new Duration(days: 2));
  }

  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<List<ExpenseModel>>(context);
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    // TODO: implement build
    return Scaffold(
      drawer: DrawerCodeOnly(),
      appBar: AppBar(
        title: Text('રિપોર્ટ'),
        //actions: <Widget>[
        //   Padding(
        //       padding: EdgeInsets.only(right: 20.0),
        //       child: GestureDetector(
        //         onTap: () {
        //           print('Touched pdf icon');
        //           // generatepdf();
        //           writeOnPdf();
        //         },
        //         child: Icon(
        //           Icons.picture_as_pdf,
        //           size: 26.0,
        //         ),
        //       )),
        // ]
      ),
      body: WillPopScope(
        onWillPop: onBackPressed,
        child: Column(
          children: <Widget>[
            Container(height: 20.0),
            Center(
              child: MaterialButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                elevation: 10.0,
                onPressed: () async {
                  final List<DateTime> picked =
                      await DateRangePicker.showDatePicker(
                          context: context,
                          initialFirstDate: new DateTime.now(),
                          initialLastDate:
                              (new DateTime.now()).add(new Duration(days: 2)),
                          firstDate: new DateTime(2015),
                          lastDate: new DateTime(2030));
                  if (picked != null && picked.length == 2) {
                    setState(() {
                      print(picked[0]);
                      print(picked[1]);
                      startDate = picked[0];
                      endDate = picked[1];
                    });
                  }
                },
                child: Container(
                  width: 200.0,
                  child: Center(
                    child: Row(children: <Widget>[
                      Icon(Icons.calendar_today),
                      Container(
                        width: 10.0,
                      ),
                      Text(
                        'Select Date Range',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ]),
                  ),
                ),

                // child: new Text(
                //   "Select Date Range",
                //   style: TextStyle(fontSize: 18.0),
                // )
              ),
            ),
            Container(
              height: 10.0,
            ),
            Text(
              'શરૂઆતની તારીખ: ${startDateConverted().toString()}',
              style: TextStyle(fontSize: 18.0),
            ),
            Container(
              height: 10.0,
            ),
            Text(
              'અંતની તારીખ: ${endDateConverted().toString()}',
              style: TextStyle(fontSize: 18.0),
            ),
            Container(
              height: 10.0,
            ),
            RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                elevation: 10.0,
                child: Container(
                  width: 200.0,
                  child: Center(
                    child: Row(children: <Widget>[
                      Icon(Icons.picture_as_pdf_rounded),
                      Container(
                        width: 10.0,
                      ),
                      Text(
                        'Generate Report',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ]),
                  ),
                ),
                onPressed: () async {
                  await writeOnPdf();
                  // Navigator.pop(context);
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: Report()));
                  print('After fuction call:$startDate and $endDate ');
                  setState(() {
                    // print('Before fuction call:$startDate and $endDate ');
                  });
                }),
          ],
        ),
      ),
    );
  }

  // Future getDatewiseTotalExpense() async {
  //   Timestamp sd = Timestamp.fromDate(startDate);
  //   Timestamp ed = Timestamp.fromDate(endDate);
  //   FirebaseFirestore _db = FirebaseFirestore.instance;
  //   double totalExpense = 0.0;
  //   var totalExpense1 = await _db
  //       .collection('expense')
  //       .orderBy('expenseDate', descending: true)
  //       .where('expenseType', isEqualTo: 'જાવક')
  //       .where('expenseDate', isGreaterThanOrEqualTo: sd)
  //       .where('expenseDate', isLessThanOrEqualTo: ed)
  //       .get();

  //   totalExpense1.docs
  //       .forEach((doc) => totalExpense += doc.data()['expenseAmount']);
  //   print('Total Expense: $totalExpense');
  //   return totalExpense;
  // }

  Future<void> writeOnPdf() async {
    Timestamp sd = Timestamp.fromDate(startDate);
    Timestamp ed = Timestamp.fromDate(endDate);
    print('$startDate');
    print('$endDate');
    double totalExpense = 0.0;
    double totalIncome = 0.0;
    double balance = 0.0;
    double totalExpenseall = 0.0;
    double totalIncomeall = 0.0;
    double balanceall = 0.0;
    var gujaratiFont =
        pw.Font.ttf(await rootBundle.load("fonts/Rasa-Regular.ttf"));

    print("hi..........................");
    FirebaseFirestore _db = FirebaseFirestore.instance;

    var filteredData = await _db
        .collection('expense')
        .orderBy('expenseDate', descending: true)
        .where('expenseDate', isGreaterThanOrEqualTo: sd)
        .where('expenseDate', isLessThanOrEqualTo: ed)
        .get();
    List list = List();

    filteredData.docs.forEach((element) {
      print(element.data());
      list.add([
        // element.data()['expenseType'],
        DateFormat('dd-MM-yyyy')
            .format((element.data()['expenseDate'] as Timestamp).toDate()),
        element.data()['expenseType'],
        element.data()['expenseDescription'],
        element.data()['expenseAmount'].toString(),
      ]);
    });
    print(filteredData.docs.length);

    var totalExpense1 = await _db
        .collection('expense')
        .orderBy('expenseDate', descending: true)
        .where('expenseType', isEqualTo: 'જાવક')
        .where('expenseDate', isGreaterThanOrEqualTo: sd)
        .where('expenseDate', isLessThanOrEqualTo: ed)
        .get();

    totalExpense1.docs
        .forEach((doc) => totalExpense += doc.data()['expenseAmount']);

    var totalIncome1 = await _db
        .collection('expense')
        .orderBy('expenseDate', descending: true)
        .where('expenseType', isEqualTo: 'આવક')
        .where('expenseDate', isGreaterThanOrEqualTo: sd)
        .where('expenseDate', isLessThanOrEqualTo: ed)
        .get();

    totalIncome1.docs
        .forEach((doc) => totalIncome += doc.data()['expenseAmount']);

    balance = totalIncome - totalExpense;
    var totalExpenseallOver = await _db
        .collection('expense')
        .orderBy('expenseDate', descending: true)
        .where('expenseType', isEqualTo: 'જાવક')
        // .where('expenseDate', isGreaterThanOrEqualTo: sd)
        // .where('expenseDate', isLessThanOrEqualTo: ed)
        .get();

    totalExpenseallOver.docs
        .forEach((doc) => totalExpenseall += doc.data()['expenseAmount']);

    var totalIncomeallOver = await _db
        .collection('expense')
        .orderBy('expenseDate', descending: true)
        .where('expenseType', isEqualTo: 'આવક')
        // .where('expenseDate', isGreaterThanOrEqualTo: sd)
        // .where('expenseDate', isLessThanOrEqualTo: ed)
        .get();

    totalIncomeallOver.docs
        .forEach((doc) => totalIncomeall += doc.data()['expenseAmount']);

    balanceall = totalIncomeall - totalExpenseall;
    doc.addPage(pw.MultiPage(
      theme: pw.ThemeData.withFont(base: gujaratiFont),
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Header(
              level: 0,
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: <pw.Widget>[
                    pw.Center(
                        child: pw.Text('Shree Hari Bungalows',
                            textScaleFactor: 2,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  ])),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: <pw.Widget>[
                pw.Header(level: 1, text: 'Periodic Income-Expense Detail')
              ]),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                  'સમયગાળો: ${startDateConverted()} થી ${endDateConverted()} ',
                  style: pw.TextStyle(fontSize: 15.0)),
              // pw.Text(startDateConverted(),
              //     style: pw.TextStyle(fontSize: 15.0)),
            ],
          ),
          // pw.Row(
          //   children: [
          //     pw.Text('To: ', style: pw.TextStyle(fontSize: 15.0)),
          //     pw.Text(endDateConverted(), style: pw.TextStyle(fontSize: 15.0)),
          //   ],
          // ),
          pw.Container(height: 10.0),
          pw.Text('દર્શાવેલ સમયની આવક: $totalIncome',
              style: pw.TextStyle(fontSize: 15.0)),
          pw.Container(height: 10.0),
          pw.Text('દર્શાવેલ સમયની જાવક: $totalExpense',
              style: pw.TextStyle(fontSize: 15.0)),
          pw.Container(height: 10.0),
          pw.Text('દર્શાવેલ સમયની જમા રકમ: $balance',
              style: pw.TextStyle(fontSize: 15.0)),
          pw.Container(height: 10.0),
          pw.Text('કુલ જમા રકમ: $balanceall',
              style: pw.TextStyle(fontSize: 15.0)),
          pw.Container(height: 10.0),
          pw.Table.fromTextArray(
              context: context,
              cellStyle: pw.TextStyle(fontSize: 14.0),
              // cellStyle: GoogleFonts.rasa({color: Colors.black}),
              data: [
                <String>['Date', 'Expense Type', 'Description', 'Amount'],
                ...list
              ]),
        ];
      },
    ));
    final output = await getExternalStorageDirectory();
    String pathToWrite = output.path +
        '/statement_${startDateConverted()}_to_${endDateConverted()}.pdf';
    File outputFile = File(pathToWrite);
    if (File(pathToWrite).existsSync()) {
      File(pathToWrite).deleteSync();
    }
    outputFile.writeAsBytesSync(await doc.save());
    print(output.path);
    await _showAlertDialog(
        'Success', 'રિપોર્ટ ${output.path} ફોલ્ડ૨ માં સેવ થઇ ગયો છે');
  }

  // void generatepdf() async {
  //   doc.addPage(
  //       // pw.MultiPage(build(context)=><Widget>[

  //       // ]),
  //      pw.Table.fromTextArray(context: context, data: const <List<String>>[
  //           <String>['Year', 'Sample'],
  //           <String>['SN0', 'GFG1'],
  //           <String>['SN1', 'GFG2'],
  //           <String>['SN2', 'GFG3'],
  //           <String>['SN3', 'GFG4'],
  //         ]),
  //       pw.Page(
  //           pageFormat: PdfPageFormat.a4,
  //           build: (pw.Context context) {
  //             return pw.Container(
  //                 height: 50.0,
  //                 child: pw.Column(children: [
  //                   // pw.Center(
  //                   //     child: pw.Text('શ્રી હરિ બંગ્લોઝ',
  //                   //         style: pw.TextStyle(
  //                   //           fontSize: 30.0,
  //                   //         ))),
  //                   // pw.Center(
  //                   //     child: pw.Text('આવક-જાવકની વિગત',
  //                   //         style: pw.TextStyle(fontSize: 20.0))),
  //                   pw.Row(
  //                     children: [
  //                       pw.Text('From: ', style: pw.TextStyle(fontSize: 15.0)),
  //                       pw.Text(startDateConverted(),
  //                           style: pw.TextStyle(fontSize: 15.0)),
  //                     ],
  //                   ),
  //                   pw.Row(
  //                     children: [
  //                       pw.Text('To: ', style: pw.TextStyle(fontSize: 15.0)),
  //                       pw.Text(endDateConverted(),
  //                           style: pw.TextStyle(fontSize: 15.0)),
  //                     ],
  //                   ),
  //                 ]));
  //           }));

  //   final output = await getExternalStorageDirectory();
  //   String pathToWrite = output.path + '/statement.pdf';
  //   File outputFile = File(pathToWrite);
  //   outputFile.writeAsBytesSync(await doc.save());
  //   print(output.path);
  //   print(startDateConverted());
  //   print(endDateConverted());
  // }

  _date(i) {
    final expenses = Provider.of<List<ExpenseModel>>(context);
    //DateTime date = DateTime.parse(expenses[i].expenseDate.toDate().toString());
    // var date = new DateTime.fromMicrosecondsSinceEpoch(expenses[i].expenseDate);
    //print('Date:${expenses[i].expenseDate.toDate()}');
    //return date.toString();
    Timestamp timestamp = expenses[i].expenseDate;
    String convertedDate =
        new DateFormat("dd-MM-yyyy").format(timestamp.toDate());
    //print(timestamp.toDate().toString());
    return convertedDate;
  }

  startDateConverted() {
    String sd = new DateFormat("dd-MM-yyyy").format(startDate);
    return sd;
  }

  endDateConverted() {
    String sd = new DateFormat("dd-MM-yyyy").format(endDate);
    return sd;
  }

  //Reurns Priority Color
  Color getExpenseTypeColor(String expenseType) {
    switch (expenseType) {
      case 'આવક':
        return Colors.teal;
        break;
      case 'જાવક':
        return Colors.red[400];
        break;
      default:
        return Colors.teal;
    }
  }

  Icon getExpenseTypeIcon(String expenseType) {
    switch (expenseType) {
      case 'આવક':
        return Icon(Icons.add);
        break;
      case 'જાવક':
        return Icon(Icons.remove);
        break;
      default:
        return Icon(Icons.add);
    }
  }

  Future<void> _showAlertDialog(String title, String message) async {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    await showDialog(context: context, builder: (_) => alertDialog);
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
}
