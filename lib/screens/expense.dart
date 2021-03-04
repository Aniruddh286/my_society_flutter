import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:my_society/main.dart';
import 'package:my_society/models/expense_model.dart';
import 'package:my_society/providers/expense_provider.dart';
import 'package:my_society/screens/add_expense.dart';
import 'dart:io';

import 'package:provider/provider.dart';

//import 'add_expense.dart';

class Expense extends StatefulWidget {
  final ExpenseModel expenseModel;
  Expense({this.expenseModel});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ExpenseList();
  }
}

class ExpenseList extends State<Expense> {
  TextEditingController searchController = TextEditingController();

  // ExpenseModel expenseModel;
  // HomeState homestate = HomeState();
  @override
  void initState() {
    // TODO: implement initState
    //{
    //Controller update

    super.initState();
    checkInternet();
    //   new Future.delayed(Duration.zero, () {

    //   });
    // }
    new Future.delayed(Duration.zero, () {
      final expenseProvider =
          Provider.of<ExpenseProvider>(context, listen: false);
      expenseProvider.loadValues(widget.expenseModel);
    });
    print('${widget.expenseModel}');

    getIncome();
    getExpense();

    //getBalance();

    // searchController.addListener(_onSearchChanged);
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

  // _onSearchChanged() {
  //   print(searchController.text);
  // }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   searchController.removeListener(_onSearchChanged());
  //   searchController.dispose();
  //   super.dispose();
  // }
  double totalIncome = 0.0;
  double totalBalance = 0.0;
  getIncome() async {
    var expenseProvider = ExpenseProvider();

    totalIncome = await expenseProvider.getTotalIncome();
    setState(() {
      print('Income:$totalIncome');
    });
  }

  double totalExpense = 0.0;
  getExpense() async {
    var expenseProvider = ExpenseProvider();

    totalExpense = await expenseProvider.getTotalExpense();
    setState(() {
      print('Expense:$totalExpense');
    });
  }

  getBalance() {
    totalBalance = totalIncome - totalExpense;
  }

  // double totalBalance = 0.0;
  // getBalance() {
  // totalBalance = totalIncome - totalExpense;
  // }

  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<List<ExpenseModel>>(context);
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    // int totalIncome = 0;

    // setState(() {
    //   debugPrint('Income:$totalIncome');
    // });

    return Scaffold(
        drawer: DrawerCodeOnly(),
        appBar: AppBar(
          title: Text('લેણદેણની વિગત'),
        ),
        body: WillPopScope(
            onWillPop: onBackPressed,
            child: Column(
              children: <Widget>[
                // TextField(
                //   controller: searchController,
                //   decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
                // ),
                Container(
                    padding: EdgeInsets.all(5.0),
                    child: Card(
                        elevation: 10.0,
                        color: Colors.white70,
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text('આવક: ₹ ',
                                      // textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        color: Colors.teal,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0,
                                      )),
                                  Text(totalIncome.toString(),
                                      // textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal,
                                        fontSize: 17.0,
                                      )),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text('જાવક: ₹ ',
                                      // textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red[400],
                                        fontSize: 17.0,
                                      )),
                                  Text(totalExpense.toString(),
                                      //textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        color: Colors.red[400],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0,
                                      )),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text('જમા રકમ: ₹ ',
                                      // textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        color: Colors.blue[800],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0,
                                      )),
                                  Text((totalIncome - totalExpense).toString(),
                                      // textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[800],
                                        fontSize: 17.0,
                                      )),
                                ],
                              )
                            ],
                          ),
                        ))),
                // Title(),
                //ExpesneTexts(),
                (expenses != null)
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
                            itemCount: expenses.length,
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
                                                      AddExpense(
                                                          expenses[index])));
                                        }),
                                    FocusedMenuItem(
                                        title: Text('Delete'),
                                        onPressed: () {
                                          setState(() {
                                            getExpense();
                                            getIncome();
                                            getBalance();
                                            expenseProvider.removeExpense(
                                                expenses[index].expenseId);
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
                                        expenses[index].expenseDescription,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(_date(index)),
                                      leading: CircleAvatar(
                                        backgroundColor: getExpenseTypeColor(
                                            expenses[index].expenseType),
                                        child: getExpenseTypeIcon(
                                            expenses[index].expenseType),
                                      ),
                                      trailing: Text(
                                        expenses[index]
                                            .expenseAmount
                                            .toString(),
                                        style: TextStyle(
                                            color: getExpenseTypeColor(
                                                expenses[index].expenseType),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0),
                                      ),
                                      onTap: () {
                                        //homestate.getDrawerItemWidget(1);

                                        //     builder: (context) => AddExpense()));
                                      },
                                    ),
                                    //  Divider()
                                  ));
                            }))
                    : Center(child: RefreshProgressIndicator())
              ],
            )));
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

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

  Future<bool> _delete(int index) {
    final expenses = Provider.of<List<ExpenseModel>>(context);
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Do you want to exit?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      expenseProvider.removeExpense(expenses[index].expenseId);
                    },
                    child: Text("Yes")),
                FlatButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text("No"))
              ],
            ));
  }
}

// class ExpesneTexts extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     final expenseProvider = Provider.of<ExpenseProvider>(context);
//     int totalIncome = 0;
//     totalIncome = expenseProvider.getTotalIncome();

//     return Container(
//         padding: EdgeInsets.all(5.0),
//         child: Card(
//             elevation: 10.0,
//             color: Colors.indigo[50],
//             child: Container(
//               padding: EdgeInsets.all(5.0),
//               child: Column(
//                 children: <Widget>[
//                   Row(
//                     children: <Widget>[
//                       Text('આવક: ₹ ',
//                           textDirection: TextDirection.ltr,
//                           style: TextStyle(
//                             color: Colors.green,
//                             fontSize: 20.0,
//                           )),
//                       Text(totalIncome.toString(),
//                           textDirection: TextDirection.ltr,
//                           style: TextStyle(
//                             color: Colors.grey,
//                             fontSize: 20.0,
//                           )),
//                     ],
//                   ),
//                   Row(
//                     children: <Widget>[
//                       Text('જાવક: ₹ ',
//                           textDirection: TextDirection.ltr,
//                           style: TextStyle(
//                             color: Colors.red,
//                             fontSize: 20.0,
//                           )),
//                       Text(' ',
//                           textDirection: TextDirection.ltr,
//                           style: TextStyle(
//                             color: Colors.grey,
//                             fontSize: 20.0,
//                           )),
//                     ],
//                   ),
//                   Row(
//                     children: <Widget>[
//                       Text('જમા રકમ: ₹ ',
//                           textDirection: TextDirection.ltr,
//                           style: TextStyle(
//                             color: Colors.indigo,
//                             fontSize: 20.0,
//                           )),
//                       Text(' ',
//                           textDirection: TextDirection.ltr,
//                           style: TextStyle(
//                             color: Colors.grey,
//                             fontSize: 20.0,
//                           )),
//                     ],
//                   )
//                 ],
//               ),
//             )));
//   }
// }

class Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Hi')),
    );
  }
}
