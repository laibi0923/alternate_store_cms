// import 'dart:io';
// import 'package:asher_store_cms/comfirmation_dialog.dart';
// import 'package:asher_store_cms/constants.dart';
// import 'package:asher_store_cms/custom_cachednetworkimage.dart';
// import 'package:asher_store_cms/custom_snackbar.dart';
// import 'package:asher_store_cms/customize_textfield.dart';
// import 'package:asher_store_cms/model/banner_model.dart';
// import 'package:asher_store_cms/service/banner_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';

// class BannerEditor extends StatefulWidget {
//   final bool editMode;
//   final BannerModel bannerModel;
//   const BannerEditor({ Key? key, required this.bannerModel, required this.editMode }) : super(key: key);
//   @override
//   State<BannerEditor> createState() => _BannerEditorState();
// }

// class _BannerEditorState extends State<BannerEditor> {

//   final TextEditingController _searchKeyTextController = TextEditingController();
//   late String imagePatch = '';

//   //  Show Loading Screen
//   void showLoadingIndicator() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return WillPopScope(
//           onWillPop: () async =>  false,
//           child: AlertDialog(
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(8.0))
//             ),
//             backgroundColor: Colors.black87,
//             content: Container(
//               padding: const EdgeInsets.all(16),
//               color: Colors.black.withOpacity(0.8),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.min,
//                 children: const [
                  
//                   Padding(
//                     child: SizedBox(
//                       width: 32,
//                       height: 32,
//                       child: CircularProgressIndicator(strokeWidth: 3, color: Colors.grey),
//                     ),
//                     padding: EdgeInsets.only(bottom: 16)
//                   ),

//                   Padding(
//                     child: Text(
//                       '請稍等',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     padding: EdgeInsets.only(bottom: 4)
//                   ),


//                   Text(
//                     '上載中...',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 14
//                     ),
//                     textAlign: TextAlign.center,
//                   ),

//                 ],
//               ),
//             )
//           ),
//         );
//       },
//     );
//   }

//   //  Client choose Image
//   Future<void> _selectImage() async {

//     XFile xfile;

//     try {
//       xfile = (await ImagePicker().pickImage(source: ImageSource.gallery))!; 

//       if(xfile.path.isNotEmpty){
//         setState(() {
//           imagePatch = xfile.path;
//         });
//       }

//     } on PlatformException catch(e) {
//       // ignore: avoid_print
//       print('Failed to pick image : $e');
//     }
    
//   }

//   //  Upload Banner
//   Future<void> _uploadBanner(String queryString, String imagePatch) async {

//     if(queryString.isEmpty){
//       CustomSnackBar().show(context, '請輸入關鍵字');
//       return;
//     }

//     if(imagePatch.isEmpty && widget.editMode == false){
//       CustomSnackBar().show(context, '請選擇圖片');
//       return;
//     }

//     showLoadingIndicator();

//     if(widget.editMode == true){

//       if(imagePatch.isEmpty){
//         BannerService().updateBanner(widget.bannerModel.docId, queryString, widget.bannerModel.uri).then((value){
//           Navigator.pop(context);
//           Navigator.pop(context);
//         });
//       } else {
//         BannerService().uploadImage(File(imagePatch)).then((url) {
//           BannerService().updateBanner(
//             imagePatch.isEmpty ? widget.bannerModel.uri : widget.bannerModel.docId, 
//             queryString, 
//             url
//           ).then((value){
//             Navigator.pop(context);
//             Navigator.pop(context);
//           });
//         });
//       }

//     } else {
//       BannerService().uploadImage(File(imagePatch)).then((url) {
//         BannerService().uploadBanner(url, queryString);
//       }).then((value) {
//         Navigator.pop(context);
//         Navigator.pop(context);
//       });
//     }

    

//   }

//   //  Update Banner
//   void updateBanner(String docId, String querySyting, String imagePatch){
//     BannerService().updateBanner(docId, _searchKeyTextController.text, imagePatch);
//   }

//   //  Remove Banner
//   Future<void> _removeBanner(String docId) async {
//     bool result = await showDialog(
//       context: context, 
//       builder: (BuildContext context){
//         return comfirmationDialog(
//           context, 
//           '刪除', 
//           '一經刪除將無法復原，確定從資料庫中刪除?', 
//           '確定', 
//           '取消'
//         );
//       }
//     );

//     if(result == true){
//       setState(() {
//         Navigator.pop(context);
//         BannerService().removeBanner(docId);
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _searchKeyTextController.text = widget.bannerModel.quetyString;
//   }
  
//   @override
//   void dispose() {
//     super.dispose();
//     _searchKeyTextController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(backgroundDark),
//       body: ListView(
//         padding: const EdgeInsets.only(left: 20, right: 20, top: 80, bottom: 30),
//         children: [
      
//           Row(
//             children: [
//               widget.editMode == false ? const Spacer() : Container(),
//               widget.editMode == false ? Container() : 
//               Expanded(
//                 child: Text('建立日期 : ${DateFormat('yyyy/MM/dd  kk:mm').format(DateTime.fromMicrosecondsSinceEpoch(widget.bannerModel.createDate.microsecondsSinceEpoch))}')
//               ),
//               IconButton(
//                 onPressed: () => Navigator.pop(context), 
//                 icon: const Icon(Icons.close)
//               )
//             ],
//           ),

//           Container(height: 20,),

//           GestureDetector(
//             onTap: () => _selectImage(),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(7),
//               child: Container(     
//                 height: 200,
//                 decoration: BoxDecoration(
//                   color: const Color(primaryDark),
//                   image: imagePatch.isEmpty ? null :
//                   DecorationImage(
//                     image: FileImage(File(imagePatch)),
//                     fit: BoxFit.cover
//                   )
//                 ),
//                 child: imagePatch.isNotEmpty ? Container() :
//                 _buildImageDisplay(widget.bannerModel.uri, widget.editMode),
//               ),
//             ),
//           ),

//           CustomizeTextField(
//             title: '關鐽字', 
//             isPassword: false, 
//             mTextEditingController: _searchKeyTextController, 
//             isenabled: true, 
//             minLine: 1, 
//             maxLine: 1
//           ),

//           Container(height: 40,),

//           _buildSaveButton(),

//           Container(height: 20,),

//           widget.bannerModel.uri.isEmpty ? 
//           Container() :
//           _buildDelButton(),

//           Container(height: 20,),
          
//         ],
//       ),
//     );
//   }

//   Widget _buildImageDisplay(String url, bool editMode){

//     if(url.isEmpty && editMode == false){
//       return const Center(
//         child: Text(
//           '點擊新增',
//           style: TextStyle(color: Colors.grey)
//         ),
//       );
//     }
    
//     if(url.isNotEmpty){
//       return cachedNetworkImage(
//         url,
//         BoxFit.fitWidth
//       );
//     }

//     return Container();

//   }
  
//   Widget _buildSaveButton(){
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         primary: Colors.greenAccent
//       ),
//       onPressed: () => _uploadBanner(
//         _searchKeyTextController.text, 
//         imagePatch
//       ), 
//       child: const Text('新增')
//     );
//   }

//   Widget _buildDelButton(){
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         primary: Colors.redAccent
//       ),
//       onPressed: () => _removeBanner(widget.bannerModel.docId), 
//       child: const Text('刪除')
//     );
//   }

// }
