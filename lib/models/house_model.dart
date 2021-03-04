class HouseModel {
  String houseId;
  String houseNumber;
  String houseOwner;
  int houseMobile;
  String houseType;

  HouseModel(
      {this.houseId,
      this.houseNumber,
      this.houseOwner,
      this.houseMobile,
      this.houseType});

  Map<String, dynamic> toMap() {
    return {
      'houseId': houseId,
      'houseNumber': houseNumber,
      'houseOwner': houseOwner,
      'houseMobile': houseMobile,
      'houseType': houseType
    };
  }

  HouseModel.fromFirestore(Map<String, dynamic> firestore)
      : houseId = firestore['houseId'],
        houseNumber = firestore['houseNumber'],
        houseOwner = firestore['houseOwner'],
        houseMobile = firestore['houseMobile'],
        houseType = firestore['houseType'];
}
