import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_society/models/expense_model.dart';
import 'package:my_society/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class ExpenseProvider with ChangeNotifier {
  final firestoreService = FireStoreService();
  String _expenseId;
  String _expenseType;
  double _expenseAmount;
  String _expenseDescription;
  var _expenseDate;
  var uuid = Uuid();

  //Getters
  String get expenseType1 => _expenseType;
  double get expenseAmount1 => _expenseAmount;
  String get expenseDescription1 => _expenseDescription;
  // var get expenseDate1 => _expenseDate;

  //Setters
  changeExpenseType(String value) {
    this._expenseType = value;
    notifyListeners();
  }

  changeExpenseAmount(String value) {
    _expenseAmount = double.parse(value);
    notifyListeners();
  }

  changeExpenseDescription(String value) {
    _expenseDescription = value;
    notifyListeners();
  }

  // changeExpenseDate(String value) {
  //   if (value == null) {
  //     return 'Select a date';
  //   } else {
  //     _expenseDate = value;
  //   }

  //   notifyListeners();
  // }

  saveExpense() {
    //print("$expenseType,$expenseAmount,$expenseDescription,$expenseDate");

    print(_expenseId);
    if (_expenseId == null) {
      var newExpense = ExpenseModel(
          expenseType: expenseType1,
          expenseAmount: expenseAmount1,
          expenseDescription: expenseDescription1,
          expenseDate: DateTime.now(),
          expenseId: uuid.v4());
      firestoreService.saveExpense(newExpense);
    } else {
      var updateExpense = ExpenseModel(
          expenseType: _expenseType,
          expenseAmount: _expenseAmount,
          expenseDescription: _expenseDescription,
          expenseDate: _expenseDate,
          expenseId: _expenseId);
      firestoreService.saveExpense(updateExpense);
    }
  }

  loadValues(ExpenseModel expenseModel) {
    // expenseModel = ExpenseModel();
    _expenseId = expenseModel.expenseId;
    _expenseAmount = expenseModel.expenseAmount;
    _expenseDate = expenseModel.expenseDate;
    _expenseDescription = expenseModel.expenseDescription;
    _expenseType = expenseModel.expenseType;
  }

  removeExpense(String expenseId) {
    firestoreService.removeExpense(expenseId);
  }

  Future getTotalIncome() async {
    return await firestoreService.getTotalIncome();
  }

  Future getTotalExpense() async {
    return await firestoreService.getTotalExpense();
  }
}
