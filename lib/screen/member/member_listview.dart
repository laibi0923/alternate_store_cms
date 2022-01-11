// import 'package:asher_store_cms/constants.dart';
// // ignore: import_of_legacy_library_into_null_safe
// import 'package:asher_store_cms/model/user_model.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class MemberListView extends StatelessWidget {
//   const MemberListView({ Key? key }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {

//     final _userModel = Provider.of<List<UserModel>>(context);

//     return Scaffold(
//       backgroundColor: const Color(backgroundDark),
//       appBar: _buildSearchAppBar(context),
//       // ignore: unnecessary_null_comparison
//       body: _userModel == null ? Container() :
//       ListView.builder(
//         physics: const BouncingScrollPhysics(),
//         padding: const EdgeInsets.only(left: 20, right: 20, bottom: 150),
//         itemCount: _userModel.length,
//         itemBuilder: (context, index){
//           return _memberItemView(_userModel[index]);
//         }
//       ),
//     );
//   }

//   AppBar _buildSearchAppBar(BuildContext context){
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
//                 decoration: const InputDecoration(
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.all(0),
//                   isDense: true,
//                   hintText: '會員捜尋'
//                 ),
//                 onChanged: (val){},
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

//   Widget _memberItemView(UserModel userModel){
//     return Container(
//       height: 80,
//       margin: const EdgeInsets.only(top: 10, bottom: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 80,
//             height: 80,
//             margin: const EdgeInsets.only(right: 20),
//             child: ClipRRect(borderRadius: BorderRadius.circular(999),
//               child: userModel.userPhoto == null ? 
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: const BoxDecoration(
//                   color: Color(primaryDark),
//                 ),
//                 child: Image.asset(
//                   'lib/assets/icon/ic_person.png', 
//                   color: Colors.greenAccent
//                 )
//               ) :
//               CachedNetworkImage(
//                 imageUrl: userModel.userPhoto,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   userModel.uid.toUpperCase(),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 Text(
//                   "Email : ${userModel.email}",
//                 ),
//                 const Spacer(),
//                 Text(
//                   "用戶名稱 : ${userModel.name}",
//                   style: const TextStyle(color: Colors.grey)
//                 ),
//                 Text(
//                   "聯絡電話 : ${userModel.contactNo}",
//                   style: const TextStyle(color: Colors.grey)
//                 ),
//               ],
//             )
//           )
//         ],
//       ),
//     );
//   }


// }