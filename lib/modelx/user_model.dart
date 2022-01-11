// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {

  final Timestamp lastModify;
  final String uid;
  final String email;
  final String name;
  final String contactNo;
  final String unitAndBuilding;
  final String estate;
  final String district;
  final String userPhoto;
  final String recipientName;

  UserModel(this.lastModify, this.uid, this.email, this.name, this.contactNo, this.unitAndBuilding, this.estate, this.district, this.userPhoto, this.recipientName);

  factory UserModel.initialData(){
    return UserModel(Timestamp.now(), '', '', '', '', '', '', '', '','');
  }

  UserModel.fromFirestore(Map<String, dynamic> dataMap) :
    lastModify = dataMap['LAST_MODIFY'],
    uid = dataMap['UID'],
    email = dataMap['EMAIL'],
    name = dataMap['USERNAME'],
    contactNo = dataMap['CONTACT'],
    unitAndBuilding = dataMap['UNIT_AND_BUILDING'],
    estate = dataMap['ESTATE'],
    district = dataMap['DISTRICT'],
    userPhoto = dataMap['IMAGE'],
    recipientName = dataMap['RECIPIENT_NAME'];
}


