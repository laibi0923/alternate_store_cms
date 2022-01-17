import 'package:cloud_firestore/cloud_firestore.dart';

class CouponModel{
  final Timestamp createDate;
  final String couponCode;
  final double discountAmount;
  final double percentage;
  final Timestamp validDate;
  final String remark;
  final bool unLimited;
  final String docId;

  CouponModel(this.createDate, this.couponCode, this.discountAmount, this.percentage, this.validDate, this.remark, this.unLimited, this.docId);
  
  CouponModel.fromFirestore(Map<String, dynamic> dataMap, String id) :
    createDate = dataMap['CREATE_DATE'],
    couponCode = dataMap['CODE'],
    discountAmount = dataMap['DISCOUNT_AMOUNT'],
    percentage = dataMap['PERCENTAGE'],
    validDate = dataMap['VALID_DATE'],
    remark = dataMap['REMARK'],
    unLimited = dataMap['UNLIMITED'],
    docId = id;

}