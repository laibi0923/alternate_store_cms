import 'dart:convert';

class CartModel{
  final String productNo;
  final int size;
  final int color;

  CartModel(this.productNo, this.size, this.color);

  factory CartModel.initdata(){
    return CartModel('', 0, 0);
  }

  factory CartModel.fromjson(Map<String, dynamic> cartData){
    return CartModel(
      cartData['PRODUCTNO'], 
      cartData['SIZE'], 
      cartData['COLOR']
    );
  }

  static Map<String, dynamic> toMap(CartModel cartmodel) => {
    'PRODUCTNO': cartmodel.productNo,
    'SIZE': cartmodel.size,
    'COLOR': cartmodel.color,
  };

  static String encode(List<CartModel> cartmodel) => json.encode(
    cartmodel.map<Map<String, dynamic>>((item) => CartModel.toMap(item)).toList(),
  );

  static List<CartModel> decode(String cartmodel) {
    return cartmodel.isNotEmpty ? (json.decode(cartmodel) as List<dynamic>).map<CartModel>((item) => CartModel.fromjson(item)).toList() : [];
  }
  

}