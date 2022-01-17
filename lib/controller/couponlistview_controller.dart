import 'package:asher_store_cms/model/coupon_model.dart';
import 'package:asher_store_cms/screen/coupon/coupon_editor.dart';
import 'package:asher_store_cms/service/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CouponListViewController extends GetxController{

  RxList<CouponModel> couponlist = <CouponModel>[].obs;
  RxList<CouponModel> searchList = <CouponModel>[].obs; 
  RxInt searchResultCounter = 0.obs;
  final TextEditingController searchTextController = TextEditingController();

  @override
  void onReady() {
    super.onReady();
    couponlist.bindStream(FirebaseService().getCouponCode);
  }

  @override
  void onClose() {
    super.onClose();
    searchTextController.dispose();
  }

  void addCoupon(){
    Get.to(() =>  const CouponEditor(couponModel: null));
  }

  Future<void> editCoupon(CouponModel couponModel) async {
    bool result = await Get.to(() => CouponEditor(couponModel: couponModel));
    if(result == true){
      searchList.clear();
      searchResultCounter.value = 0;
      searchTextController.clear();
    }
  }

  void searchCoupon(String val){
    searchList.clear();
    if(val.isNotEmpty) {
      for(int i = 0; i < couponlist.length; i++){
        if(couponlist[i].couponCode.toUpperCase().contains(val.toUpperCase())){
          searchList.add(couponlist[i]);
          searchResultCounter.value = searchList.length;
        } 
      }
    }
  }

  void clearCoupon(String val){
    if(val.isEmpty){
      searchList.clear();
    }
  }

}