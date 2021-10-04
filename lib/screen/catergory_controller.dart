import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:alternate_store_cms/constants.dart';
import 'package:alternate_store_cms/model/category_model.dart';
import 'package:alternate_store_cms/service/category_database.dart';
import 'package:alternate_store_cms/inputvalue_dialog.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CatergoryController extends StatefulWidget {
  final bool selectOpen;
  final List<CategoryModel> selectedList;
  const CatergoryController({ Key? key, required this.selectedList, required this.selectOpen }) : super(key: key);

  @override
  _CatergoryControllerState createState() => _CatergoryControllerState();
}

class _CatergoryControllerState extends State<CatergoryController> {

  List<CategoryModel> _categoryItemList = [];
  //final List<CategoryModel> _selectItemList = [];

  void _searchItem(){}

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

  void _delCategoryItem(int index, String docId){
    CategoryDatabase().delCategory(docId);
  }

  void _setQuickSearch(int index, String docId, bool isSeted){
    CategoryDatabase().setQuickSearch(docId, isSeted);
  }
  
  @override
  Widget build(BuildContext context) {


    final categoryDataList = Provider.of<List<CategoryModel>>(context);

    // ignore: unnecessary_null_comparison
    if(categoryDataList == null) {
      return Container();
    }

    _categoryItemList = categoryDataList;  

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

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, widget.selectedList);
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(backgroundDark),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addCategory(),
          child: const Icon(Icons.add, color: Colors.grey),
          backgroundColor: const Color(primaryDark),
          elevation: 0,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (content, innerBoxIsScrolled) => [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              floating: true,
              snap: true,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Container(
                decoration: BoxDecoration(
                  color: const Color(primaryDark),
                  borderRadius: BorderRadius.circular(7)
                ),
                child: Row(
                  children: [
    
                    GestureDetector(
                      onTap: () => Navigator.pop(context, widget.selectedList),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(left: 10, right: 20),
                        decoration: BoxDecoration(
                          color: const Color(backgroundDark),
                          borderRadius: BorderRadius.circular(999)
                        ),
                        child: const Icon(Icons.arrow_back_outlined, color: Colors.grey,),
                      ),
                    ),
    
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(0),
                          hintText: '搜尋分類名稱',
                          hintStyle: TextStyle(fontSize: 14)
                        ),
                      ),
                    ),
    
                    GestureDetector(
                      onTap: () => _searchItem(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(left: 20, right: 10),
                        decoration: BoxDecoration(
                          color: const Color(backgroundDark),
                          borderRadius: BorderRadius.circular(999)
                        ),
                        child: const Icon(Icons.search, color: Colors.grey,),
                      ),
                    ),
    
                  ],
                ),
              ),
            )
          ], 
          body: ListView.builder(
            itemCount: _categoryItemList.length,
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index){
              return GestureDetector(
                onTap: () => _selectItem(index),
                child: Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '建立日期 : ${ 
                                DateFormat('yyyy/MM/dd  kk:mm').format(DateTime.fromMicrosecondsSinceEpoch(_categoryItemList[index].createDate.microsecondsSinceEpoch))
                               }',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Text(
                              _categoryItemList[index].name, 
                              style: const TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),
    
                      _categoryItemList[index].isSelect != true ? Container() :
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          //color: const Color(primaryDark),
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(999)
                        ),
                        child: const Icon(Icons.done, color: Color(backgroundDark)),
                      ),
    
                      GestureDetector(
                        onTap: () => _setQuickSearch(index, _categoryItemList[index].docId, _categoryItemList[index].quickSearch),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(left: 10, right: 0),
                          decoration: BoxDecoration(
                            color: _categoryItemList[index].quickSearch == false ? const Color(primaryDark) : Colors.greenAccent,
                            borderRadius: BorderRadius.circular(999)
                          ),
                          child: Icon(
                            Icons.remove_red_eye_sharp, 
                            color: _categoryItemList[index].quickSearch == false ?
                            Colors.grey : const Color(backgroundDark)
                          ),
                        ),
                      ),
              
                      GestureDetector(
                        onTap: () => _delCategoryItem(index, _categoryItemList[index].docId),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            //color: const Color(primaryDark),
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(999)
                          ),
                          child: const Icon(Icons.delete, color: Color(backgroundDark)),
                        ),
                      ),
              
                    ],
                  ),
                ),
              );
            }
          )
        ),
      ),
    );
  }
}