import 'package:asher_store_cms/model/privatepolicy_model.dart';
import 'package:asher_store_cms/service/firebase_service.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivatePolicyController extends GetxController{

  Rx<PrivatePolicyModel> privatePolicyModel = PrivatePolicyModel().obs;
  TextEditingController textEditingController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    privatePolicyModel.bindStream(FirebaseService().getPrivatePolicyContent);
    // textEditingController.text = privatePolicyModel.value.content!;
  }

  @override
  void onClose() {
    super.onClose();
    textEditingController.dispose();
  }

  void updatePolicy(){
    FirebaseService().updatePrivatePolicy(textEditingController.text);
    Get.back();
  }

}