import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  Timestamp? createDate;
  String? name;
  bool? quickSearch;
  bool? isSelect;
  String? docId;

  CategoryModel({this.createDate, this.name, this.isSelect, this.quickSearch, this.docId});

  CategoryModel.fromFirestore(Map<String, dynamic> dataMap, String id) :
    createDate = dataMap['CREATE_DATE'],
    name = dataMap['NAME'],
    quickSearch = dataMap ['QUICK_SEARCH'],
    isSelect = false,
    docId = id;
}