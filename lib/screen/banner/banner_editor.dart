import 'dart:io';
import 'package:alternate_store_cms/constants.dart';
import 'package:alternate_store_cms/custom_cachednetworkimage.dart';
import 'package:alternate_store_cms/customize_textfield.dart';
import 'package:alternate_store_cms/model/banner_model.dart';
import 'package:alternate_store_cms/service/banner_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class BannerEditor extends StatefulWidget {
  final bool editMode;
  final BannerModel bannerModel;
  const BannerEditor({ Key? key, required this.bannerModel, required this.editMode }) : super(key: key);
  @override
  State<BannerEditor> createState() => _BannerEditorState();
}

class _BannerEditorState extends State<BannerEditor> {

  final TextEditingController _searchKeyTextController = TextEditingController();
  late XFile _localBannerImage = XFile('path');

  Future<void> _selectImage() async {
    try {
      _localBannerImage = (await ImagePicker().pickImage(source: ImageSource.gallery))!; 

      if(_localBannerImage != null){
        setState(() {});
      }
    } on PlatformException catch(e) {
      // ignore: avoid_print
      print('Failed to pick image : $e');
    }
    
  }

  Future<void> uploadBanner(String queryString, XFile bannerImamge) async {

    if(queryString.isEmpty){
      print('1');
      return;
    }

    if(bannerImamge == null){
      print('2');
      return;
    }
    
  }
  
  @override
  void dispose() {
    super.dispose();
    _searchKeyTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(backgroundDark),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
        
            Row(
              children: [
                const Spacer(),
                widget.editMode == false ? Container() : 
                Expanded(
                  child: Text('建立日期 : ${DateFormat('yyyy/MM/dd  kk:mm').format(DateTime.fromMicrosecondsSinceEpoch(widget.bannerModel.createDate.microsecondsSinceEpoch))}')
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context), 
                  icon: const Icon(Icons.close)
                )
              ],
            ),

            Container(height: 20,),

            GestureDetector(
              onTap: () => _selectImage(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Container(     
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(primaryDark),
                    image: DecorationImage(
                      image: FileImage(File(_localBannerImage.path)),
                      fit: BoxFit.cover
                    )
                  ),
                  child: Center(
                    child: _buildImageDisplay(widget.bannerModel.uri, widget.editMode)
                  ),
                ),
              ),
            ),

            CustomizeTextField(
              title: '關鐽字', 
              isPassword: false, 
              mTextEditingController: _searchKeyTextController, 
              isenabled: true, 
              minLine: 1, 
              maxLine: 1
            ),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.greenAccent
              ),
              onPressed: () => uploadBanner(
                _searchKeyTextController.text, 
                _localBannerImage
              ), 
              child: const Text('新增')
            ),

            Container(height: 20,),

            widget.bannerModel.uri.isEmpty ? Container() :
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent
              ),
              onPressed: () => uploadBanner(
                _searchKeyTextController.text, 
                _localBannerImage
              ), 
              child: const Text('刪除')
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildImageDisplay(String url, bool editMode){

    if(url.isEmpty && editMode == false){
      return const Text(
        '點擊新增',
        style: TextStyle(color: Colors.grey)
      );
    }
    
    if(url.isNotEmpty){
      return cachedNetworkImage(url);
    }

    return Container();

  }
  
}
