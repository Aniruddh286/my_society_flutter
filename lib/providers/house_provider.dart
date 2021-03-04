import 'package:flutter/material.dart';
import 'package:my_society/models/house_model.dart';
import 'package:my_society/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class HouseProvider with ChangeNotifier {
  final firestoreService = FireStoreService();
  String _houseId;
  String _houseType;
  String _houseNumber;
  String _houseOwner;
  int _houseMobile;
  var uuid = Uuid();

  //Getters
  String get houseType1 => _houseType;
  String get houseNumber1 => _houseNumber;
  String get houseOwner1 => _houseOwner;
  int get houseMobile1 => _houseMobile;

  //Setters
  changeHouseType(String value) {
    this._houseType = value;
    notifyListeners();
  }

  changeHouseNumber(String value) {
    this._houseNumber = value;
    notifyListeners();
  }

  changeHouseOwner(String value) {
    _houseOwner = value;
    notifyListeners();
  }

  changeHouseMobile(String value) {
    _houseMobile = int.parse(value);
    notifyListeners();
  }

  saveHouse() {
    //print("$expenseType,$expenseAmount,$expenseDescription,$expenseDate");
    print(_houseId);
    if (_houseId == null) {
      var newHouse = HouseModel(
          houseType: houseType1,
          houseNumber: houseNumber1,
          houseOwner: houseOwner1,
          houseMobile: houseMobile1,
          houseId: uuid.v4());
      firestoreService.saveHouse(newHouse);
    } else {
      var updateHouse = HouseModel(
          houseType: _houseType,
          houseNumber: _houseNumber,
          houseOwner: _houseOwner,
          houseMobile: _houseMobile,
          houseId: _houseId);
      firestoreService.saveHouse(updateHouse);
    }
  }

  loadValues(HouseModel houseModel) {
    //shouseModel = HouseModel();
    _houseId = houseModel.houseId;
    _houseType = houseModel.houseType;
    _houseNumber = houseModel.houseNumber;
    _houseOwner = houseModel.houseOwner;
    _houseMobile = houseModel.houseMobile;
  }

  removeExpense(String houseId) {
    firestoreService.removeHouse(houseId);
  }

  getTotalIncome() {
    firestoreService.getTotalIncome();
  }
}
