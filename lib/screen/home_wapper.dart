// import 'package:asher_store_cms/constants.dart';
// import 'package:asher_store_cms/model/orderreceive_model.dart';
// import 'package:asher_store_cms/model/product_model.dart';
// import 'package:asher_store_cms/screen/banner/banner_listview.dart';
// import 'package:asher_store_cms/screen/category/catergory_listview.dart';
// import 'package:asher_store_cms/screen/coupon/coupon_listview.dart';
// import 'package:asher_store_cms/screen/member/member_listview.dart';
// import 'package:asher_store_cms/screen/order/order_itemviews.dart';
// import 'package:asher_store_cms/screen/order/order_listview.dart';
// import 'package:asher_store_cms/screen/order/order_details.dart';
// import 'package:asher_store_cms/screen/policy/private_policy.dart';
// import 'package:asher_store_cms/screen/policy/return_policy.dart';
// import 'package:asher_store_cms/screen/proudct/product_listview.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';

// class HomeWapper extends StatelessWidget {
//   const HomeWapper({ Key? key }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(backgroundDark),
//       appBar: _appbar(),
//       body: ListView(
//         shrinkWrap: true,
//         physics: const BouncingScrollPhysics(),
//         children: [
//           _customHeader(context),
//           _functionButton(context),
//           _orderListView(context),
//         ],
//       )
//     );
//   }

