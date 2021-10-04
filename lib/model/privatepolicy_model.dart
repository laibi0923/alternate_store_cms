import 'package:cloud_firestore/cloud_firestore.dart';

class PrivatePolicyModel{
  final Timestamp lastModify;
  final String content;
  PrivatePolicyModel(this.lastModify, this.content);

  factory PrivatePolicyModel.initialData(){
    return PrivatePolicyModel(Timestamp.now(), '');
  }

  PrivatePolicyModel.fromFirestore(Map<String, dynamic> dataMap):
    lastModify = dataMap['LAST_MODIFY'],
    content = dataMap['CONTENT'];

}