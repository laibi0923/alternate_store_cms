import 'package:asher_store_cms/model/refundpolicy_model.dart';
import 'package:asher_store_cms/service/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RefundPolicyController extends GetxController{

  Rx<RefundPolicyModel> refundPolicyModel = RefundPolicyModel().obs;
  TextEditingController textEditingController = TextEditingController();
  
  @override
  void onInit() {
    super.onInit();
    refundPolicyModel.bindStream(FirebaseService().getRefundPolicyContent);
  }

  @override
  void onClose() {
    super.onClose();
    textEditingController.dispose();
  }
  
  void updatePolicy(){
    FirebaseService().updateReturnPolicy(textEditingController.text);
    Get.back();
  }
  
}