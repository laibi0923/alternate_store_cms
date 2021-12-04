import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alternate_store_cms/model/coupon_model.dart';

class CouponService{

  final FirebaseFirestore _mFirestore = FirebaseFirestore.instance;

  //  取得折扣代碼
  Stream<List<CouponModel>> get getCouponCode{
    return _mFirestore
      .collection('coupon').orderBy('CREATE_DATE', descending: true)
      .snapshots()
      .map((list) => 
      list.docs.map((doc) => 
      CouponModel.fromFirestore(doc.data(), doc.id)).toList());
  }

  //  新增折扣優惠
  addCoupon(CouponModel couponModel){
    _mFirestore.collection('coupon').doc().set({
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
    _mFirestore.collection('coupon').doc(docId).update({
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
    _mFirestore.collection('coupon').doc(docId).delete();
  }

}