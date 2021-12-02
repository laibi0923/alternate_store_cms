import 'package:alternate_store_cms/constants.dart';
import 'package:alternate_store_cms/model/banner_model.dart';
import 'package:alternate_store_cms/screen/banner/banner_editor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BannerListView extends StatelessWidget {
  const BannerListView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _bannerList = Provider.of<List<BannerModel>>(context);

    return Scaffold(
      backgroundColor: const Color(backgroundDark),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: _buildAppBar(context),
      body: _buildBannerListView(_bannerList)
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context){
    return FloatingActionButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => 
        BannerEditor(
          bannerModel: BannerModel.initialData(), 
          editMode: false,))
        ),
      child: const Icon(Icons.add, color: Colors.grey),
      backgroundColor: const Color(primaryDark),
      elevation: 0,
    );
  }

  AppBar _buildAppBar(BuildContext context){
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context), 
            icon: const Icon(Icons.close, color: Colors.white)
          )
        ],
      ),
    );
  }

  Widget _buildBannerListView(List<BannerModel> list){

    if(list == null){
      return const Center(
        child: CircularProgressIndicator(color: Colors.grey),
      );
    }

    if(list.isEmpty){
      return const Center(
        child: Text(
          '沒有紀錄',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 150),
      itemCount: list.length,
      itemBuilder: (context, index){
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BannerEditor(bannerModel: list[index], editMode: true,))),
          child: _buildBannerItemView(list[index].uri)
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