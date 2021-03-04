import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_society/models/house_model.dart';
import 'package:my_society/screens/house_detail.dart';
import 'package:provider/provider.dart';
import 'package:my_society/providers/house_provider.dart';

import '../main.dart';

class AddHouseDetail extends StatefulWidget {
  final HouseModel houseModel;
  AddHouseDetail([this.houseModel]);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddHouseDetailState();
  }
}

class AddHouseDetailState extends State<AddHouseDetail> {
  static var _houseType = ['કોણ રહે છે ', 'મકાનમાલિક', 'ભાડુઆત', 'ખાલી'];
  var _currentExpenseSelected = '';

  var _formKey = GlobalKey<FormState>();
  final houseNumberController = TextEditingController();
  final ownerNameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  HouseModel houseModel;
  @override
  void initState() {
    // TODO: implement initState
    if (widget.houseModel == null) {
      houseNumberController.text = "";
      ownerNameController.text = "";
      mobileNumberController.text = "";
      new Future.delayed(Duration.zero, () {
        final houseProvider =
            Provider.of<HouseProvider>(context, listen: false);
        houseProvider.loadValues(HouseModel());
      });
    } else {
      //Controller update
      houseNumberController.text = widget.houseModel.houseNumber;
      ownerNameController.text = widget.houseModel.houseOwner;
      //print(ownerNameController.text);
      mobileNumberController.text = widget.houseModel.houseMobile.toString();
      //print(mobileNumberController.text);
      //  _currentExpenseSelected = widget.expenseModel.expenseType;
      //State Update
      final houseProvider = Provider.of<HouseProvider>(context, listen: false);
      houseProvider.loadValues(widget.houseModel);
      new Future.delayed(Duration.zero, () {});
    }
    super.initState();
    _currentExpenseSelected = _houseType[0];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    houseNumberController.dispose();
    ownerNameController.dispose();
    mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final houseProvider = Provider.of<HouseProvider>(context);
    return WillPopScope(
        onWillPop: onBackPressed,
        child: Scaffold(
            appBar: AppBar(
              title: Text('ઘર ઉમેરો'),
            ),
            drawer: DrawerCodeOnly(),
            body: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                  child: ListView(
                    children: <Widget>[
                      //First Element
                      HouseImageAssets(),
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

                            items: _houseType.map((String dropDownStringItem) {
                              return DropdownMenuItem(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem));
                            }).toList(),

                            //style: textStyle,
                            value: //getExpenseAsString(expenseModel.expenseType),
                                _currentExpenseSelected,
                            validator: (value) {
                              if (value == _houseType[0]) {
                                return 'પ્રકાર પસંદ કરો';
                              }
                            },
                            //getPriorityAsString(note.priority),
                            onChanged: (valueSelectedByUser) {
                              setState(
                                () {
                                  debugPrint(
                                      'User selected value $valueSelectedByUser');
                                  _currentExpenseSelected = valueSelectedByUser;
                                  // updateExpenseTypeAsInt(valueSelectedByUser);
                                  houseProvider
                                      .changeHouseType(_currentExpenseSelected);

                                  //updatePriorityAsInt(valueSelectedByUser);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: TextFormField(
                          controller: houseNumberController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.characters,

                          // style: textStyle,
                          onChanged: (value) {
                            // debugPrint('Something Changed in amount text Field');
                            //updateTitle();
                            houseProvider.changeHouseNumber(value);
                          },
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'ઘર નંબર લખો';
                            }
                            // if (value.length > 3) {
                            //   return 'ઘર નંબર ચકાસો';
                            // }
                          },
                          decoration: InputDecoration(
                              labelText: 'ઘર નંબર દા.ત.A1',
                              // labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),

                      //Second element
                      Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: TextFormField(
                          controller: ownerNameController,
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          // style: textStyle,
                          onChanged: (value) {
                            debugPrint('Something Changed in name text Field');
                            //updateTitle();
                            houseProvider.changeHouseOwner(value);
                          },
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'ઘર માલિકનું નામ લખો';
                            }
                          },
                          decoration: InputDecoration(
                              labelText: 'ઘર માલિકનું નામ',
                              // labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
                      //Third element
                      Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          maxLength: 10,

                          controller: mobileNumberController,
                          //style: textStyle,
                          onChanged: (value) {
                            // debugPrint(
                            //   'Something Changed in Description text Field');
                            //updateDescription();
                            houseProvider.changeHouseMobile(value);
                          },
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'મોબાઈલ નંબર લખો';
                            }
                            if (value.length < 10) {
                              return 'મોબાઈલ નંબર ચકાસો';
                            }
                          },
                          decoration: InputDecoration(
                              labelText: 'મોબાઈલ નંબર',
                              // labelStyle: textStyle.,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
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
                                      debugPrint('Save Button Clicked');
                                      setState(() {
                                        if (_formKey.currentState.validate()) {
                                          // _save();
                                          houseProvider.saveHouse();
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      HouseDetail()));
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
                                      Navigator.of(context).pop();
                                      // _delete();
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
}

class HouseImageAssets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('images/home.png');
    Image image = Image(image: assetImage, width: 150.0, height: 150.0);
    return Center(
        child: Container(padding: EdgeInsets.only(bottom: 20.0), child: image));
  }
}
