// ignore_for_file: unnecessary_null_comparison

import 'dart:ui';

import 'package:alternate_store_cms/constants.dart';
import 'package:alternate_store_cms/inputvalue_dialog.dart';
import 'package:alternate_store_cms/model/category_model.dart';
import 'package:alternate_store_cms/service/category_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CatergoryListView extends StatefulWidget {
  final bool selectOpen;
  final List<CategoryModel> selectedList;
  const CatergoryListView({Key? key, required this.selectOpen, required this.selectedList}) : super(key: key);

  @override
  State<CatergoryListView> createState() => _CatergoryListViewState();
}

class _CatergoryListViewState extends State<CatergoryListView> {

  List<CategoryModel> _categoryItemList = [];

  Future<void> _addCategory() async {
    String result = await showDialog(
      context: context, 
      builder: (BuildContext context){
        return inputValueDialog(context, '產品分類', '輸入分類名稱');
      }
    );
    // ignore: unnecessary_null_comparison
    if(result != null){
      CategoryDatabase().addCategory(
        CategoryModel(
          Timestamp.now(), 
          result, 
          false,
          false,
          ''
        )
      );
    }
  }

  void _itemOptionMenu(bool quickSearch, String docId){
    showDialog(
      context: context, 
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
                  onPressed: () {
                    CategoryDatabase().setQuickSearch(docId, quickSearch);
                    Navigator.pop(context);
                  },
                  child: const Text('設定 / 取消快速捜尋')
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent
                  ),
                  onPressed: () {
                    CategoryDatabase().delCategory(docId);
                    Navigator.pop(context);
                  },
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

  void _selectItem(int index){
      if(widget.selectOpen == true){
        setState(() {
          if(_categoryItemList[index].isSelect == true){
            _categoryItemList[index].isSelect = false;
            for(int i = 0; i < widget.selectedList.length; i++){
              if(widget.selectedList[i].name == _categoryItemList[index].name){
                widget.selectedList.removeAt(i);
              }
            }
          } else {
            _categoryItemList[index].isSelect = true;
            widget.selectedList.add(_categoryItemList[index]);
          } 
        });
      }
    }
    
  @override
  Widget build(BuildContext context) {

    final _categoryModel = Provider.of<List<CategoryModel>>(context);

    if(_categoryModel == null) ()=> Container();

    _categoryItemList = _categoryModel;  

    //  清空已選狀態
    for(int i = 0; i < _categoryItemList.length; i++){
      _categoryItemList[i].isSelect = false;  
    }

    //  如果外部 List 不為空則對比現有 List 如果名字相同則 set isSelect 為 true
    if(widget.selectedList.isNotEmpty){
      for(int i = 0; i < _categoryItemList.length; i++){
        for(int k = 0; k < widget.selectedList.length; k++){
          if(_categoryItemList[i].name == widget.selectedList[k].name){
            setState(() {
              _categoryItemList[i].isSelect = true;  
            });
          }
        }
      }
    }
    
    return Scaffold(
      backgroundColor: const Color(backgroundDark),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: _buildSearchAppBar(context, widget.selectedList),
      body: _categoryModel == null ? Container() :
      ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 150),
        itemCount: _categoryModel.length,
        itemBuilder: (context, index){
          return _catrgoryitemview(_categoryModel[index], index);
        }
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context){
    return FloatingActionButton(
      onPressed: () => _addCategory(),
      child: const Icon(Icons.add, color: Colors.grey),
      backgroundColor: const Color(primaryDark),
      elevation: 0,
    );
  }

  AppBar _buildSearchAppBar(BuildContext context, List list){
    return AppBar(
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
              onPressed: () => Navigator.pop(context, list), 
              icon: const Icon(
                Icons.arrow_back, 
                size: 20,
                color: Colors.white,
              )
            ),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(0),
                  isDense: true,
                  hintText: '類別名稱捜尋'
                ),
                onChanged: (val){},
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
    ); 
  }

  Widget _catrgoryitemview(CategoryModel categoryModel, int index){
    return GestureDetector(
      onTap: () => _itemOptionMenu(categoryModel.quickSearch, categoryModel.docId),
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom:10, top: 10),
        padding: const EdgeInsets.only(left: 0, right: 0, bottom:10, top: 10),
        child: Row(
          children: [
            categoryModel.quickSearch == false ? 
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(7)
              ),
              child: const Icon(Icons.visibility_off)
            ) :
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(7)
              ),
              child: const Icon(Icons.visibility)
            ),
            Container(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoryModel.name,
                  style: const TextStyle(fontSize: 18)
                ),
                Text(
                  '建立日期: ${DateFormat('yyyy/MM/dd  kk:mm').format(DateTime.fromMicrosecondsSinceEpoch(categoryModel.createDate.microsecondsSinceEpoch))}',
                  style: const TextStyle(color: Colors.grey),
                )
              ],
            ),
            const Spacer(),
            widget.selectOpen == false ? Container() :
            GestureDetector(
              onTap: () => _selectItem(index),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(7)
                ),
                child: categoryModel.isSelect == false ?
                const Icon(Icons.radio_button_unchecked) :
                const Icon(Icons.radio_button_checked) 
              ),
            ),
            widget.selectOpen == true ? Container() :
            const Icon(Icons.more_vert),
          ],
        ),
      ),
    );
  }

}



