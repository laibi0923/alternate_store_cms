import 'dart:io';

import 'package:asher_store_cms/constants.dart';
import 'package:asher_store_cms/controller/bannereditor_controller.dart';
import 'package:asher_store_cms/model/banner_model.dart';
import 'package:asher_store_cms/widget/custom_cachednetworkimage.dart';
import 'package:asher_store_cms/widget/customize_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BannerEditor extends StatelessWidget {
  final BannerModel? bannerModel;
  const BannerEditor({ Key? key, this.bannerModel }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _bannerEditorController = Get.put(BannerEditorController());
    
    if(bannerModel != null){
      _bannerEditorController.searchKeyTextController.text = bannerModel!.queryString;
    } else {
      _bannerEditorController.imageFilePatch.value == '';
      _bannerEditorController.searchKeyTextController.text = '';
    }
    
    return Scaffold(
      backgroundColor: const Color(backgroundDark),
      body: Obx((){
        return ListView(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 80, bottom: 30),
          children: [
            
            Row(
              children: [
                bannerModel == null ? const Spacer() : Container(),
                bannerModel == null  ? Container() : 
                Expanded(
                  child: Text('建立日期 : ${DateFormat('yyyy/MM/dd  kk:mm').format(DateTime.fromMicrosecondsSinceEpoch(bannerModel!.createDate.microsecondsSinceEpoch))}')
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context), 
                  icon: const Icon(Icons.close)
                )
              ],
            ),

            Container(height: 20,),

            GestureDetector(
              onTap: () => _bannerEditorController.pickupImage(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Container(     
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(primaryDark),
                    image: _bannerEditorController.imageFilePatch.value.isEmpty ? null :
                    DecorationImage(
                      image: FileImage(File(_bannerEditorController.imageFilePatch.value)),
                      fit: BoxFit.cover
                    )
                  ),
                  child: _bannerEditorController.imageFilePatch.isNotEmpty ? 
                  Container() :
                  bannerModel != null ? 
                  cachedNetworkImage(bannerModel!.bannerUri, BoxFit.cover) :
                  const Center(
                    child: Text('點擊新增圖片'),
                  )
                ),
              ),
            ),

            CustomizeTextField(
              title: '關鐽字', 
              isPassword: false, 
              mTextEditingController: _bannerEditorController.searchKeyTextController, 
              isenabled: true, 
              minLine: 1, 
              maxLine: 1
            ),

            Container(height: 40,),

            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.greenAccent),
              onPressed: () => _bannerEditorController.uploadBanner(bannerModel),
              child: bannerModel != null ?
              const Text('更新') :
              const Text('新增')
            ),

            Container(height: 20,),

            bannerModel == null ?
            Container() :
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent
              ),
              onPressed: () => _bannerEditorController.delBanner(bannerModel!),
              child: const Text('刪除')
            ),

            Container(height: 20,),
            
          ],
        );
      })
    );
  }

}
