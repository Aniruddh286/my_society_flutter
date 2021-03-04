import 'dart:io';

import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:my_society/models/house_model.dart';
import 'package:my_society/providers/house_provider.dart';
import 'package:my_society/screens/add_house_detail.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
//import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class HouseDetail extends StatefulWidget {
  final HouseModel houseModel;
  HouseDetail([this.houseModel]);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HouseDetailState();
  }
}

class HouseDetailState extends State<HouseDetail> {
  @override
  void initState() {
    // TODO: implement initState
    {
      //Controller update

      new Future.delayed(Duration.zero, () {
        final houseProvider =
            Provider.of<HouseProvider>(context, listen: false);
        houseProvider.loadValues(widget.houseModel);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final houses = Provider.of<List<HouseModel>>(context);
    final houseProvider = Provider.of<HouseProvider>(context);
    // TODO: implement build
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
          appBar: AppBar(
            title: Text('ઘરની વિગત'),
          ),
          drawer: DrawerCodeOnly(),
          body: WillPopScope(
              onWillPop: onBackPressed,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5.0),
                    child: Card(
                      color: Colors.white70,
                      elevation: 10.0,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text('મકાનમાલિક રહે છે'),
                            leading: CircleAvatar(
                                backgroundColor: Colors.teal,
                                child: Icon(Icons.person)),
                          ),
                          ListTile(
                            title: Text('ભાડુઆત રહે છે'),
                            leading: CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Icon(Icons.people)),
                          ),
                          ListTile(
                            title: Text('ખાલી છે'),
                            leading: CircleAvatar(
                                backgroundColor: Colors.red[400],
                                child: Icon(Icons.account_box)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 5.0,
                  ),
                  // Title(),
                  //ExpesneTexts(),
                  (houses != null)
                      ?
                      // Row(
                      //     children: <Widget>[
                      //       Expanded(
                      //           child: SizedBox(
                      //         height: 500.0,
                      //         child:
                      Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: houses.length,
                              itemBuilder: (context, index) {
                                return FocusedMenuHolder(
                                    onPressed: () {},
                                    menuItems: <FocusedMenuItem>[
                                      FocusedMenuItem(
                                          title: Text('Update'),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddHouseDetail(
                                                            houses[index])));
                                          }),
                                      FocusedMenuItem(
                                          title: Text('Delete'),
                                          onPressed: () {
                                            setState(() {
                                              houseProvider.removeExpense(
                                                  houses[index].houseId);
                                              _showSnackBar(context,
                                                  'Item Deleted Successfully');
                                              // _delete(index);
                                            });

                                            // expenseProvider.removeExpense(
                                            //     widget.expenseModel.expenseId);
                                          }),
                                    ],
                                    child: Card(
                                      child: ListTile(
                                        title: Text(
                                          houses[index].houseOwner,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(houses[index]
                                            .houseMobile
                                            .toString()),
                                        leading: CircleAvatar(
                                          backgroundColor: getHouseTypeColor(
                                              houses[index].houseType),
                                          child: getHouseTypeIcon(
                                              houses[index].houseType),
                                        ),
                                        trailing: Text(
                                          houses[index].houseNumber,
                                          style: TextStyle(
                                              color: getHouseTypeColor(
                                                  houses[index].houseType),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.0),
                                        ),
                                        onTap: () {
                                          //homestate.getDrawerItemWidget(1);
                                          UrlLauncher.launch(
                                              ('tel:${houses[index].houseMobile}'));
                                          print('lenght:${houses.length}');
                                          //     builder: (context) => AddExpense()));
                                        },
                                      ),
                                      //  Divider()
                                    ));
                              }))
                      : Center(child: RefreshProgressIndicator())
                ],
              ))),
    );
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

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  //Reurns Priority Color
  Color getHouseTypeColor(String expenseType) {
    switch (expenseType) {
      case 'મકાનમાલિક':
        return Colors.teal;
        break;
      case 'ભાડુઆત':
        return Colors.blue;
        break;
      case 'ખાલી':
        return Colors.red[400];
        break;
      default:
        return Colors.teal;
    }
  }

  Icon getHouseTypeIcon(String houseType) {
    switch (houseType) {
      case 'મકાનમાલિક':
        return Icon(Icons.person);
        break;
      case 'ભાડુઆત':
        return Icon(Icons.people);
        break;
      case 'ખાલી':
        return Icon(Icons.account_box);
        break;
      default:
        return Icon(Icons.add);
    }
  }
}
