import 'dart:io';
import 'package:asher_store_cms/comfirmation_dialog.dart';
import 'package:asher_store_cms/controller/categorylistview_controller.dart';
import 'package:asher_store_cms/custom_snackbar.dart';
import 'package:asher_store_cms/inputvalue_dialog.dart';
import 'package:asher_store_cms/model/category_model.dart';
import 'package:asher_store_cms/model/product_model.dart';
import 'package:asher_store_cms/screen/category/catergory_listview.dart';
import 'package:asher_store_cms/service/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProductEditorController extends GetxController{

  RxBool inStock = false.obs;
  RxBool refundable = false.obs;
  RxList localImageList = RxList([]);
  RxList imagePatchList = [].obs;
  RxList sizeList = [].obs;
  RxList colorList = [].obs;
  RxList localColorList = [].obs;
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  Timestamp? createDate;
  Timestamp? lastModify;

  final TextEditingController productNumberController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController tagController = TextEditingController();

  @override
  void onClose() {
    super.onClose();
    productNumberController.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    discountController.dispose();
    tagController.dispose();
  }

  void getModelData(ProductModel productModel){

    createDate = productModel.createDate!;
    lastModify = productModel.lastModify!;
    imagePatchList.addAll(productModel.imagePatch!);
    productNumberController.text = productModel.productNo!;
    productNameController.text = productModel.productName!;
    descriptionController.text = productModel.description!;
    priceController.text = productModel.price!.toStringAsFixed(2);
    discountController.text = productModel.discountPrice!.toStringAsFixed(2);
    tagController.text = productModel.tag!.toString();
    inStock.value = productModel.inStock!;
    refundable.value = productModel.refundable!;
    sizeList.addAll(productModel.size!);
    colorList.addAll(productModel.color!);
      
    for(int i = 0; i < Get.find<CategoryListViewController>().categoryList.length; i++){
      for(int k = 0; k < productModel.category!.length; k++){
        if(productModel.category![k] == Get.find<CategoryListViewController>().categoryList[i].docId){
          categoryList.add(Get.find<CategoryListViewController>().categoryList[i]);
        }
      }
    }

  }
  
  void clearModelData(){
    localImageList.clear();
    productNumberController.clear();
    productNameController.clear();
    descriptionController.clear();
    priceController.clear();
    discountController.clear();
    tagController.clear();
    inStock.value = false;
    refundable.value = false;
    categoryList.clear();
    localImageList.call();
    colorList.clear();
    localColorList.clear();
    sizeList.clear();
  }

  Future<void> addLocalImage() async {
    try{
      List<XFile>? _tempImageList = (await ImagePicker().pickMultiImage());
      localImageList.addAll(_tempImageList!);
    } on PlatformException catch (e){
      // ignore: avoid_print
      print('Failed to pick image : $e');
    }
  }

  void removeLocalImage(int index){
    localImageList.removeAt(index);
  }

  Future<void> removeImage(int index) async {

    if(imagePatchList.length == 1){
        CustomSnackBar().show(Get.context!, '最少需要一張產品圖片');
        return ;
      }

      bool result = await showDialog(
        context: Get.context!, 
        builder: (BuildContext context){
          return comfirmationDialog(
            context, 
            '刪除', 
            '確定從資料庫中刪除此照片?', 
            '確定', 
            '取消'
          );
        }
      );

      if(result == true){
        imagePatchList.removeAt(index);
        FirebaseService().removeExistingProductImage(productNumberController.text, imagePatchList);  
      }
  }

  Future<void> addSize() async {
    String? result = await showDialog(
      context: Get.context!, 
      builder: (BuildContext context){
        return inputValueDialog(context, '輸入呎碼', 'eg : XL / XXL / 41...');
      }
    );
    if(result != null && result.isNotEmpty) {
      sizeList.add(result.toUpperCase().trim());
    }
  }

  void removeSize(int index){
    sizeList.removeAt(index);  
  }

  Future<void> addColor() async {
    
    File? imageTemporary;

    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null){
        return;
      } else {
        imageTemporary = File(image.path);
      }
    } on PlatformException catch (e){
      // ignore: avoid_print
      print('Failed to pick image : $e');
    }

    String? result = await showDialog(
      context: Get.context!, 
      builder: (BuildContext context){
        return inputValueDialog(context, '輸入顏色', 'eg : 白色 / 黑色...');
      }
    );

    if(result != null && result.isNotEmpty){
      localColorList.add({
        "COLOR_IMAGE" : imageTemporary,
        "COLOR_NAME" : result.toUpperCase().trim(),
      }); 
    }

  }

  void removeColor(int index){
    localColorList.removeAt(index);
  }

  Future<void> addCategory() async {

    List<CategoryModel> selectedList = await Get.to(() => CategoryListView(productCategoryList: categoryList));
    // ignore: unnecessary_null_comparison
    if(selectedList != null){
      categoryList.clear();
      categoryList.addAll(selectedList);
    } else {
      categoryList.clear();
    }

  }

  void removeCategory(index){
    categoryList.removeAt(index);
  }

  void toggleInStockStatus(){
    if(inStock.value == true){
      inStock.value = false;
    } else {
      inStock.value = true;
    }
  }

  void toggleRefundStatus(){
    if(refundable.value == true){
      refundable.value = false;
    } else {
      refundable.value = true;
    }
  }

  void saveProduct(){

    if(createDate != null) {
      if(localImageList.isEmpty && imagePatchList.isEmpty){
        CustomSnackBar().show(Get.context!, '最少一張產品圖片');
        return;
      }
    } else if(localImageList.isEmpty){
      CustomSnackBar().show(Get.context!, '最少一張產品圖片');
      return;
    }

    if(productNameController.text.isEmpty){
      CustomSnackBar().show(Get.context!, '請輸入產品名稱');
      return;
    }

    double _orginalPrice = 0.00;
    double _discountPrice = 0.00;

    _orginalPrice = double.parse(priceController.text.replaceAll(',', ''));
    _discountPrice = double.parse(discountController.text.replaceAll(',', ''));


    if(_orginalPrice == 0){
      CustomSnackBar().show(Get.context!, '請輸入產品價格');
      return;
    }

    if(_discountPrice >= _orginalPrice){
      CustomSnackBar().show(Get.context!, '特價價錢不能大於或等於原價格');
      return;
    }

    if(sizeList.isEmpty){
      CustomSnackBar().show(Get.context!, '最少輸入一隻呎碼');
      return;
    }
    
    if(createDate != null) {
      if(localColorList.isEmpty && colorList.isEmpty){
        CustomSnackBar().show(Get.context!, '最少輸入一隻顏色');
        return;
      }
    } else if(localColorList.isEmpty){
      CustomSnackBar().show(Get.context!, '最少輸入一隻顏色');
      return;
    }

    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) => showLoadingIndicator()
    );

    //  Rebuild Category Model
    List _tempCategoryList = [];
    for(int i = 0; i < categoryList.length; i++){
      _tempCategoryList.add(categoryList[i].docId);
    }

    if(createDate != null){
      updateProduct(_tempCategoryList);
    } else {
      createProduct(_tempCategoryList);
    }

  }
  
  Future<void> updateProduct(List categorylist) async {
    
    //  Create new product or Update existing product
    List _tempProductImageList = [];
    List _tempProductColorList = [];

    //  Upload product image  
    if(localImageList.isEmpty){
      _tempProductImageList = imagePatchList;
    } else {
      _tempProductImageList = await FirebaseService().uploadProductImage(localImageList).then((value) {
        return imagePatchList + value;
      });
    }

    //  Upload color image     
    if(localColorList.isEmpty){
      _tempProductColorList = colorList;
    } else {
      _tempProductColorList = await FirebaseService().uploadColorImage(localColorList).then((value) {
        return colorList + value;
      });
    }

    FirebaseService().updateProduct(
      ProductModel(
        createDate: createDate,
        lastModify: Timestamp.now(),
        imagePatch: _tempProductImageList,
        productNo: productNumberController.text,
        productName: productNameController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        discountPrice: double.parse(discountController.text),
        size: sizeList,
        color: _tempProductColorList,
        tag: tagController.text,
        category: categorylist,
        inStock: inStock.value,
        refundable: refundable.value,
        sold: 0,
        views: 0
      ),
    ).then((value) {
      Get.back();
      Get.back();
      CustomSnackBar().show(Get.context!, '更新完成');
    });
    
  }

  Future<void> createProduct(List categorylist) async {

    //  Upload product image  
    List _tempProductImageList = await FirebaseService().uploadProductImage(localImageList);
    //  Upload color image   
    List _tempProductColorList = await FirebaseService().uploadColorImage(localColorList);

    FirebaseService().createNewProduct(
      ProductModel(
        createDate: Timestamp.now(),
        lastModify: Timestamp.now(),
        imagePatch: _tempProductImageList,
        productNo: productNumberController.text,
        productName: productNameController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        discountPrice: double.parse(discountController.text),
        size: sizeList,
        color: _tempProductColorList,
        tag: tagController.text,
        category: categorylist,
        inStock: inStock.value,
        refundable: refundable.value,
        sold: 0,
        views: 0
      )
    ). then((value) {
        Get.back();
        Get.back();
      CustomSnackBar().show(Get.context!, '上載完成');
    });

  }

  Future<void> delProduct() async {
    bool result = await showDialog(
      context: Get.context!, 
      builder: (BuildContext context){
        return comfirmationDialog(
          context, 
          '刪除商品', 
          '一經刪除將無法復原，確定從資料庫中刪除此商品?', 
          '確定', 
          '取消'
        );
      }
    );

    if(result == true){
      Get.back();
      FirebaseService().delProduct(productNumberController.text);
    }

  }

  // Show Loading Screen
  Widget showLoadingIndicator() {
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
                '上載產品中...',
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
  }

}
