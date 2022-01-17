import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel{
  final Timestamp createDate;
  final String bannerUri;
  final String queryString;
  String docid;

  BannerModel(this.bannerUri, this.queryString, this.docid, this.createDate);

  BannerModel.fromFirestore(Map<String, dynamic> dataMap, String id) :
    createDate = dataMap['CREATE_DATE'],
    bannerUri = dataMap['URL'],
    queryString = dataMap['KEY'],
    docid = id;
}