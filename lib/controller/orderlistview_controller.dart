import 'package:asher_store_cms/model/order_model.dart';
import 'package:asher_store_cms/service/firebase_service.dart';
import 'package:asher_store_cms/model/orderreceive_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class OrderListViewController extends GetxController{

  RxList<OrderReceiveModel> orderlist = <OrderReceiveModel>[].obs;
  RxList<OrderReceiveModel> searchResultList = <OrderReceiveModel>[].obs;
  TextEditingController searchTextController = TextEditingController();
  RxDouble turnover = 0.0.obs;
  

  @override
  void onInit() {
    super.onInit();
    orderlist.bindStream(FirebaseService().getOrder);
  }

  @override
  void onReady() {
    super.onReady();
    checkNotComplete();
  }

  @override
  void onClose() {
    super.onClose();
    searchTextController.dispose();
  }

  //   檢查是否已完成出貨
  List checkNotComplete(){
    List notCompleteOrderList = [];
    for(int i = 0; i < orderlist.length; i++){
      if(orderlist[i].isComplete == false){
        notCompleteOrderList.add(orderlist[i]);
      }
    }
    return notCompleteOrderList;
  }

  //  搜尋訂單
  void searchOrder(String val){
    searchResultList.clear();
    if(val.isNotEmpty) {
      for(int i = 0; i < orderlist.length; i++){
        if(orderlist[i].orderNumber.toUpperCase().contains(val.toUpperCase())){
          searchResultList.add(orderlist[i]);
          
        } 
      }
    }  
  }

  //  清除搜尋記錄
  void clearSearchData(String val){
    if(val.isEmpty){
      searchResultList.clear();
    }
  }

  //  組合貨品名稱
  String combineProductName(OrderModel orderModel){
    List combineProductNameString = [];
    for(int i = 0 ; i < orderModel.orderProduct!.length; i++){
      combineProductNameString.add(orderModel.orderProduct![i]['PRODUCT_NAME']);
    }
    return combineProductNameString.toString().replaceAll('[', '').replaceAll(']', '');
  }

  //  計算總收入
  void getIncome(){

    DateTime now = DateTime.now();
    turnover.value = 0;

    for(int i = 0; i < orderlist.length; i++){
      if(
        orderlist[i].orderDate.toDate().year == now.year &&
        orderlist[i].orderDate.toDate().month == now.month &&
        orderlist[i].orderDate.toDate().day == now.day
      ){
        turnover.value = turnover.value + orderlist[i].xtotalAmount;
      }
    }
  }

}