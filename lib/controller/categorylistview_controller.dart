import 'package:asher_store_cms/model/category_model.dart';
import 'package:asher_store_cms/service/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CategoryListViewController extends GetxController{

  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  RxList<CategoryModel>  searchResultList = <CategoryModel> [].obs;
  RxInt searchResultCounter = 0.obs;
  List<CategoryModel> tempSelectList = [];
  final TextEditingController searchTextController = TextEditingController();

  @override
  void onReady() {
    super.onReady();
    categoryList.bindStream(FirebaseService().getCategory);
  }

  @override
  void onClose() {
    super.onClose();
    searchTextController.dispose();
  }

  void setupData(List<CategoryModel> list){
    tempSelectList.clear();
    tempSelectList.addAll(list);
    for (var element in categoryList) {
      element.isSelect = false;
      for(int i = 0; i < list.length; i++){
        if(element.docId == list[i].docId){
          element.isSelect = true;
        }
      }
    }
  }

  void delCategory(String docId){
    FirebaseService().delCategory(docId);
    Get.back();
  }

  void searchCategory(String val){
    searchResultList.clear();
    searchResultCounter.value = 0;
    if(val.isNotEmpty){
      for(int i = 0; i < categoryList.length; i++){
        if(categoryList[i].name!.toUpperCase().contains(val.toUpperCase())){
          searchResultList.add(categoryList[i]);
          searchResultCounter.value = searchResultList.length;
        }
      }
    }
  }

  void clearSearchResult(String val){
    if(val.isEmpty){
      searchResultList.clear();
    }
  }

  void selectItem(int index){

    if(searchResultList.isNotEmpty){

      if(searchResultList[index].isSelect == false){
        searchResultList[index].isSelect = true;
        tempSelectList.add(searchResultList[index]);
      } else {
        searchResultList[index].isSelect = false;
        for(int i = 0; i < tempSelectList.length; i++){
          if(tempSelectList[i].docId == searchResultList[index].docId){
            tempSelectList.removeAt(i);
          }
        }
      }
      searchResultList.refresh();

    } else {

      if(categoryList[index].isSelect == false) {
        categoryList[index].isSelect = true;
        tempSelectList.add(categoryList[index]);
      } else {
        categoryList[index].isSelect = false;
        for(int i = 0; i < tempSelectList.length; i++){
          if(tempSelectList[i].docId == categoryList[index].docId){
            tempSelectList.removeAt(i);
          }
        }
      }
      categoryList.refresh();

    }

  }
  
  void setQuickSearch(String docId, bool isSet){
    FirebaseService().setQuickSearch(docId, isSet);
    Get.back();
  }
  
}