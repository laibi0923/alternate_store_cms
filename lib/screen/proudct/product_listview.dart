// // ignore_for_file: unnecessary_null_comparison
// import 'package:asher_store_cms/constants.dart';
// import 'package:asher_store_cms/currency_textview.dart';
// import 'package:asher_store_cms/model/category_model.dart';
// import 'package:asher_store_cms/model/product_model.dart';
// import 'package:asher_store_cms/screen/proudct/product_editor.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ProductListView extends StatefulWidget {
//   final List<ProductModel> productList;
//   const ProductListView({ Key? key, required this.productList }) : super(key: key);

//   @override
//   State<ProductListView> createState() => _ProductListViewState();
// }

// class _ProductListViewState extends State<ProductListView> {

//   final List<ProductModel> _searchList = [];
//   final TextEditingController _searchTextController = TextEditingController();
//   late int _searchResultCounter = 0;

//   void _searchProduct(String val, List<ProductModel> list){
//     setState(() {
//       _searchList.clear();
//       _searchResultCounter = 0;
//       if(val.isNotEmpty) {
//         for(int i = 0; i < list.length; i++){
//           if(
//             list[i].productName.toUpperCase().contains(val.toUpperCase()) ||
//             list[i].productNo.toUpperCase().contains(val.toUpperCase())
//           ){
//             _searchList.add(list[i]);
//             _searchResultCounter = _searchList.length;
//           } 
//         }
//       }  
//     });
//   }

//   @override
//   Widget build(BuildContext context) {

//     final _dbProductList = Provider.of<List<ProductModel>>(context);
//     final _categoryModel = Provider.of<List<CategoryModel>>(context);
    
//     return Scaffold(
//       backgroundColor: const Color(backgroundDark),
//       floatingActionButton: _buildFloatingActionButton(context),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       appBar: _buildSearchAppBar(context, _dbProductList),
//       body: Column(
//         children: [
//           _searchResultCounter == 0 ? Container() :
//           Padding(
//             padding: const EdgeInsets.only(top: 10, bottom: 10),
//             child: Text(
//               '共找到 $_searchResultCounter 筆相關資料',
//               style: const TextStyle(color: Colors.grey),
//             ),
//           ),
//           Expanded(
//             child: _searchTextController.text.isNotEmpty || _searchList.isNotEmpty ?
//             _productListView(_categoryModel, _searchList) :
//             _productListView(_categoryModel, _dbProductList)
//           )
//         ],
//       )
//     );
//   }

//   AppBar _buildSearchAppBar(BuildContext context, List<ProductModel> list){
//     return AppBar(
//       automaticallyImplyLeading: false,
//       elevation: 0,
//       title: Container(
//         decoration: BoxDecoration(
//           color: const Color(primaryDark),
//           borderRadius: BorderRadius.circular(7)
//         ),
//         child: Row(
//           children: [
//             IconButton(
//               onPressed: () => Navigator.pop(context), 
//               icon: const Icon(
//                 Icons.arrow_back, 
//                 size: 20,
//                 color: Colors.white,
//               )
//             ),
//             Expanded(
//               child: TextField(
//                 controller: _searchTextController,
//                 decoration: const InputDecoration(
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.all(0),
//                   isDense: true,
//                   hintText: '商品名稱 / 編號捜尋'
//                 ),
//                 onChanged: (val) => _searchProduct(val, list),
//               ),
//             ),
//             const Padding(
//               padding: EdgeInsets.only(right: 15),
//               child: Icon(
//                 Icons.search,
//                 color: Colors.white
//               )
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   FloatingActionButton _buildFloatingActionButton(BuildContext context){
//     return FloatingActionButton(
//       onPressed: () => 
//         Navigator.push(context, MaterialPageRoute(builder: (context) => ProductEditor(
//           editMode: false, 
//           productModel: ProductModel.initialData(),
//           categoryModel: const []
//           )
//         )
//       ),
//       child: const Icon(Icons.add, color: Colors.grey),
//       backgroundColor: const Color(primaryDark),
//       elevation: 0,
//     );
//   }

//   Widget _productListView(List<CategoryModel> categoryList, List<ProductModel> productList){

//     if(productList == null){
//       return const Center(
//         child: CircularProgressIndicator(color: Colors.grey),
//       );
//     }

//     if(productList.isEmpty){
//       return const Center(
//         child: Text(
//           '找不到捜尋結果',
//           style: TextStyle(color: Colors.grey),
//         ),
//       );
//     }

//     return ListView.builder(
//       physics: const BouncingScrollPhysics(),
//       padding: const EdgeInsets.only(bottom: 150),
//       itemCount: productList.length,
//       itemBuilder: (context, index){
//         return GestureDetector(
//           onTap: () async {
//             bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ProductEditor(
//               editMode: true, 
//               productModel: productList[index],
//               categoryModel: categoryList
//               ))
//             );

//             if(result == true){
//               _searchTextController.clear();
//               _searchList.clear();
//               _searchResultCounter = 0;
//             }

//           } ,
//           child: productListItem(context, productList[index])
//         );
//       }
//     );
//   }

//   Widget productListItem(BuildContext context, ProductModel productModel){
//     return Container(
//       height: 120,
//       width: MediaQuery.of(context).size.width,
//       padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(right: 20),
//             height: 100,
//             width: 100,
//             decoration: BoxDecoration(
//               color: const Color(primaryDark),
//               borderRadius: BorderRadius.circular(7),
//               image: DecorationImage(
//                 image: NetworkImage(productModel.imagePatch[0])
//               )
//             ),
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(productModel.productNo)
//                     ),
//                     productModel.inStock ? Container() :
//                     const Text(
//                       '已下架',
//                       style: TextStyle(color: Colors.redAccent),
//                     )
//                   ],
//                 ),
//                 Text(
//                   productModel.productName,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 Text('已售出 : ${productModel.sold}'),
//                 const Spacer(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     CurrencyTextView(
//                       value: productModel.price, 
//                       textStyle: productModel.discountPrice == 0 ? 
//                       const TextStyle() : 
//                       const TextStyle(decoration: TextDecoration.lineThrough)
//                     ),
//                     Container(width: 10,),
//                     productModel.discountPrice == 0 ? const Text('') :
//                     CurrencyTextView(
//                       value: productModel.discountPrice, 
//                       textStyle: const TextStyle(color: Colors.redAccent),
//                     ),
//                   ],
//                 )

//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }

// }
