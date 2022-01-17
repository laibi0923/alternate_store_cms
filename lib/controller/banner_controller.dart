import 'package:asher_store_cms/model/banner_model.dart';
import 'package:asher_store_cms/service/firebase_service.dart';
import 'package:get/get.dart';

class BannerController extends GetxController{

  Rx<List<BannerModel>> bannerList = Rx([]);
  
  @override
  void onReady() {
    super.onReady();
    bannerList.bindStream(FirebaseService().getBanner);
  }

}