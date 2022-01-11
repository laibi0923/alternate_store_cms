import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  
  Timestamp? createDate;
  Timestamp? lastModify;
  String? uid;
  String? email;
  String? photo;
  String? name;
  String? phone;
  String? recipientName;
  String? unitAndBuilding;
  String? estate;
  String? district;

  UserModel({this.createDate, this.lastModify, this.uid, this.email, this.photo, this.name, this.phone, this.recipientName, this.unitAndBuilding, this.estate, this.district});

  UserModel.fromFirestore(Map<String, dynamic>? doc){
    createDate = doc?['CREATE_DATE'];
    lastModify = doc?['LAST_MODIFY'];
    uid = doc?['UID'];
    email = doc?['EMAIL'];
    photo = doc?['PHOTO'];
    name = doc?['NAME'];
    recipientName = doc?['RECIPIENT_NAME'];
    unitAndBuilding = doc?['UNIT_AND_BUILDING'];
    estate = doc?['ESTATE'];
    district = doc?['DISTRICT'];
    phone = doc?['PHONE'];
  }

}