import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final Timestamp createDate;
  final Timestamp lastModify;
  final bool inStock;
  final int sold;
  final int views;
  final String productNo;
  final String productName;
  final List imagePatch;
  final String description;
  final double price;
  final double discountPrice;
  final List size;
  final List color;
  final String tag;
  final List category;
  final bool refundable;


  ProductModel(this.createDate, this.lastModify, this.inStock, this.sold, this.views, this.productNo, this.productName, this.imagePatch, this.description, this.price, this.discountPrice, this.size, this.color, this.tag, this.category, this.refundable);
  
  factory ProductModel.initialData() {
    return ProductModel(
      Timestamp.now(), Timestamp.now(), false, 0, 0, '', '', [], '', 0.0, 0.0, [], [], '', [], false);
  }

  ProductModel.fromFirestore(Map<String, dynamic> dataMap) :
    createDate = dataMap['CREATE_DATE'],
    lastModify = dataMap['LAST_MODIFY'],
    inStock = dataMap['INSTOCK'],
    sold = dataMap['SOLD'],
    views = dataMap['VIEWS'],
    productNo = dataMap['PRODUCT_NO'],
    productName = dataMap['PRODUCT_NAME'],
    imagePatch = dataMap['IMAGE'],
    description = dataMap['DESCRIPTION'],
    price = double.parse(dataMap['PRICE'].toString()),
    discountPrice = double.parse(dataMap['DISCOUNT_PRICE'].toString()),
    size = dataMap['SIZE'],
    color = dataMap['COLOR'],
    tag = dataMap['TAG'],
    category = dataMap['CATEGORY'],
    refundable = dataMap['REFUND_ABLE'];

}
