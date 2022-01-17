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
    subAmount = double.parse(dataMap['SUB_AMOUNT'].toString()),
    shippingAmount = double.parse(dataMap['SHIPPING_FREE'].toString()),
    totalAmount = double.parse(dataMap['TOTAL_AMOUNT'].toString()),
    discountAmount = double.parse(dataMap['DISCOUNT_AMOUNT'].toString()),
    discountCode = dataMap['DISCOUNT_CODE'],
    receipientInfo = dataMap['RECIPIENT_INFO'],
    orderProduct = dataMap['ORDER_PRODUCT'],
    paymentMothed = dataMap['PAYMENT_METHOD'],
    docId = id;

    OrderModel.fromDocumentSnapshot(DocumentSnapshot dataMap, String id) :
      orderDate = dataMap['ORDER_DATE'],
      orderNumber = dataMap['ORDER_NUMBER'],
      subAmount = double.parse(dataMap['SUB_AMOUNT'].toString()),
      shippingAmount = double.parse(dataMap['SHIPPING_FREE'].toString()),
      totalAmount = double.parse(dataMap['TOTAL_AMOUNT'].toString()),
      discountAmount = double.parse(dataMap['DISCOUNT_AMOUNT'].toString()),
      discountCode = dataMap['DISCOUNT_CODE'],
      receipientInfo = dataMap['RECIPIENT_INFO'],
      orderProduct = dataMap['ORDER_PRODUCT'],
      paymentMothed = dataMap['PAYMENT_METHOD'],
      docId = id;
    
}

