import 'package:asher_store_cms/widget/comfirmation_dialog.dart';
import 'package:asher_store_cms/service/firebase_service.dart';
import 'package:asher_store_cms/model/orderreceive_model.dart';
import 'package:asher_store_cms/widget/custom_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsController extends GetxController{

  //  單件出貨
  Future<void> onShipping(int index, List dataList, OrderReceiveModel orderReceiveModel) async {

    if(dataList[index]['SHIPPING_STATUS'] == ''){
      bool dialogResult = await showDialog(
        context: Get.context!, 
        builder: (BuildContext context){
          return comfirmationDialog(
            context,
            '出貨確定',
            "確定將 ${dataList[index]['PRODUCT_NAME']} 發貨?",
            '確定',
            '取消',
          );
        }
      );

      if(dialogResult == true){
       updateDatabase(dataList, index, orderReceiveModel);
       Get.back();
      }
    }
  }
  
  //  全部出貨
  void shippingAll(BuildContext context, List dataList, OrderReceiveModel orderReceiveModel){
    for(int i = 0; i < dataList.length; i++){
      updateDatabase(dataList, i, orderReceiveModel);
    }
    Get.back();
    CustomSnackBar().show(Get.context!, '${orderReceiveModel.orderNumber} 出貨成功');
  }

  //  更新資料庫
  void updateDatabase(List dataList, int index, orderReceiveModel){
    
    List newDataList  = dataList;

    newDataList[index].remove('SHIPPING_STATUS');
    newDataList[index].addAll({
      'SHIPPING_STATUS' : '已出貨',
      'SHIPPING_DATE' : Timestamp.now()
    });

    orderReceiveModel.ref.update({
      'ORDER_PRODUCT' : newDataList
    });

    FirebaseService().soldProductCounter(dataList[index]['PRODUCT_NO']);

    //  判斷每項出貨狀態 = True總和如相等於貨品數目, 則更新 Order ISCOMPLETE
    int isCompleteProduct = 0;
    for (var element in dataList) {
      if(element['SHIPPING_STATUS'].isNotEmpty){
        isCompleteProduct++;
      }
    }

    if(isCompleteProduct == dataList.length){
      DocumentReference ref = FirebaseFirestore.instance.collection('order').doc(orderReceiveModel.docId);
      ref.update({
        'ISCOMPLETE' : true
      });
    }
  }

}