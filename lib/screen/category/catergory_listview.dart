import 'package:asher_store_cms/constants.dart';
import 'package:asher_store_cms/controller/categorylistview_controller.dart';
import 'package:asher_store_cms/inputvalue_dialog.dart';
import 'package:asher_store_cms/model/category_model.dart';
import 'package:asher_store_cms/service/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CategoryListView extends StatelessWidget {
  final List<CategoryModel>? productCategoryList;
  const CategoryListView({ Key? key, this.productCategoryList }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _controller = Get.find<CategoryListViewController>();
    _controller.searchTextController.clear();
    _controller.searchResultList.clear();
    if(productCategoryList != null){
      _controller.setupData(productCategoryList!);
    }

    return Obx((){
      return Scaffold(
        backgroundColor: const Color(backgroundDark),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addCaetgory(),
          child: const Icon(Icons.add, color: Colors.grey),
          backgroundColor: const Color(primaryDark),
          elevation: 0,
        ),
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
                  onPressed: () => Get.back(result: _controller.tempSelectList),
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
                      hintText: '類別名稱捜尋'
                    ),
                    onSubmitted: (val) => _controller.searchCategory(val),
                    onChanged: (val) => _controller.clearSearchResult(val),
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
        ) :
        _listView(
          _controller.searchResultList.isEmpty ? _controller.categoryList : _controller.searchResultList
        )
      );
    }); 
  }

  Widget _listView(List<CategoryModel> list){

    final _controller = Get.find<CategoryListViewController>();

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 150),
      itemCount: list.length,
      itemBuilder: (context, index){
        return GestureDetector(
          onTap: () => productCategoryList != null ? null :
          _optionDialog(list[index].quickSearch!, list[index].docId!),
          child: Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              children: [

                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: list[index].quickSearch == false ? Colors.grey : Colors.greenAccent,
                    borderRadius: BorderRadius.circular(7)
                  ),
                  child: list[index].quickSearch == false ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility)
                ),
                
                Container(width: 20),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      list[index].name!,
                      style: const TextStyle(fontSize: 18)
                    ),
                    Text(
                      '建立日期: ${DateFormat('yyyy/MM/dd  kk:mm').format(DateTime.fromMicrosecondsSinceEpoch(list[index].createDate!.microsecondsSinceEpoch))}',
                      style: const TextStyle(color: Colors.grey),
                    )
                  ],
                ),
                const Spacer(),

                productCategoryList == null ? 
                const Icon(Icons.more_vert) :
                IconButton(
                  onPressed: () => _controller.selectItem(index),
                  icon: list[index].isSelect == false ?
                  const Icon(Icons.radio_button_unchecked, color: Color(xMainColor)) :
                  const Icon(Icons.radio_button_checked, color: Color(xMainColor)),
                ),

              ],
            ),
          )
        );
      }
    );
  }

  Future<void> _addCaetgory() async {
    String result = await showDialog(
      context: Get.context!, 
      builder: (BuildContext context){
        return inputValueDialog(context, '產品分類', '輸入分類名稱');
      }
    );
    // ignore: unnecessary_null_comparison
    if(result != null){
      FirebaseService().addCategory(
        CategoryModel(
          createDate: Timestamp.now(),
          name: result,
          quickSearch: false,
          isSelect: false,
          docId: ''
        )
      );
    }
  }
  
  void _optionDialog(bool quickSearch, String docId){
    showDialog(
      context: Get.context!, 
      builder: (BuildContext context){
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17)
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.only(left: 25, right: 25),
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            decoration: BoxDecoration(
              color: const Color(backgroundDark),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Text(
                    '設定',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  )
                ),
                Container(height: 30,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.greenAccent
                  ),
                  onPressed: () => Get.find<CategoryListViewController>().setQuickSearch(docId, quickSearch),
                  child: const Text('設定 / 取消快速捜尋')
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent
                  ),
                  onPressed: () => Get.find<CategoryListViewController>().delCategory(docId),
                  child: const Text('刪除')
                ),
                Container(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(primaryDark)
                  ),
                  onPressed: () => Navigator.pop(context), 
                  child: const Text('取消')
                ),
              ],
            ),
          )
        );
      }
    );
  }

}