//   AppBar _appbar(){
//     return AppBar(
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       title: Row(
//         children: const [
//           Icon(
//             Icons.menu, 
//             color: Colors.white
//           ),
//           Spacer(),
//           Icon(
//             Icons.settings, 
//             color: Colors.white,
//           )
//         ],
//       )
//     );
//   }

//   Widget _customHeader(BuildContext context){

//     final orderReceiveModel = Provider.of<List<OrderReceiveModel>>(context);
    
//     double turnover = 0;
//     DateTime now = DateTime.now();
//     final formatter = NumberFormat("###,###,###,##0", "en");

//     for(int i = 0; i < orderReceiveModel.length; i++){
//       if(
//         orderReceiveModel[i].orderDate.toDate().year == now.year &&
//         orderReceiveModel[i].orderDate.toDate().month == now.month &&
//         orderReceiveModel[i].orderDate.toDate().day == now.day
//       ){
//         turnover = turnover + orderReceiveModel[i].xtotalAmount;
//       }
//     }

//     return SizedBox(
//       height: 100,
//       child: Center(
//         child: Column(
//           children: [
//             const Text(
//               '????????????',
//               style: TextStyle(color: Colors.greenAccent, fontSize: 18)
//             ),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'HKD\$${formatter.format(int.parse(turnover.toStringAsFixed(0)))}.',
//                   style: const TextStyle(fontSize: 30, color: Colors.greenAccent)
//                 ),
//                 Text(
//                   turnover.toStringAsFixed(2).substring(
//                     turnover.toStringAsFixed(2).length - 2, 
//                     turnover.toStringAsFixed(2).length
//                   ),
//                   style: const TextStyle(fontSize: 20, color: Colors.greenAccent)
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _functionButton(BuildContext context){

//     final _dbProcudtList = Provider.of<List<ProductModel>>(context);

//     var size = MediaQuery.of(context).size;
//     const double itemHeight = 250;
//     final double itemWidth = size.width / 2;

//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(primaryDark),
//         borderRadius: BorderRadius.circular(7)
//       ),
//       margin: const EdgeInsets.only(left: 20, right: 20),
//       padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
//       child: GridView(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 4,
//           crossAxisSpacing: 20,
//           mainAxisSpacing: 20,
//           childAspectRatio: (itemWidth / itemHeight)
//         ),
//         children: [
//           InkWell(
//             splashColor: Colors.transparent,
//             onTap: () => Get.to(const BannerListView()),
//             child: _functionButtonItemView(
//               const Icon(Icons.widgets, size: 30,), 
//               '????????????'
//             ),
//           ),
//           InkWell(
//             splashColor: Colors.transparent,
//             onTap: () => Get.to(ProductListView(productList: _dbProcudtList)),
//             child: _functionButtonItemView(
//               const Icon(Icons.widgets, size: 30,), 
//               '????????????'
//             ),
//           ),
//           InkWell(
//             splashColor: Colors.transparent,
//             onTap: () => Get.to(const CatergoryListView(selectOpen: false, selectedList: [])),
//             child: _functionButtonItemView(
//               const Icon(Icons.category_outlined, size: 30,), 
//               '????????????'
//             ),
//           ),
//           InkWell(
//             splashColor: Colors.transparent,
//             onTap: () => Get.to(const CouponListView()),
//             child: _functionButtonItemView(
//               const Icon(Icons.card_giftcard, size: 30,), 
//               '????????????'
//             ),
//           ),
//           InkWell(
//             splashColor: Colors.transparent,
//             onTap: () => Get.to(const OrderListView()),
//             child: _functionButtonItemView(
//               const Icon(Icons.inbox_rounded, size: 30,), 
//               '????????????'
//             ),
//           ),
//           InkWell(
//             splashColor: Colors.transparent,
//             onTap: (){},
//             child: _functionButtonItemView(
//               const Icon(Icons.autorenew, size: 30,), 
//               '????????????'
//             ),
//           ),
//           InkWell(
//             splashColor: Colors.transparent,
//             onTap: () => Get.to(const MemberListView()),
//             child: _functionButtonItemView(
//               const Icon(Icons.person, size: 30,), 
//               '????????????'
//             ),
//           ),
//           InkWell(
//             splashColor: Colors.transparent,
//             onTap: () => Get.to(const PrivatePolicy()),
//             child: _functionButtonItemView(
//               const Icon(Icons.admin_panel_settings_outlined, size: 30,), 
//               '????????????'
//             ),
//           ),
//           InkWell(
//             splashColor: Colors.transparent,
//             onTap: () => Get.to(const ReturnPolicy()),
//             child: _functionButtonItemView(
//               const Icon(Icons.admin_panel_settings_outlined, size: 30,), 
//               '????????????'
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _functionButtonItemView(Icon icon, String title){
//     return Column(
//       children: [
//         Expanded(
//           child: icon,
//         ),
//         Text(title)
//       ],
//     );
//   }

//   Widget _orderListView(BuildContext context){

//     final orderReceiveModel = Provider.of<List<OrderReceiveModel>>(context);

//     int _notCompleteCounter = 0;

//     // ignore: unnecessary_null_comparison
//     if(orderReceiveModel == null){
//       return Container();
//     } else {
//       for(int i = 0; i < orderReceiveModel.length; i++){
//         if(orderReceiveModel[i].isComplete == false){
//           _notCompleteCounter++;
//         }
//       }
//     }
    
//     return Padding(
//       padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             '????????????',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
//           ),
//           _notCompleteCounter == 0 ?  
//           const SizedBox(
//             height: 160,
//             child: Center(
//               child: Text(
//                 '??????????????????',
//                 style: TextStyle(color: Colors.grey),
//               ),
//             ),
//           ) :
//           ListView.builder(
//             shrinkWrap: true,
//             itemCount: orderReceiveModel.length,
//             physics: const NeverScrollableScrollPhysics(),
//             itemBuilder: (context, index){
//               return orderReceiveModel[index].isComplete == true ? Container() :
//               GestureDetector(
//                 onTap: (){
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => ReceiveDetails(
//                     reference: orderReceiveModel[index].ref, 
//                     docId: orderReceiveModel[index].docId,
//                     status: orderReceiveModel[index].isComplete
//                   )));
//                 },
//                 child: OrderItemView(orderReceiveModel: orderReceiveModel[index])
//               );
//             }
//           )
//         ],
//       ),
//     );
//   }

// }
