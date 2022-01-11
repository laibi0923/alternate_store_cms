import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final Timestamp createDate;
  final String name;
  final bool quickSearch;
  // final String docId;

  CategoryModel(this.createDate, this.name, this.quickSearch);

  factory CategoryModel.initialData() {
    return CategoryModel(Timestamp.now(), '', false,);
  }

  CategoryModel.fromFirestore(Map<String, dynamic> dataMap) :
    createDate = dataMap['CREATE_DATE'],
    name = dataMap['NAME'],
    quickSearch = dataMap ['QUICK_SEARCH'];
    // docId = id;
    
}