import 'package:asher_store_cms/controller/orderlistview_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RootPageController extends GetxController{

  TextEditingController pwEditingController = TextEditingController();
  final TextEditingController validDateTextEditingController = TextEditingController();
  DateTime validDate = DateTime.now();
  RxBool unLimited = false.obs;
  RxString displayDate = '本日收益'.obs;


  @override
  void onClose() {
    super.onClose();
    pwEditingController.dispose();
    validDateTextEditingController.dispose();
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
  void buildMaterialDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != validDate){
      validDate = picked;
      Get.find<OrderListViewController>().getIncome(validDate);
      dateDisplay();
      // validDateTextEditingController.text = 
      // DateFormat('yyyy/MM/dd').format(DateTime.fromMicrosecondsSinceEpoch(validDate.microsecondsSinceEpoch));
    }
  }

  /// This builds cupertion date picker in iOS
  void buildCupertinoDatePicker(BuildContext context) {
    showModalBottomSheet(
    context: context,
    builder: (BuildContext builder) {
      return SizedBox(
        height: MediaQuery.of(context).copyWith().size.height / 3,
        child: CupertinoDatePicker(
          backgroundColor: Colors.white,
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (picked) {
            // ignore: unnecessary_null_comparison
            if (picked != null && picked != validDate){
              validDate = picked;
              Get.find<OrderListViewController>().getIncome(validDate);
              dateDisplay();
              // validDateTextEditingController.text = 
              // DateFormat('yyyy/MM/dd').format(DateTime.fromMicrosecondsSinceEpoch(validDate.microsecondsSinceEpoch));
            }
          },
          initialDateTime: DateTime.now(),
          minimumYear: 2000,
          maximumYear: 2025,
        ),
      );
    });
  }


  void dateDisplay(){

    DateTime _today = DateTime.now();
    if(_today.year == validDate.year && _today.month == validDate.month && _today.day == validDate.day){
      displayDate.value = '本日收益';
    } else {
      displayDate.value = '${validDate.year} / ${validDate.month} / ${validDate.day}';
    }
    // for(int i = 0; i < orderlist.length; i++){
    //   if(
    //     orderlist[i].orderDate.toDate().year == now.year &&
    //     orderlist[i].orderDate.toDate().month == now.month &&
    //     orderlist[i].orderDate.toDate().day == now.day
    //   ){
    //     turnover.value = turnover.value + orderlist[i].xtotalAmount;
    //   }
    // }
  }


}