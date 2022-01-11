import 'package:cloud_firestore/cloud_firestore.dart';

class UserCouponModel{
  final Timestamp date;
  final String code;

  UserCouponModel(this.date, this.code);

  factory UserCouponModel.initialData(){
    return UserCouponModel(Timestamp.now(), '');
  }

  UserCouponModel.fromFirestore(Map<String, dynamic> dataMap) :
    date = dataMap['DATE'],
    code = dataMap['CODE'];

}