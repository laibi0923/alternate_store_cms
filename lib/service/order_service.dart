import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asher_store_cms/model/orderreceive_model.dart';

class OrderService{

  final FirebaseFirestore _mFirestore = FirebaseFirestore.instance;

  Stream <List<OrderReceiveModel>> get getOrder{
    return _mFirestore
      .collection('order')
      .orderBy('ORDER_DATE', descending: true)
      .snapshots()
      .map((list) => 
      list.docs.map((doc) => 
      OrderReceiveModel.fromFirestore(doc.data(), doc.id)).toList());
  }

  

}