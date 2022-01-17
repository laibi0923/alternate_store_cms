import 'package:asher_store_cms/constants.dart';
import 'package:asher_store_cms/controller/memberlistview_controller.dart';
import 'package:asher_store_cms/model/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberListView extends StatelessWidget {
  const MemberListView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _controller = Get.find<MemberListViewController>();

    return Obx((){
      return Scaffold(
        backgroundColor: const Color(backgroundDark),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Container(
            decoration: BoxDecoration(
              color: const Color(primaryDark),
              borderRadius: BorderRadius.circular(7)
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Get.back(), 
                  icon: const Icon(
                    Icons.arrow_back, 
                    size: 20,
                    color: Colors.white,
                  )
                ),
                Expanded(
                  child: TextField(
                    controller: _controller.searchTextController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(0),
                      isDense: true,
                      hintText: '會員捜尋'
                    ),
                    onSubmitted: (val) => _controller.searchMember(val),
                    onChanged: (val) => _controller.clearSearchData(val),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Icon(
                    Icons.search,
                    color: Colors.white
                  )
                )
              ],
            ),
          ),
        ),
        body: _controller.searchResultList.isEmpty && _controller.searchTextController.text.isNotEmpty ? 
        const Center(
          child: Text(
            '找不到捜尋結果',
            style: TextStyle(color: Colors.grey),
          ),
        )  :
        ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 150),
          itemCount: _controller.searchResultList.isNotEmpty ? _controller.searchResultList.length : _controller.memberList.length,
          itemBuilder: (context, index){
            return _memberItemView(
              _controller.searchResultList.isNotEmpty ? 
              _controller.searchResultList[index] :
              _controller.memberList[index]
            );
          }
        ),
      );
    });

  }

  Widget _memberItemView(UserModel userModel){
    return Container(
      height: 80,
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            margin: const EdgeInsets.only(right: 20),
            child: ClipRRect(borderRadius: BorderRadius.circular(999),
              child: userModel.photo == '' ? 
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(primaryDark),
                ),
                child: Image.asset(
                  'assets/icon/ic_person.png', 
                  color: const Color(xMainColor)
                )
              ) :
              CachedNetworkImage(
                imageUrl: userModel.photo!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userModel.uid!.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Email : ${userModel.email}",
                ),
                const Spacer(),
                Text(
                  "用戶名稱 : ${userModel.name}",
                  style: const TextStyle(color: Colors.grey)
                ),
                Text(
                  "聯絡電話 : ${userModel.phone}",
                  style: const TextStyle(color: Colors.grey)
                ),
              ],
            )
          )
        ],
      ),
    );
  }

}