import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:alternate_store_cms/model/product_model.dart';
import 'package:alternate_store_cms/randomstring_gender.dart';
import 'package:image_picker/image_picker.dart';

class ProductDatabase { 

  final CollectionReference _productRef = FirebaseFirestore.instance.collection('product');

  //  取得所有貨品
  Stream<List<ProductModel>> get showProduct {
    return _productRef.snapshots().map((list) => list.docs
      .map((doc) => ProductModel.fromFirestore(doc.data() as Map<String, dynamic>))
      .toList());
  }

  //  以 product ID 取得貨品
  Stream<List<ProductModel>> getProductFromID(String productNO) {
    return _productRef
      .where('PRODUCT_NO', isEqualTo: productNO)
      .snapshots()
      .map((list) => list.docs
      .map((doc) => ProductModel.fromFirestore(doc.data() as Map<String, dynamic>))
      .toList());
  }

  //  以用戶輸入字元取得貨品
  Stream<List<ProductModel>> searchProduct(String queryString){
    return _productRef
      //.where('PRODUCT_NAME', isEqualTo: queryString)
      .where('CATEGORY', arrayContains: queryString)
      .snapshots()
      .map((list) => list.docs
      .map((doc) => ProductModel.fromFirestore(doc.data() as Map<String, dynamic>))
      .toList());
  }

  //  上載貨品圖片
  Future<List> uploadProductImage(List<XFile> imageList) async {
    
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
  Future<List<Map<String, dynamic>>> uploadColorImage(List<Map<String, dynamic>> imageList) async {
    
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
  Future<void> createNewProduct(String productNumber, ProductModel productModel) async {

    try{
    DocumentReference xref = FirebaseFirestore.instance.collection('product').doc(productNumber);
    FirebaseFirestore.instance.runTransaction((transaction) async {
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
  Future<void> updateProduct(String productNumber, ProductModel productModel) async{
    try{
      DocumentReference xref = FirebaseFirestore.instance.collection('product').doc(productNumber);
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

  void removeExistingProductImage(String productNumber, List list){
    DocumentReference xref = FirebaseFirestore.instance.collection('product').doc(productNumber);
    xref.update({
      'IMAGE': list,
    });
  }

  void removeExistingColorImage(String productNumber, List list){
    DocumentReference xref = FirebaseFirestore.instance.collection('product').doc(productNumber);
    xref.update({
      'COLOR': list,
    });
  }

  void delProduct(String productNumber){
    DocumentReference xref = FirebaseFirestore.instance.collection('product').doc(productNumber);
    xref.delete();
  }

  //  賣出貨品計算 (CMS)
  soldProduct(String sku) async {
    _productRef.where('field', isEqualTo: sku).get().then((value) {

      String docid = value.docs[0].reference.id;

      int sold = value.docs[0]['SOLD'];
      int xSold = sold + 1;

      _productRef.doc(docid).update({
        'SOLD' : xSold
      });
    });
    
  }

}
