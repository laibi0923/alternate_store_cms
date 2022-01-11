// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:asher_store_cms/model/paymentmethod_model.dart';
// import 'package:asher_store_cms/randomstring_gender.dart';

// class PaymentMethodService{

//   final FirebaseFirestore _mFirestore = FirebaseFirestore.instance;

//   //  取得折扣代碼
//   Stream<List<PaymentMethodModel>> get getPaymentMethod{
//     return _mFirestore
//       .collection('payment_method').orderBy('CREATE_DATE', descending: true)
//       .snapshots()
//       .map((list) => 
//       list.docs.map((doc) => 
//       PaymentMethodModel.fromFirestore(doc.data(), doc.id)).toList());
//   }

//   Future<void> addPaymentMethod(PaymentMethodModel paymentMethodModel)  async {
//     return await _mFirestore.collection('payment_method').doc().set({
//       'CREATE_DATE' : paymentMethodModel.createDate,
//       'LAST_MODIFY' : paymentMethodModel.lastModify,
//       'HOLDER' : paymentMethodModel.holder,
//       'QRIMAGE' : paymentMethodModel.qrImage,
//       'NAME' : paymentMethodModel.methodName,
//       'REMARK' : paymentMethodModel.remark
//     });
//   }

//   Future<String> uploadQrImage(File file) async {
    
//     Reference storageRef = FirebaseStorage.instance.ref().child('payment_method/${randomStringGender(20, true).toUpperCase()}.jpg');
      
//     final UploadTask uploadTask = storageRef.putFile(file);

//     final TaskSnapshot downloadUrl = (await uploadTask);

//     final String url = await downloadUrl.ref.getDownloadURL();

//     return url;
//   }

// }