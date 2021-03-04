import 'dart:io';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:my_society/main.dart';
import 'package:my_society/models/expense_model.dart';
import 'package:my_society/providers/expense_provider.dart';
import 'package:my_society/screens/expense.dart';

import '../providers/expense_provider.dart';
import 'package:provider/provider.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddExpense extends StatefulWidget {
  final ExpenseModel expenseModel;
  AddExpense([this.expenseModel]);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddExpenseState();
  }
}

class AddExpenseState extends State<AddExpense> {
  static var _expenseType = [
    'પ્રકાર',
    'આવક',
    'જાવક',
  ];
  var _currentExpenseSelected = '';
  var _formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  ExpenseModel expenseModel;

  Future<void> _selectDate(BuildContext context) async {
    final expenseProvider =
        Provider.of<ExpenseProvider>(context, listen: false);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        //  expenseProvider.changeExpenseDate(selectedDate);

        // String convertedDate = new DateFormat("dd-MM-yyyy").format(picked);
        //dateController.value = TextEditingValue(text: picked.toString());
        //dateController.value = TextEditingValue(text: convertedDate);
        //expenseProvider.changeExpenseDate(convertedDate);
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.expenseModel == null) {
      dateController.text = "";
      amountController.text = "";
      descriptionController.text = "";
      new Future.delayed(Duration.zero, () {
        final expenseProvider =
            Provider.of<ExpenseProvider>(context, listen: false);
        expenseProvider.loadValues(ExpenseModel());
      });
    } else {
      //Controller update
      //dateController.text = widget.expenseModel.expenseDate;
      amountController.text = widget.expenseModel.expenseAmount.toString();
      print(amountController.text);
      descriptionController.text = widget.expenseModel.expenseDescription;
      print(descriptionController.text);
      //  _currentExpenseSelected = widget.expenseModel.expenseType;
      //State Update
      final expenseProvider =
          Provider.of<ExpenseProvider>(context, listen: false);
      expenseProvider.loadValues(widget.expenseModel);
      new Future.delayed(Duration.zero, () {});
    }
    super.initState();
    _currentExpenseSelected = _expenseType[0];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    amountController.dispose();
    dateController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    return WillPopScope(
        onWillPop: onBackPressed,
        child: Scaffold(
            appBar: AppBar(title: Text('લેણદેણ ઉમેરો')),
            drawer: DrawerCodeOnly(),
            body: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                  child: ListView(
                    children: <Widget>[
                      ExpenseImageAssets(),
                      //First Element

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(6.0),
                        //   border:
                        //   Border.all(
                        //       color: Colors.grey,
                        //       style: BorderStyle.solid,
                        //       width: 0.80),

                        // ),

                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: DropdownButtonFormField(
                            // underline: Text(''),
                            isExpanded: true,

                            items:
                                _expenseType.map((String dropDownStringItem) {
                              return DropdownMenuItem(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem));
                            }).toList(),

                            //style: textStyle,
                            value: //getExpenseAsString(expenseModel.expenseType),
                                _currentExpenseSelected,
                            validator: (value) {
                              if (value == _expenseType[0]) {
                                return 'પ્રકાર પસંદ કરો';
                              }
                            },

                            onChanged: (valueSelectedByUser) {
                              setState(
                                () {
                                  debugPrint(
                                      'User selected value $valueSelectedByUser');
                                  _currentExpenseSelected = valueSelectedByUser;

                                  expenseProvider.changeExpenseType(
                                      _currentExpenseSelected);
                                },
                              );
                            },
                          ),
                        ),
                      ),

                      //Second element
                      Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: TextFormField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.sentences,
                          // style: textStyle,
                          onChanged: (value) {
                            debugPrint(
                                'Something Changed in amount text Field');
                            expenseProvider.changeExpenseAmount(value);
                            //updateTitle();
                          },
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'કોઈ રકમ લખો';
                            }
                          },
                          decoration: InputDecoration(
                              labelText: 'રકમ',
                              // labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
                      //Third element
                      Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: TextFormField(
                          controller: descriptionController,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (value) {
                            debugPrint(
                                'Something Changed in Description text Field');
                            expenseProvider.changeExpenseDescription(value);
                            //updateDescription();
                          },
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'વિગત લખો';
                            }
                          },
                          decoration: InputDecoration(
                              labelText: 'વિગત',
                              // labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
                      // Padding(
                      //     padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      //     child: GestureDetector(
                      //         onTap: () => _selectDate(context),
                      //         child: AbsorbPointer(
                      //           child: TextFormField(
                      //             autofocus: true,
                      //             controller: dateController,
                      //             keyboardType: TextInputType.text,

                      //             //style: textStyle,
                      //             onChanged: (value) {
                      //               debugPrint('Date:$value');
                      //               expenseProvider.changeExpenseDate(value);
                      //               //updateDescription();
                      //             },
                      //             validator: (String value) {
                      //               if (value.isEmpty) {
                      //                 return 'તારીખ પસંદ કરો';
                      //               }
                      //             },
                      //             decoration: InputDecoration(
                      //                 hintText: 'તારીખ',
                      //                 prefixIcon: Icon(
                      //                   Icons.dialpad,
                      //                   color: Colors.indigo,
                      //                 ),

                      //                 // labelStyle: textStyle,
                      //                 border: OutlineInputBorder(
                      //                     borderRadius:
                      //                         BorderRadius.circular(5.0))),
                      //           ),
                      //         ))),
                      // Padding(
                      //     padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      //     child: DateTimeFormField(
                      //       decoration: const InputDecoration(
                      //           hintStyle: TextStyle(color: Colors.grey),
                      //           //errorStyle: TextStyle(color: Colors.redAccent),
                      //           border: OutlineInputBorder(),
                      //           suffixIcon: Icon(Icons.event_note),
                      //           labelText: 'તારીખ',
                      //           focusColor: Colors.teal),

                      //       mode: DateTimeFieldPickerMode.date,
                      //       //initialValue: selectedDate,
                      //       autovalidateMode: AutovalidateMode.always,

                      //       onDateSelected: (DateTime value) {
                      //         //String convertedDate = new DateFormat("dd-MM-yyyy").format(value);
                      //         //print(value);
                      //         //print(new DateFormat.yMMMd().format(value));
                      //         // value = selectedDate;

                      //         String convertedDate =
                      //             new DateFormat("dd-MM-yyyy").format(value);
                      //         expenseProvider.changeExpenseDate(convertedDate);
                      //       },

                      //       validator: (value) {
                      //         // DateTime todayDate = DateTime.now();
                      //         // bool after = value.isAfter(todayDate);
                      //         // if (value.isAfter(todayDate)) {
                      //         //   return '$todayDate અથવા પહેલાંની તારીખ પસંદ કરો';
                      //         // } else if (after == null) {
                      //         //   return 'તારીખ પસંદ કરો';
                      //         // }
                      //         // if (value == null) {
                      //         //   return 'તારીખ પસંદ કરો';
                      //         // }
                      //       },
                      //     )),
                      // Padding(
                      //     padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      //     child: Row(children: <Widget>[
                      //       Text(
                      //         selectedDate.toString(),
                      //       ),
                      //       Container(
                      //         width: 15.0,
                      //       ),
                      // InkWell(
                      //   onTap: () {
                      //     _selectDate(context);
                      //   },
                      // )
                      //   Expanded(
                      //       child: RaisedButton(
                      //           child: Text('Select Date'),
                      //           onPressed: () {
                      //             _selectDate(context);
                      //           }))
                      // ])),

                      Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: RaisedButton(
                                    color: Theme.of(context).primaryColor,
                                    textColor: Colors.white,
                                    elevation: 10.0,
                                    child: Text(
                                      'SAVE',
                                      textScaleFactor: 1.2,
                                    ),
                                    onPressed: () {
                                      //debugPrint('Save Button Clicked');
                                      setState(() {
                                        if (_formKey.currentState.validate()) {
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      Expense()));
                                          expenseProvider.saveExpense();
                                          _showAlertDialog(
                                              'Status', 'વિગત ઉમેરાઈ ગઈ');
                                        }
                                      });
                                    })),
                            Container(
                              width: 15.0,
                            ),
                            Expanded(
                                child: RaisedButton(
                                    color: Colors.red[400],
                                    textColor: Colors.white,
                                    elevation: 10.0,
                                    child: Text(
                                      'CANCEL',
                                      textScaleFactor: 1.2,
                                    ),
                                    onPressed: () {
                                      debugPrint('Delete Button Clicked');
                                      Navigator.pop(context);
                                      // expenseProvider.removeExpense(
                                      //     widget.expenseModel.expenseId);
                                      // moveToLastScreen();
                                    }))
                          ],
                        ),
                      )
                    ],
                  ),
                ))));
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
  //Convert the String priority in the form of integer before saving it to Database
  // int updateExpenseTypeAsInt(String value) {
  //   int exp;
  //   switch (value) {
  //     case 'આવક':
  //       expenseModel.expenseType = 1;
  //       exp = expenseModel.expenseType;
  //       break;
  //     case '':
  //       expenseModel.expenseType = 2;
  //       exp = expenseModel.expenseType;
  //       break;
  //   }
  //   return exp;
  // }

  // //Convert the int priority to String priority and display it to use in DropDown
  // String getExpenseAsString(int value) {
  //   String expenseTypeS;
  //   switch (value) {
  //     case 1:
  //       expenseTypeS = _expenseType[0];
  //       break;
  //     case 2:
  //       expenseTypeS = _expenseType[1];
  //       break;
  //   }
  //   return expenseTypeS;
  // }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}

class ExpenseImageAssets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('images/money.png');
    Image image = Image(image: assetImage, width: 150.0, height: 150.0);
    return Center(
        child: Container(padding: EdgeInsets.only(bottom: 20.0), child: image));
  }
}
