import 'package:asher_store_cms/constants.dart';
import 'package:asher_store_cms/controller/banner_controller.dart';
import 'package:asher_store_cms/screen/banner/banner_editor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BannerListView extends StatelessWidget {
  const BannerListView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(backgroundDark),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: _buildAppBar(),
      body: Obx((){
        return _buildBannerListView();
      })
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context){
    return FloatingActionButton(
      onPressed: () => Get.to(() => const BannerEditor()),
      child: const Icon(Icons.add, color: Colors.grey),
      backgroundColor: const Color(primaryDark),
      elevation: 0,
    );
  }

  AppBar _buildAppBar(){
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const Text(
            '封面列表',
            style: TextStyle(fontSize: 24),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Get.back(), 
            icon: const Icon(Icons.close, color: Colors.white)
          )
        ],
      ),
    );
  }

  Widget _buildBannerListView(){

    final _bannerController = Get.find<BannerController>();

    // ignore: unnecessary_null_comparison
    if(_bannerController.bannerList.value == null){
      return const Center(
        child: CircularProgressIndicator(color: Colors.grey),
      );
    }

    if(_bannerController.bannerList.value.isEmpty){
      return const Center(
        child: Text(
          '沒有紀錄',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 150),
      itemCount: _bannerController.bannerList.value.length,
      itemBuilder: (context, index){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                DateFormat('yyyy/MM/dd').format(DateTime.fromMicrosecondsSinceEpoch(_bannerController.bannerList.value[index].createDate.microsecondsSinceEpoch)),
              )
            ),
            GestureDetector(
              onTap: () => Get.to(() => BannerEditor(bannerModel: _bannerController.bannerList.value[index])),
              child: _buildBannerItemView(_bannerController.bannerList.value[index].bannerUri)
            ),
          ],
        );
      }
    );
  }

  Widget _buildBannerItemView(String uri){
    return Container(
      height: 200,
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: 
        CachedNetworkImage(
          imageUrl: uri,
          fit: BoxFit.cover,
        )
      )
    );
  }

}