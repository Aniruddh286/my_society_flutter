//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_society/models/expense_model.dart';
import 'package:my_society/models/house_model.dart';
import 'package:flutter/material.dart';
//import 'dart:html';

class FireStoreService {
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  // CollectionReference collectionReference =
  //     FirebaseFirestore.instance.collection('expense');
  Future<void> saveHouse(HouseModel houseModel) {
    return _db
        .collection('house')
        .doc(houseModel.houseId)
        .set(houseModel.toMap());
    // collectionReference.add(expenseModel.toMap());
  }

  Future<void> saveExpense(ExpenseModel expenseModel) {
    return _db
        .collection('expense')
        .doc(expenseModel.expenseId)
        .set(expenseModel.toMap());
    // collectionReference.add(expenseModel.toMap());
  }

  Stream<List<ExpenseModel>> getExpense() {
    return _db
        .collection('expense')
        .orderBy('expenseDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((document) => ExpenseModel.fromFirestore(document.data()))
            .toList());
  }

  Stream<List<ExpenseModel>> getDateWiseExpense(
      DateTime startDate, DateTime endDate) {
    return _db
        .collection('expense')
        .orderBy('expenseDate', descending: true)
        .where('expenseDate', isGreaterThan: startDate)
        .where('expenseDate', isLessThanOrEqualTo: endDate)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((document) => ExpenseModel.fromFirestore(document.data()))
            .toList());
  }

  Stream<List<HouseModel>> getHouse() {
    return _db
        .collection('house')
        .orderBy('houseNumber', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((document) => HouseModel.fromFirestore(document.data()))
            .toList());
  }

  Future<void> removeExpense(String expenseId) {
    return _db.collection('expense').doc(expenseId).delete();
  }

  Future<void> removeHouse(String houseId) {
    return _db.collection('house').doc(houseId).delete();
  }

  Future getTotalIncome() async {
    var temp = await _db
        .collection('expense')
        .where('expenseType', isEqualTo: 'આવક')
        .get();

    temp.docs.forEach((doc) => totalIncome += doc.data()['expenseAmount']);

    print('TotalIncome:$totalIncome');
    return totalIncome;
  }

  Future getTotalExpense() async {
    var temp = await _db
        .collection('expense')
        .where('expenseType', isEqualTo: 'જાવક')
        .get();

    temp.docs.forEach((doc) => totalExpense += doc.data()['expenseAmount']);

    print('TotalExpense:$totalExpense');
    return totalExpense;
  }
}
