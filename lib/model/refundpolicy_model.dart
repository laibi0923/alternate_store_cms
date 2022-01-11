import 'package:cloud_firestore/cloud_firestore.dart';

class RefundPolicyModel{
  Timestamp? lastModify;
  String? content;
  RefundPolicyModel({this.lastModify, this.content});

  RefundPolicyModel.fromFirestore(Map<String, dynamic> dataMap):
    lastModify = dataMap['LAST_MODIFY'],
    content = dataMap['CONTENT'];

}