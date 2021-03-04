import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  String expenseId;
  String expenseType;
  double expenseAmount;
  String expenseDescription;
  var expenseDate;

  ExpenseModel(
      {this.expenseId,
      this.expenseType,
      this.expenseAmount,
      this.expenseDescription,
      this.expenseDate});

  Map<String, dynamic> toMap() {
    return {
      'expenseId': expenseId,
      'expenseType': expenseType,
      'expenseAmount': expenseAmount,
      'expenseDescription': expenseDescription,
      'expenseDate': expenseDate,
    };
  }

  ExpenseModel.fromFirestore(Map<String, dynamic> firestore)
      : expenseId = firestore['expenseId'],
        expenseAmount = firestore['expenseAmount'],
        expenseDescription = firestore['expenseDescription'],
        expenseType = firestore['expenseType'],
        expenseDate = firestore['expenseDate'];
}
