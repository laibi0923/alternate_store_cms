// ignore_for_file: unnecessary_null_comparison

import 'dart:ui';
import 'package:alternate_store_cms/constants.dart';
import 'package:alternate_store_cms/inputvalue_dialog.dart';
import 'package:alternate_store_cms/model/category_model.dart';
import 'package:alternate_store_cms/service/category_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CatergoryListView extends StatefulWidget {
  final bool selectOpen;
  final List<CategoryModel> selectedList;
  const CatergoryListView({Key? key, required this.selectOpen, required this.selectedList}) : super(key: key);

  @override
  State<CatergoryListView> createState() => _CatergoryListViewState();
}

class _CatergoryListViewState extends State<CatergoryListView> {

  final List<CategoryModel> _searchList = [];
  late int _searchResultCounter = 0;
  final TextEditingController _searchTextController = TextEditingController();

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
                    _searchList.clear();
                    _searchTextController.clear();
                    _searchResultCounter = 0;
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
                    _searchList.clear();
                    _searchTextController.clear();
                    _searchResultCounter = 0;
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

  void _selectItem(int index, CategoryModel dbCategoryModel){
      if(widget.selectOpen == true){
        setState(() {
          if(dbCategoryModel.isSelect == true){
            dbCategoryModel.isSelect = false;
            for(int i = 0; i < widget.selectedList.length; i++){
              if(widget.selectedList[i].name == dbCategoryModel.name){
                widget.selectedList.removeAt(i);
              }
            }
          } else {
            dbCategoryModel.isSelect = true;
            widget.selectedList.add(dbCategoryModel);
          } 
        });
      }
    }
    
  void _searchCategory(String val, List<CategoryModel> list){
    setState(() {
      _searchList.clear();
      _searchResultCounter = 0;
      if(val.isNotEmpty){
        for(int i = 0; i < list.length; i++){
          if(list[i].name.toUpperCase().contains(val.toUpperCase())){
            _searchList.add(list[i]);
            _searchResultCounter = _searchList.length;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final _dbCategoryList = Provider.of<List<CategoryModel>>(context);

    //  清空已選狀態
    for(int i = 0; i < widget.selectedList.length; i++){
      widget.selectedList[i].isSelect = false;  
    }
    
    //  如果外部 List 不為空則對比現有 List 如果名字相同則 set isSelect 為 true
    if(widget.selectedList.isNotEmpty){
      for(int i = 0; i < widget.selectedList.length; i++){
        for(int k = 0; k < _dbCategoryList.length; k++){
          if(widget.selectedList[i].name == _dbCategoryList[k].name){
            setState(() {
              widget.selectedList[i].isSelect = true;  
            });
          }
        }
      }
    }

    return Scaffold(
      backgroundColor: const Color(backgroundDark),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: _buildSearchAppBar(context, _dbCategoryList),
      body: Column(
        children: [
          _searchResultCounter == 0 ? Container() :
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              '共找到 $_searchResultCounter 筆相關資料',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: _searchTextController.text.isNotEmpty || _searchList.isNotEmpty ? 
            _categoryListView(_searchList) :
            _categoryListView(_dbCategoryList)
          )
        ],
      )
      
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

  AppBar _buildSearchAppBar(BuildContext context, List<CategoryModel> list){
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
              onPressed: () => Navigator.pop(context, widget.selectedList), 
              icon: const Icon(
                Icons.arrow_back, 
                size: 20,
                color: Colors.white,
              )
            ),
            Expanded(
              child: TextField(
                controller: _searchTextController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(0),
                  isDense: true,
                  hintText: '類別名稱捜尋'
                ),
                onChanged: (val) => _searchCategory(val, list),
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

  Widget _categoryListView(List<CategoryModel> list){

    if(list == null){
      return const Center(
        child: CircularProgressIndicator(color: Colors.grey),
      );
    }

    if(list.isEmpty){
      return const Center(
        child: Text(
          '找不到捜尋結果',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 150),
      itemCount: list.length,
      itemBuilder: (context, index){
        return _catrgoryitemview(list[index], index);
      }
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
              onTap: () => _selectItem(index, categoryModel),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
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



