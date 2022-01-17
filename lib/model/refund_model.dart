import 'package:cloud_firestore/cloud_firestore.dart';

class RefundModel{
  final Timestamp createDate;
  final DocumentReference product;

  RefundModel(this.createDate, this.product);

  RefundModel.fromFirestore(Map<String, dynamic> dataMap):
    createDate = dataMap['CREATE_DATE'],
    product = dataMap['REF'];
    

}