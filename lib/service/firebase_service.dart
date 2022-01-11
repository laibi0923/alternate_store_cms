import 'dart:io';
import 'dart:math';
import 'package:asher_store_cms/controller/auth_controller.dart';
import 'package:asher_store_cms/model/banner_model.dart';
import 'package:asher_store_cms/model/category_model.dart';
import 'package:asher_store_cms/model/coupon_model.dart';
import 'package:asher_store_cms/model/order_model.dart';
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
    print("取得用戶資料 $uid");
    return _firestore.collection('user').doc(uid).snapshots().map((list){
      return UserModel.fromFirestore(list.data());
    });
  }

  //  更新用戶資料
  Future updateUserInfo(UserModel userModel) {
    return _firestore.collection('user').doc(uid).update({
      'USERNAME': userModel.name,
      'PHONE': userModel.phone,
      'RECIPIENT_NAME': userModel.recipientName,
      'UNIT_AND_BUILDING': userModel.unitAndBuilding,
      'ESTATE': userModel.estate,
      'DISTRICT': userModel.district,
    });
  }

  //  更新用戶頭像連結
  Future<void> setUserPhoto(String url) async {
    return _firestore.collection('user').doc(uid).update({
      'PHOTO' : url
    });
  }

  //  上存圖片
  Future<String> uploadImage(String path, File file) async {
    Reference storageRef = FirebaseStorage.instance.ref().child(path);
    final UploadTask uploadTask = storageRef.putFile(file);
    final TaskSnapshot downloadUrl = (await uploadTask);
    final String url = await downloadUrl.ref.getDownloadURL();
    return url;
  }
  


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


  //  取得所有貨品
  Stream<List<ProductModel>> get getProduct {
    return _firestore.collection('product')
      .where('INSTOCK', isEqualTo: true)
      .snapshots()
      .map((list) => list.docs
      .map((doc) => ProductModel.fromFirestore(doc.data()))
      .toList());
  }

  //  取得主頁 Promotion Banner
  Stream<List<BannerModel>> get getBanner {
    return _firestore.collection('banner')
      .snapshots()
      .map((list) => list.docs
      .map((doc) => BannerModel.fromFirestore(doc.data(), doc.id))
      .toList());
  }

  //  取得所有分類
  Stream<List<CategoryModel>> get getCategory {
    return _firestore.collection('category')
      .orderBy('CREATE_DATE' , descending: false)  
      .snapshots()
      .map((list) => list.docs
      .map((doc) => CategoryModel.fromFirestore(doc.data()))
      .toList());
  }

  //  取得折扣代碼
  Stream<List<CouponModel>> get getCouponCode{
    return _firestore.collection('coupon')
      .snapshots()
      .map((list) => 
      list.docs.map((doc) => 
      CouponModel.fromFirestore(doc.data())).toList());
  }


  //  取得用戶過往下單紀錄
  Stream<List<OrderModel>> get orderHistory {
    return _firestore
    .collection('user')
    .doc(uid)
    .collection('order').orderBy('ORDER_DATE', descending: true)
    .snapshots()
    .map((list) => list.docs.map((doc) => OrderModel.fromFirestore(doc.data(), doc.id)).toList());  
  }
  
  //  用戶下單
  Future takeOrder(OrderModel orderModel) async{

    try{
      DocumentReference xRef = FirebaseFirestore.instance.collection('user').doc(uid).collection('order').doc();
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(xRef);
        if(!snapshot.exists){
          xRef.set({
            'ORDER_DATE' : orderModel.orderDate,
            'ORDER_NUMBER' : orderModel.orderNumber,
            'DISCOUNT_CODE' : orderModel.discountCode,
            'DISCOUNT_AMOUNT' : orderModel.discountAmount,
            'SUB_AMOUNT' : orderModel.subAmount,
            'SHIPPING_FREE' : orderModel.shippingAmount,
            'TOTAL_AMOUNT' : orderModel.totalAmount,
            'RECIPIENT_INFO' : orderModel.receipientInfo,
            'ORDER_PRODUCT' : orderModel.orderProduct,
            'PAYMENT_METHOD' : orderModel.paymentMothed
          });
        }
      });

      DocumentReference zRef = FirebaseFirestore.instance.collection('order').doc();
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(zRef);
        if(!snapshot.exists){
          zRef.set({
            'ORDER_DATE' : orderModel.orderDate,
            'ORDER_NUMBER' : orderModel.orderNumber,
            'REF' : xRef,
            'AMOUNT' : orderModel.totalAmount,
            'ISCOMPLETE' : false,
          });
        }
      });
      
    }catch(e){
      // ignore: avoid_print
      print(e);
    }
  }

  //  取得用戶政策
  Stream<PrivatePolicyModel> get getPrivatePolicyContent{
    return _firestore
    .collection('policy')
    .doc('private_policy')
    .snapshots()
    .map((list) => PrivatePolicyModel.fromFirestore(list.data()!));
  }

  //  取得退貨政策
  Stream<RefundPolicyModel> get getReturnPolicyContent{
    return _firestore
    .collection('policy')
    .doc('return_policy')
    .snapshots()
    .map((list) => RefundPolicyModel.fromFirestore(list.data()!));
  }

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