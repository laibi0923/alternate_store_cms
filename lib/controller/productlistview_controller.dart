import 'package:asher_store_cms/service/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class ProductListViewController extends GetxController{

  RxList productlist = [].obs;
  RxList resultlist = [].obs;
  RxInt counter = 0.obs;
  TextEditingController searchEditingController = TextEditingController();

  @override
  void onReady() {
    super.onReady();
    productlist.bindStream(FirebaseService().getProduct);
  }

  @override
  void onClose() {
    super.onClose();
    searchEditingController.dispose();
  }

  void searchProduct(){
    resultlist.clear();
    if(searchEditingController.text.isNotEmpty){
      for(int i = 0; i < productlist.length; i++){
        if(
          productlist[i].productName.toUpperCase().contains(searchEditingController.text.toUpperCase()) ||
          productlist[i].productNo.toUpperCase().contains(searchEditingController.text.toUpperCase())
        ){
          resultlist.add(productlist[i]);
          counter.value = resultlist.length;
        }
      }
    }
  }

  void clearSearch(){
    searchEditingController.clear();
    resultlist.clear();
    counter.value = 0;
  }

  // _searchList.clear();
//       _searchResultCounter = 0;
//       if(val.isNotEmpty) {
//         for(int i = 0; i < list.length; i++){
//           if(
//             list[i].productName.toUpperCase().contains(val.toUpperCase()) ||
//             list[i].productNo.toUpperCase().contains(val.toUpperCase())
//           ){
//             _searchList.add(list[i]);
//             _searchResultCounter = _searchList.length;
//           } 
//         }
//       }  

}