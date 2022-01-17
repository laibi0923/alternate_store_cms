import 'dart:io';
import 'package:asher_store_cms/comfirmation_dialog.dart';
import 'package:asher_store_cms/model/banner_model.dart';
import 'package:asher_store_cms/service/firebase_service.dart';
import 'package:asher_store_cms/widget/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BannerEditorController extends GetxController{

  final TextEditingController searchKeyTextController = TextEditingController();
  RxString imageFilePatch = RxString('');

  @override
  void onClose() {
    super.onClose();
    searchKeyTextController.dispose();
    imageFilePatch.value = '';
  }

  //  Client choose Image
  Future<void> pickupImage() async {
    try {
      final xfile = (await ImagePicker().pickImage(source: ImageSource.gallery))!;
      if(xfile.path.isNotEmpty){
        imageFilePatch.value = xfile.path;
      }
    } on PlatformException catch(e) {
      // ignore: avoid_print
      print('Failed to pick image : $e');
    }
  }

  //  Upload Banner
  Future<void> uploadBanner(BannerModel? bannerModel) async {

    if(searchKeyTextController.text.isEmpty){
      CustomSnackBar().show(Get.context!, '請輸入關鍵字');
      return;
    }

    if(imageFilePatch.isEmpty && bannerModel == null){
      CustomSnackBar().show(Get.context!, '請選擇圖片');
      return;
    }

    showLoadingIndicator();

    if(bannerModel == null){
      FirebaseService().uploadBannerImage(File(imageFilePatch.value)).then((url) {
        FirebaseService().createBanner(url, searchKeyTextController.text).then((value) {
          Get.back();
          Get.back();
        });
      });
    } else if(imageFilePatch.isNotEmpty){
      FirebaseService().uploadBannerImage(File(imageFilePatch.value)).then((url) {
        FirebaseService().updateBanner(bannerModel.docid, searchKeyTextController.text, url).then((value) {
          Get.back();
          Get.back();
        });
      });
    } else {
      FirebaseService().updateBanner(bannerModel.docid, searchKeyTextController.text, bannerModel.bannerUri).then((value) {
        Get.back();
        Get.back();
      });
    }
  }

  //  Remove Banner
  Future<void> delBanner(BannerModel bannerModel) async {
    bool result = await showDialog(
      context: Get.context!, 
      builder: (BuildContext context){
        return comfirmationDialog(
          context, 
          '刪除', 
          '一經刪除將無法復原，確定從資料庫中刪除?', 
          '確定', 
          '取消'
        );
      }
    );

    if(result == true){
      FirebaseService().removeBanner(bannerModel.docid);
      Get.back();
    }
  }
  
  //  Show Loading Screen
  void showLoadingIndicator() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async =>  false,
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))
            ),
            backgroundColor: Colors.black87,
            content: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black.withOpacity(0.8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  
                  Padding(
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(strokeWidth: 3, color: Colors.grey),
                    ),
                    padding: EdgeInsets.only(bottom: 16)
                  ),

                  Padding(
                    child: Text(
                      '請稍等',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                      textAlign: TextAlign.center,
                    ),
                    padding: EdgeInsets.only(bottom: 4)
                  ),


                  Text(
                    '上載中...',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14
                    ),
                    textAlign: TextAlign.center,
                  ),

                ],
              ),
            )
          ),
        );
      },
    );
  }

}