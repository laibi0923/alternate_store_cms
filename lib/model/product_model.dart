import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  Timestamp? createDate;
  Timestamp? lastModify;
  bool? inStock;
  int? sold;
  int? views;
  String? productNo;
  String? productName;
  List? imagePatch;
  String? description;
  double? price;
  double? discountPrice;
  List? size;
  List? color;
  String? tag;
  List? category;
  bool? refundable;

  ProductModel(this.createDate, this.lastModify, this.inStock, this.sold, this.views, this.productNo, this.productName, this.imagePatch, this.description, this.price, this.discountPrice, this.size, this.color, this.tag, this.category, this.refundable);

  ProductModel.fromFirestore(Map<String, dynamic>? doc){
    createDate = doc?['CREATE_DATE'];
    lastModify = doc?['LAST_MODIFY'];
    inStock = doc?['INSTOCK'];
    sold = doc?['SOLD'];
    views = doc?['VIEWS'];
    productNo = doc?['PRODUCT_NO'];
    productName = doc?['PRODUCT_NAME'];
    imagePatch = doc?['IMAGE'];
    description = doc?['DESCRIPTION'];
    price = double.parse((doc?['PRICE']).toString());
    discountPrice = double.parse((doc?['DISCOUNT_PRICE']).toString());
    size = doc?['SIZE'];
    color = doc?['COLOR'];
    tag = doc?['TAG'];
    category = doc?['CATEGORY'];
    refundable = doc?['REFUND_ABLE'];
  }
    

}
