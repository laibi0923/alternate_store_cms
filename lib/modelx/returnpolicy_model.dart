import 'package:cloud_firestore/cloud_firestore.dart';

class ReturnPolicyModel{
  final Timestamp lastModify;
  final String content;
  ReturnPolicyModel(this.lastModify, this.content);

  factory ReturnPolicyModel.initialData(){
    return ReturnPolicyModel(Timestamp.now(), '');
  }

  ReturnPolicyModel.fromFirestore(Map<String, dynamic> dataMap):
    lastModify = dataMap['LAST_MODIFY'],
    content = dataMap['CONTENT'];

}