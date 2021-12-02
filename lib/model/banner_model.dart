import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  final Timestamp createDate;
  final String quetyString;
  final String uri;
  final String docId;

  BannerModel(this.createDate, this.quetyString, this.uri, this.docId);

  factory BannerModel.initialData() {
    return BannerModel(Timestamp.now(), '', '', '');
  }

  BannerModel.fromFirestore(Map<String, dynamic> dataMap, String id) :
    createDate = dataMap['CREATE_DATE'],
    quetyString = dataMap['KEY'],
    uri = dataMap['URL'],
    docId = id;

}