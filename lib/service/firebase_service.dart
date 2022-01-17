import 'dart:io';
import 'dart:math';
import 'package:asher_store_cms/controller/auth_controller.dart';
import 'package:asher_store_cms/model/banner_model.dart';
import 'package:asher_store_cms/model/category_model.dart';
import 'package:asher_store_cms/model/coupon_model.dart';
import 'package:asher_store_cms/model/orderreceive_model.dart';
import 'package:asher_store_cms/model/privatepolicy_model.dart';
import 'package:asher_store_cms/model/product_model.dart';
import 'package:asher_store_cms/model/refund_model.dart';
import 'package:asher_store_cms/model/refundpolicy_model.dart';
import 'package:asher_store_cms/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class FirebaseService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final uid = Get.find<AuthController>().auth.currentUser?.uid;
  
  //  取得用戶資料
  Stream<UserModel> getUserInfo() {
    // ignore: avoid_print
    print("取得用戶資料 $uid");
    return _firestore.collection('user').doc(uid).snapshots().map((list){
      return UserModel.fromFirestore(list.data());
    });
  }

  //  取得所有會員資料
  Stream<List<UserModel>> get getAllMember {
    return _firestore.collection('user').snapshots().map((list) => list.docs
      .map((doc) => UserModel.fromFirestore(doc.data()))
      .toList());
  }

  //  更新用戶資料
  // Future updateUserInfo(UserModel userModel) {
  //   return _firestore.collection('user').doc(uid).update({
  //     'USERNAME': userModel.name,
  //     'PHONE': userModel.phone,
  //     'RECIPIENT_NAME': userModel.recipientName,
  //     'UNIT_AND_BUILDING': userModel.unitAndBuilding,
  //     'ESTATE': userModel.estate,
  //     'DISTRICT': userModel.district,
  //   });
  // }

  //  更新用戶頭像連結
  // Future<void> setUserPhoto(String url) async {
  //   return _firestore.collection('user').doc(uid).update({
  //     'PHOTO' : url
  //   });
  // }

  //  上存圖片
  // Future<String> uploadImage(String path, File file) async {
  //   Reference storageRef = FirebaseStorage.instance.ref().child(path);
  //   final UploadTask uploadTask = storageRef.putFile(file);
  //   final TaskSnapshot downloadUrl = (await uploadTask);
  //   final String url = await downloadUrl.ref.getDownloadURL();
  //   return url;
  // }
  


  //  隨機生成英文數字    
  String randomStringGender(int chart, bool isString){
    var _chars = '';
    if(isString){
      _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    } else {
      _chars = '1234567890';
    }
    
    Random _rnd = Random();
    String getRandomString(int length) => String.fromCharCodes(
      Iterable.generate(length, (_) => _chars.codeUnitAt(
        _rnd.nextInt(_chars.length))
      )
    );

    return getRandomString(chart);
  }

  // ==========================================================================

  //  取得所有貨品
  Stream<List<ProductModel>> get getProduct {
    return _firestore.collection('product')
      // .where('INSTOCK', isEqualTo: true)
      .snapshots()
      .map((list) => list.docs
      .map((doc) => ProductModel.fromFirestore(doc.data()))
      .toList());
  }

  //  上載貨品圖片
  Future<List> uploadProductImage(List imageList) async {
    
    List imageUrl = [];

    for(int i = 0; i < imageList.length; i++){

      Reference storageRef = FirebaseStorage.instance.ref().child('product/${randomStringGender(20, true).toUpperCase()}.jpg');
      
      final UploadTask uploadTask = storageRef.putFile(File(imageList[i].path));

      final TaskSnapshot downloadUrl = (await uploadTask);

      final String url = await downloadUrl.ref.getDownloadURL();

      imageUrl.add(url);
    }

    return imageUrl;
   
  }

  //  上載貨品顏色
  Future<List<Map<String, dynamic>>> uploadColorImage(List imageList) async {
    
    List<Map<String, dynamic>> colorUrlList = [];

    for(int i = 0; i < imageList.length; i++){

      Reference storageRef = FirebaseStorage.instance.ref().child('product/${randomStringGender(20, true).toUpperCase()}');
      
      final UploadTask uploadTask = storageRef.putFile(imageList[i]["COLOR_IMAGE"]);

      final TaskSnapshot downloadUrl = (await uploadTask);

      final String url = await downloadUrl.ref.getDownloadURL();

      colorUrlList.add({
        "COLOR_NAME" : imageList[i]['COLOR_NAME'],
        "COLOR_IMAGE" : url
      });

    }

    return colorUrlList;
   
  }

  //  上載貨品
  Future<void> createNewProduct(ProductModel productModel) async {

    try{
    DocumentReference xref = _firestore.collection('product').doc(productModel.productNo);
    _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(xref);
        if (!snapshot.exists) {
          xref.set({
            'CREATE_DATE': productModel.createDate,
            'LAST_MODIFY': productModel.lastModify,
            'INSTOCK': productModel.inStock,
            'SOLD': productModel.sold,
            'VIEW': productModel.views,
            'PRODUCT_NO': productModel.productNo,
            'PRODUCT_NAME': productModel.productName,
            'IMAGE': productModel.imagePatch,
            'DESCRIPTION': productModel.description,
            'PRICE': productModel.price,
            'DISCOUNT_PRICE': productModel.discountPrice,
            'SIZE': productModel.size,
            'COLOR': productModel.color,
            'TAG': productModel.tag,
            'CATEGORY': productModel.category,
            'REFUND_ABLE': productModel.refundable
          });
        }
      });
    } catch (e){
      // ignore: avoid_print
      print(e);
    }
  
  }
  
  //  更新貨品
  Future<void> updateProduct(ProductModel productModel) async{
    try{
      DocumentReference xref = _firestore.collection('product').doc(productModel.productNo);
      xref.update({
        'CREATE_DATE': productModel.createDate,
        'LAST_MODIFY': productModel.lastModify,
        'INSTOCK': productModel.inStock,
        'SOLD': productModel.sold,
        'VIEW': productModel.views,
        'PRODUCT_NO': productModel.productNo,
        'PRODUCT_NAME': productModel.productName,
        'IMAGE': productModel.imagePatch,
        'DESCRIPTION': productModel.description,
        'PRICE': productModel.price,
        'DISCOUNT_PRICE': productModel.discountPrice,
        'SIZE': productModel.size,
        'COLOR': productModel.color,
        'TAG': productModel.tag,
        'CATEGORY': productModel.category,
        'REFUND_ABLE': productModel.refundable
      });
    } catch (e){
      // ignore: avoid_print
      print(e);
    }
  }
  
  //  剷除商品
  void delProduct(String productNumber){
    DocumentReference xref = _firestore.collection('product').doc(productNumber);
    xref.delete();
  }

  //  剷除現有商品圖片
  void removeExistingProductImage(String productNumber, List list){
    DocumentReference xref = _firestore.collection('product').doc(productNumber);
    xref.update({
      'IMAGE': list,
    });
  }

  //  賣出貨品計算 (CMS)
  void soldProductCounter(String sku) async {
    _firestore.collection('product')
    .where('PRODUCT_NO', isEqualTo: sku).get().then((value) {
      int sold = value.docs[0]['SOLD'];
      int xSold = sold + 1;
      _firestore.collection('product').doc(sku).update({
        'SOLD' : xSold
      });
    });
  }

  // ==========================================================================

  //  取得 Banner
  Stream<List<BannerModel>> get getBanner {
    return _firestore.collection('banner')
      .snapshots()
      .map((list) => list.docs
      .map((doc) => BannerModel.fromFirestore(doc.data(), doc.id))
      .toList());
  }

  //  上載 Banner 圖片
  Future<String> uploadBannerImage(File imageList) async {
    Reference storageRef = FirebaseStorage.instance.ref().child('banner/${randomStringGender(20, true).toUpperCase()}.jpg');
    final UploadTask uploadTask = storageRef.putFile(File(imageList.path));
    final TaskSnapshot downloadUrl = (await uploadTask);
    final String url = await downloadUrl.ref.getDownloadURL();
    return url;
  }

  //  上載 Banner 
  Future<void> createBanner(String url, String queryString) async{
    try{
    DocumentReference xref = FirebaseFirestore.instance.collection('banner').doc();
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(xref);
        if (!snapshot.exists) {
          xref.set({
            'CREATE_DATE': Timestamp.now(),
            'URL': url,
            'KEY': queryString
          });
        }
      });
    } catch (e){
      // ignore: avoid_print
      print(e);
    }
  }

  //  更新封面
  Future<void> updateBanner(String docId, String queryString, String imagePatch) async {
    DocumentReference xref = FirebaseFirestore.instance.collection('banner').doc(docId);
    xref.update({
      'KEY' : queryString,
      'URL' : imagePatch
    });
  }

  //  剷除封面
  void removeBanner(String docId){
    DocumentReference xref = FirebaseFirestore.instance.collection('banner').doc(docId);
    xref.delete();
  }

  // ==========================================================================

  //  取得所有分類
  Stream<List<CategoryModel>> get getCategory {
    return _firestore.collection('category')
      .orderBy('CREATE_DATE' , descending: false)  
      .snapshots()
      .map((list) => list.docs
      .map((doc) => CategoryModel.fromFirestore(doc.data(), doc.id))
      .toList());
  }

  //  新增
  void addCategory(CategoryModel categoryModel){
    DocumentReference docRef = _firestore.collection('category').doc();
    FirebaseFirestore.instance.runTransaction((transaction) async {
      //DocumentSnapshot snapshot = await transaction.get(docRef);
      docRef.set({
        'CREATE_DATE' : categoryModel.createDate,
        'NAME' : categoryModel.name,
        'QUICK_SEARCH' : categoryModel.quickSearch
      });
    });
  }

  //  刪除
  void delCategory(String docId){
    _firestore.collection('category').doc(docId).delete();
  }

  //  設定為快速預覽
  void setQuickSearch (String docId, bool isSeted){ 
    if(isSeted == true){
      _firestore.collection('category').doc(docId).update({
        'QUICK_SEARCH' : false
      });
    } else {
      _firestore.collection('category').doc(docId).update({
        'QUICK_SEARCH' : true
      });
    }
  }

  // ==========================================================================

  //  取得折扣代碼
  Stream<List<CouponModel>> get getCouponCode{
    return _firestore.collection('coupon')
      .snapshots()
      .map((list) => 
      list.docs.map((doc) => 
      CouponModel.fromFirestore(doc.data(), doc.id)).toList());
  }

  //  新增折扣優惠
  addCoupon(CouponModel couponModel){
    _firestore.collection('coupon').doc().set({
      'CREATE_DATE' : couponModel.createDate,
      'CODE' : couponModel.couponCode,
      'DISCOUNT_AMOUNT' : couponModel.discountAmount,
      'PERCENTAGE' : couponModel.percentage,
      'REMARK' : couponModel.remark,
      'UNLIMITED' : couponModel.unLimited,
      'VALID_DATE' : couponModel.validDate
    });
  }

  //  更新折扣優惠
  updateCoupon(String docId, CouponModel couponModel){
    _firestore.collection('coupon').doc(docId).update({
      'CREATE_DATE' : couponModel.createDate,
      'CODE' : couponModel.couponCode,
      'DISCOUNT_AMOUNT' : couponModel.discountAmount,
      'PERCENTAGE' : couponModel.percentage,
      'REMARK' : couponModel.remark,
      'UNLIMITED' : couponModel.unLimited,
      'VALID_DATE' : couponModel.validDate
    });
  }

  //  剷除折扣優惠
  delCoupon(String docId){
    _firestore.collection('coupon').doc(docId).delete();
  }

  // ==========================================================================


  Stream <List<OrderReceiveModel>> get getOrder{
    return _firestore
      .collection('order')
      .orderBy('ORDER_DATE', descending: true)
      .snapshots()
      .map((list) => 
      list.docs.map((doc) => 
      OrderReceiveModel.fromFirestore(doc.data(), doc.id)).toList());
  }
  
  //  用戶下單
  // Future takeOrder(OrderModel orderModel) async{

  //   try{
  //     DocumentReference xRef = FirebaseFirestore.instance.collection('user').doc(uid).collection('order').doc();
  //     FirebaseFirestore.instance.runTransaction((transaction) async {
  //       DocumentSnapshot snapshot = await transaction.get(xRef);
  //       if(!snapshot.exists){
  //         xRef.set({
  //           'ORDER_DATE' : orderModel.orderDate,
  //           'ORDER_NUMBER' : orderModel.orderNumber,
  //           'DISCOUNT_CODE' : orderModel.discountCode,
  //           'DISCOUNT_AMOUNT' : orderModel.discountAmount,
  //           'SUB_AMOUNT' : orderModel.subAmount,
  //           'SHIPPING_FREE' : orderModel.shippingAmount,
  //           'TOTAL_AMOUNT' : orderModel.totalAmount,
  //           'RECIPIENT_INFO' : orderModel.receipientInfo,
  //           'ORDER_PRODUCT' : orderModel.orderProduct,
  //           'PAYMENT_METHOD' : orderModel.paymentMothed
  //         });
  //       }
  //     });

  //     DocumentReference zRef = FirebaseFirestore.instance.collection('order').doc();
  //     FirebaseFirestore.instance.runTransaction((transaction) async {
  //       DocumentSnapshot snapshot = await transaction.get(zRef);
  //       if(!snapshot.exists){
  //         zRef.set({
  //           'ORDER_DATE' : orderModel.orderDate,
  //           'ORDER_NUMBER' : orderModel.orderNumber,
  //           'REF' : xRef,
  //           'AMOUNT' : orderModel.totalAmount,
  //           'ISCOMPLETE' : false,
  //         });
  //       }
  //     });
      
  //   }catch(e){
  //     // ignore: avoid_print
  //     print(e);
  //   }
  // }
  // ==========================================================================

   //  
  Stream <List<RefundModel>> get getRefundList{
    return _firestore
      .collection('refund')
      .orderBy('CREATE_DATE', descending: true)
      .snapshots()
      .map((list) => 
      list.docs.map((doc) => 
      RefundModel.fromFirestore(doc.data(), doc.id)).toList());
  }

  void refundApproval(String docId, DocumentReference docRef, List productList){

  //
  _firestore.collection('refund').doc(docId).update({
    'ISCOMPLETED' : true
  });
  
  //dwdw
  docRef.update({
    'ORDER_PRODUCT' : productList,
  });

}

  // ==========================================================================

  //  取得用戶政策
  Stream<PrivatePolicyModel> get getPrivatePolicyContent{
    return _firestore
    .collection('policy')
    .doc('private_policy')
    .snapshots()
    .map((list) => PrivatePolicyModel.fromFirestore(list.data()!));
  }

  void updatePrivatePolicy(String content){
    _firestore.collection('policy').doc('private_policy').set({
      'LAST_MODIFY' : Timestamp.now(),
      'CONTENT' : content
    });
  }

  // ==========================================================================

  //  取得退貨政策
  Stream<RefundPolicyModel> get getRefundPolicyContent{
    return _firestore
    .collection('policy')
    .doc('return_policy')
    .snapshots()
    .map((list) => RefundPolicyModel.fromFirestore(list.data()!));
  }

  void updateReturnPolicy(String content){
    _firestore.collection('policy').doc('return_policy').set({
      'LAST_MODIFY' : Timestamp.now(),
      'CONTENT' : content
    });
  }

  // ==========================================================================
  



  //  用戶退貨
  Future makeRefund(RefundModel refundModel, String docid, List? productList) async{

    try{

      //  於 Order Histoty 修改 RefundStatus
      DocumentReference xRef = FirebaseFirestore.instance.collection('user').doc(uid).collection('order').doc(docid);
      FirebaseFirestore.instance.runTransaction((transaction) async {
        xRef.update({
          'ORDER_PRODUCT' : productList,
        });
      });


      //  通知後台申請退款
      DocumentReference zRef = FirebaseFirestore.instance.collection('refund').doc();
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(zRef);
        if(!snapshot.exists){
          zRef.set({
            'CREATE_DATE' : refundModel.createDate,
            'REF' : xRef,
          });
        }
      });
      
    }catch(e){
      // ignore: avoid_print
      print(e);
    }
  }

}