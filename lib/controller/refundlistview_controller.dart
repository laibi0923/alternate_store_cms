import 'package:asher_store_cms/comfirmation_dialog.dart';
import 'package:asher_store_cms/model/refund_model.dart';
import 'package:asher_store_cms/service/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RefundListViewController extends GetxController{

  RxList<RefundModel> refundList = <RefundModel>[].obs;
  RxList<RefundModel> searchResultList = <RefundModel>[].obs;
  TextEditingController searchTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    refundList.bindStream(FirebaseService().getRefundList);
  }

  @override
  void onClose() {
    super.onClose();
    searchTextController.dispose();
  }

  //  搜尋訂單
  void searchOrder(String val){
    searchResultList.clear();
    if(val.isNotEmpty) {
      for(int i = 0; i < refundList.length; i++){
        if(refundList[i].orderNumber.toUpperCase().contains(val.toUpperCase())){
          searchResultList.add(refundList[i]);
          
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

  //  批核退貨
  Future<void> refundApproval(List dataList, int index, RefundModel refundModel) async {

    if(dataList[index]['REFUND_STATUS'] == '退貨申請中'){
      bool dialogResult = await showDialog(
        context: Get.context!, 
        builder: (BuildContext context){
          return comfirmationDialog(
            context,
            '出貨確定',
            "確定將 ${dataList[index]['PRODUCT_NAME']} 退貨?",
            '確定',
            '取消',
          );
        }
      );

      if(dialogResult == true){
       List newDataList  = dataList;

        newDataList[index].remove('REFUND_STATUS');
        newDataList[index].addAll({
          'REFUND_STATUS' : '已退貨',
          'REFUND_DATE' : Timestamp.now()
        });

        refundModel.ref.update({
          'ORDER_PRODUCT' : newDataList
        });

        DocumentReference refx = FirebaseFirestore.instance.collection('refund').doc(refundModel.docId);
        refx.update({
          'ISCOMPLETE' : true
        });

      //  Get.back();
      }
    }

  }

  Future<void> refundReject(List dataList, int index, RefundModel refundModel) async {
    if(dataList[index]['REFUND_STATUS'] == '退貨申請中'){
      bool dialogResult = await showDialog(
        context: Get.context!, 
        builder: (BuildContext context){
          return comfirmationDialog(
            context,
            '出貨確定',
            "確定將 ${dataList[index]['PRODUCT_NAME']} 拒絕退貨?",
            '確定',
            '取消',
          );
        }
      );

      if(dialogResult == true){
       List newDataList  = dataList;
       newDataList[index].remove('REFUND_STATUS');
        newDataList[index].addAll({
          'REFUND_STATUS' : '退貨失敗',
        });

        refundModel.ref.update({
          'ORDER_PRODUCT' : newDataList
        });

        DocumentReference refx = FirebaseFirestore.instance.collection('refund').doc(refundModel.docId);
        refx.update({
          'ISCOMPLETE' : true
        });
      } 
    }
  }

  bool showBadge(){
    bool result = false;
    for(int i = 0; i < refundList.length; i++){
      if(refundList[i].isCompleted == false){
        result = true;
        break;
      } else {
        result = false;
      }
    }
    return result;
  }

}