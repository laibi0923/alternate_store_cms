import 'package:cloud_firestore/cloud_firestore.dart';

class RefundModel{
  final Timestamp createDate;
  final DocumentReference ref;
  final bool isCompleted;
  final String orderProductNo;
  final String docId;
  final String orderNumber;

  RefundModel(this.createDate, this.ref, this.isCompleted, this.orderProductNo, this.docId, this.orderNumber);

  RefundModel.fromFirestore(Map<String, dynamic> dataMap, String id):
    createDate = dataMap['CREATE_DATE'],
    ref = dataMap['REF'],
    isCompleted = dataMap['ISCOMPLETE'],
    orderProductNo = dataMap['ORDER_PRODUCT_NO'],
    orderNumber = dataMap['ORDER_NO'],
    docId = id;
    
}