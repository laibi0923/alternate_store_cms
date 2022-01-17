import 'package:asher_store_cms/custom_snackbar.dart';
import 'package:asher_store_cms/model/coupon_model.dart';
import 'package:asher_store_cms/service/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CouponEditorController extends GetxController{

  final TextEditingController couponCodeTextEditingController = TextEditingController();
  final TextEditingController couponPriceTextEditingController = TextEditingController();
  final TextEditingController couponPercentageTextEditingController = TextEditingController();
  final TextEditingController remarkTextEditingController = TextEditingController();
  final TextEditingController validDateTextEditingController = TextEditingController();
  DateTime validDate = DateTime.now();
  RxBool unLimited = false.obs;

  @override
  void onInit() {
    super.onInit();
    couponPercentageTextEditingController.text = '0.00';
    couponPriceTextEditingController.text = '0.00';
    validDateTextEditingController.text = DateFormat('yyyy/MM/dd').format(DateTime.fromMicrosecondsSinceEpoch(validDate.microsecondsSinceEpoch));
  }

  @override
  void onClose() {
    super.onClose();
    couponCodeTextEditingController.dispose();
    couponPriceTextEditingController.dispose();
    couponPercentageTextEditingController.dispose();
    remarkTextEditingController.dispose();
    validDateTextEditingController.dispose();
  }

  void setupCouponData(CouponModel couponModel){
    couponCodeTextEditingController.text = couponModel.couponCode;
    couponPriceTextEditingController.text = couponModel.discountAmount.toString();
    final formatter = NumberFormat("###,##0.00", "en");
    String formatterPercentage =  formatter.format(couponModel.percentage);
    couponPercentageTextEditingController.text = formatterPercentage;
    remarkTextEditingController.text = couponModel.remark;
    validDateTextEditingController.text = DateFormat('yyyy/MM/dd').format(DateTime.fromMicrosecondsSinceEpoch(couponModel.validDate.microsecondsSinceEpoch));
    validDate = DateTime.fromMicrosecondsSinceEpoch(couponModel.validDate.microsecondsSinceEpoch);
    unLimited.value = couponModel.unLimited;
  }

  //  上載
  void uploadCoupon(CouponModel? couponModel){

    if(couponCodeTextEditingController.text.isEmpty){
      CustomSnackBar().show(Get.context!, 'content');
      return;
    }

    double _couponPrice = 0.00;
    double _couponPercentage = 0.00;

    _couponPrice = double.parse(couponPriceTextEditingController.text.replaceAll(',', ''));
    _couponPercentage = double.parse(couponPercentageTextEditingController.text.replaceAll(',', ''));

    if(_couponPrice == 0 && _couponPercentage == 0){
      CustomSnackBar().show(Get.context!, '請輸入折扣');
      return;
    }

    if(couponModel != null){

      FirebaseService().updateCoupon(
        couponModel.docId,
        CouponModel(
          couponModel.createDate, 
          couponCodeTextEditingController.text, 
          _couponPrice, 
          _couponPercentage, 
          Timestamp.fromDate(validDate), 
          remarkTextEditingController.text, 
          unLimited.value,
          ''
        )
      );
      

    } else {

      FirebaseService().addCoupon(
        CouponModel(
          Timestamp.now(), 
          couponCodeTextEditingController.text, 
          _couponPrice, 
          _couponPercentage, 
          Timestamp.fromDate(validDate), 
          remarkTextEditingController.text, 
          unLimited.value,
          ''
        )
      );

    }
    Get.back();
  }

  Future<void> pickValidDate() async {

    final ThemeData theme = Theme.of(Get.context!);

    // ignore: unnecessary_null_comparison
    assert(theme.platform != null);

    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(Get.context!);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(Get.context!);
    }

  }

  /// This builds material date picker in Android
  buildMaterialDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != validDate){
      validDate = picked;
      validDateTextEditingController.text = 
      DateFormat('yyyy/MM/dd').format(DateTime.fromMicrosecondsSinceEpoch(validDate.microsecondsSinceEpoch));
    }
  }

  /// This builds cupertion date picker in iOS
  void buildCupertinoDatePicker(BuildContext context) {
    showModalBottomSheet(
    context: context,
    builder: (BuildContext builder) {
      return Container(
        height: MediaQuery.of(context).copyWith().size.height / 3,
        color: Colors.white,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (picked) {
            // ignore: unnecessary_null_comparison
            if (picked != null && picked != validDate){
              validDate = picked;
              validDateTextEditingController.text = 
              DateFormat('yyyy/MM/dd').format(DateTime.fromMicrosecondsSinceEpoch(validDate.microsecondsSinceEpoch));
            }
          },
          initialDateTime: DateTime.now(),
          minimumYear: 2000,
          maximumYear: 2025,
        ),
      );
    });
  }

  //  Delete Coupon
  void delCoupon(CouponModel couponModel) {
    FirebaseService().delCoupon(couponModel.docId);
    Get.back();
  }

  //  Limite switcher
  void setUnLimited(){
      if(unLimited.isTrue){
        unLimited.value = false;
      } else {
        unLimited.value = true;
      }
  }
  
}