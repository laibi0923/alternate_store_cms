import 'package:cloud_firestore/cloud_firestore.dart';

class RefundModel{
  final Timestamp createDate;
  final Map<String, dynamic> product;

  RefundModel(this.createDate, this.product);

  factory RefundModel.initialData(){
    return RefundModel(Timestamp.now(), {});
  }

  RefundModel.fromFirestore(Map<String, dynamic> dataMap):
    createDate = dataMap['CREATE_DATE'],
    product = dataMap['PRODUCT'];
    

}