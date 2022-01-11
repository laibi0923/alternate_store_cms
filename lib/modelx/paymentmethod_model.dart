import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentMethodModel{
  final Timestamp createDate;
  final Timestamp lastModify;
  final String holder;
  final String qrImage;
  final String methodName;
  final String docId;
  final String remark;

  PaymentMethodModel(this.createDate, this.lastModify, this.holder, this.qrImage, this.methodName, this.docId, this.remark);
  
  factory PaymentMethodModel.initalData(){
    return PaymentMethodModel(Timestamp.now(), Timestamp.now(), '', '', '', '', '');
  }

  PaymentMethodModel.fromFirestore(Map<String, dynamic> dataMap, String id) :
    createDate = dataMap['CREATE_DATE'],
    lastModify = dataMap['LAST_MODIFY'],
    holder = dataMap['HOLDER'],
    qrImage = dataMap['QRIMAGE'],
    methodName = dataMap['NAME'],
    remark = dataMap['REMARK'],
    docId = id;
  
}