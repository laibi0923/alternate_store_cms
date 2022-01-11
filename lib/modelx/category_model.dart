import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final Timestamp createDate;
  final String name;
  bool quickSearch;
  bool isSelect;
  final String docId;

  CategoryModel(this.createDate, this.name, this.isSelect, this.quickSearch, this.docId);

  factory CategoryModel.initialData() {
    return CategoryModel(Timestamp.now(), '', false, false, '');
  }

  CategoryModel.fromFirestore(Map<String, dynamic> dataMap, String id) :
    createDate = dataMap['CREATE_DATE'],
    name = dataMap['NAME'],
    quickSearch = dataMap ['QUICK_SEARCH'],
    isSelect = false,
    docId = id;
}