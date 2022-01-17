import 'package:asher_store_cms/model/user_model.dart';
import 'package:asher_store_cms/service/firebase_service.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class MemberListViewController extends GetxController{

  RxList<UserModel> memberList = <UserModel>[].obs;
  RxList<UserModel> searchResultList = <UserModel>[].obs;
  TextEditingController searchTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    memberList.bindStream(FirebaseService().getAllMember);
  }

  void searchMember(String val){
    searchResultList.clear();
    // searchResultCounter.value = 0;
    if(val.isNotEmpty){
      for(int i = 0; i < memberList.length; i++){
        if(memberList[i].name!.toUpperCase().contains(val.toUpperCase())){
          searchResultList.add(memberList[i]);
          // searchResultCounter.value = searchResultList.length;
        }
      }
    }
  }

  void clearSearchData(String val){
    if(val.isEmpty){
      searchResultList.clear();
    }
  }

}