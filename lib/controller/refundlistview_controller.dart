import 'package:asher_store_cms/model/refund_model.dart';
import 'package:asher_store_cms/service/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class RefundListViewController extends GetxController{

  RxList<RefundModel> refundList = <RefundModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    refundList.bindStream(FirebaseService().getRefundList);
    print('>>>>>>>> ${refundList.length}');
  }


}