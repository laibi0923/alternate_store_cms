import 'package:cloud_firestore/cloud_firestore.dart';

class MailBoxModel {
  Timestamp? createDate;
  String? title;
  String? content;
  bool? isReaded;
  String? docId;

  MailBoxModel({this.createDate, this.content, this.isReaded, this.docId, this.title});

  MailBoxModel.fromFirestore(Map<String, dynamic>? doc){
    createDate = doc?['CREATE_DATE'];
    title = doc?['TITLE'];
    content = doc?['CONTENT'];
    isReaded = doc?['ISREADED'];
    docId = doc?['DOCID'];
  }
  
}
