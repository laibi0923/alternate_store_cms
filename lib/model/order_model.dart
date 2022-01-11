import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  Timestamp? orderDate;
  String? orderNumber;
  double? subAmount;
  double? shippingAmount;
  double? totalAmount;
  String? discountCode;
  double? discountAmount;
  Map<String, dynamic>? receipientInfo;
  List? orderProduct;
  String? paymentMothed;
  String? docId;

  OrderModel({this.orderDate, this.orderNumber, this.subAmount, this.shippingAmount, this.totalAmount, this.discountCode, this.discountAmount, this.receipientInfo, this.orderProduct, this.paymentMothed});
  
  OrderModel.fromFirestore(Map<String, dynamic> dataMap, String id) :
    orderDate = dataMap['ORDER_DATE'],
    orderNumber = dataMap['ORDER_NUMBER'],
    subAmount = dataMap['SUB_AMOUNT'],
    shippingAmount = dataMap['SHIPPING_FREE'],
    totalAmount = dataMap['TOTAL_AMOUNT'],
    discountAmount = dataMap['DISCOUNT_AMOUNT'],
    discountCode = dataMap['DISCOUNT_CODE'],
    receipientInfo = dataMap['RECIPIENT_INFO'],
    orderProduct = dataMap['ORDER_PRODUCT'],
    paymentMothed = dataMap['PAYMENT_METHOD'],
    docId = id;
}
