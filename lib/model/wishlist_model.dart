import 'dart:convert';

class WishListModel{
  final String productNo;

  WishListModel(this.productNo);

  factory WishListModel.initdata(){
    return WishListModel('');
  }

  factory WishListModel.fromjson(Map<String, dynamic> wishlistData){
    return WishListModel(
      wishlistData['PRODUCTNO'], 
    );
  }

  static Map<String, dynamic> toMap(WishListModel wishlistModel) => {
    'PRODUCTNO': wishlistModel.productNo,
  };

  static String encode(List<WishListModel> wishlistModel) => json.encode(
    wishlistModel.map<Map<String, dynamic>>((item) => WishListModel.toMap(item)).toList(),
  );

  static List<WishListModel> decode(String wishlistmodel) {
    return wishlistmodel.isNotEmpty ? (json.decode(wishlistmodel) as List<dynamic>).map<WishListModel>((item) => WishListModel.fromjson(item)).toList() : [];
  }
  

}