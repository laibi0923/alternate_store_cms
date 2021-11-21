import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderReceiveModel{
  final Timestamp orderDate;
  final String orderNumber;
  final DocumentReference ref;
  final bool isComplete;
  final double xtotalAmount;
  final String docId;

  OrderReceiveModel(this.orderDate, this.orderNumber, this.ref, this.isComplete, this.xtotalAmount, this.docId);

  
  factory OrderReceiveModel.initialData(){
    return OrderReceiveModel(Timestamp.now(), '', FirebaseFirestore.instance.collection('user').doc() , false, 0, '');
  }

  OrderReceiveModel.fromFirestore(Map<String, dynamic> dataMap, String id) :
    orderDate = dataMap['ORDER_DATE'],
    orderNumber= dataMap['ORDER_NUMBER'],
    ref = dataMap['REF'],
    isComplete = dataMap['ISCOMPLETE'],
    xtotalAmount = double.parse(dataMap['AMOUNT'].toString()),
    docId = id;
    
}