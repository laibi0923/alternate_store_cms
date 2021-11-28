// ignore_for_file: unnecessary_null_comparison
import 'package:alternate_store_cms/constants.dart';
import 'package:alternate_store_cms/currency_textview.dart';
import 'package:alternate_store_cms/model/category_model.dart';
import 'package:alternate_store_cms/model/product_model.dart';
import 'package:alternate_store_cms/screen/proudct/product_editor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListView extends StatefulWidget {
  final List<ProductModel> productList;
  const ProductListView({ Key? key, required this.productList }) : super(key: key);

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {

  final List<ProductModel> _resultList = [];
  final List<ProductModel> _productlist = [];
  late int _searchResultCounter = 0;

  void _searchProduct(String val, List<ProductModel> list){
    setState(() {
      _resultList.clear();
      _searchResultCounter = 0;
      if(val.isEmpty){
        _resultList.addAll(list);
      } else {
        for(int i = 0; i < list.length; i++){
          if(
            list[i].productName.toUpperCase().contains(val.toUpperCase()) ||
            list[i].productNo.toUpperCase().contains(val.toUpperCase())
          ){
            _resultList.add(list[i]);
            _searchResultCounter = _resultList.length;
          } 
        }
      }  
    });
  }

  @override
  void initState() {
    super.initState();
    _productlist.addAll(widget.productList);
    _resultList.addAll(widget.productList);
  }

  @override
  Widget build(BuildContext context) {

    final _categoryModel = Provider.of<List<CategoryModel>>(context);
    
    return Scaffold(
      backgroundColor: const Color(backgroundDark),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: _buildSearchAppBar(context, _productlist),
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
            child: productListView(_categoryModel)
          )
        ],
      )
    );
  }

  AppBar _buildSearchAppBar(BuildContext context, List<ProductModel> list){
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
              onPressed: () => Navigator.pop(context), 
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
                  hintText: '商品名稱 / 編號捜尋'
                ),
                onChanged: (val) => _searchProduct(val, list),
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

  FloatingActionButton _buildFloatingActionButton(BuildContext context){
    return FloatingActionButton(
      onPressed: () => 
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductEditor(
          editMode: false, 
          productModel: ProductModel.initialData(),
          categoryModel: []
          )
        )
      ),
      child: const Icon(Icons.add, color: Colors.grey),
      backgroundColor: const Color(primaryDark),
      elevation: 0,
    );
  }

  Widget productListView(List<CategoryModel> categoryModel){

    if(_resultList == null){
      return const Center(
        child: CircularProgressIndicator(color: Colors.grey),
      );
    }

    if(_resultList.isEmpty){
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
      itemCount: _resultList.length,
      itemBuilder: (context, index){
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProductEditor(
            editMode: true, 
            productModel: _resultList[index],
            categoryModel: categoryModel
            ))
          ),
          child: productListItem(context, _resultList[index])
        );
      }
    );
  }

  Widget productListItem(BuildContext context, ProductModel productModel){
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: const Color(primaryDark),
              borderRadius: BorderRadius.circular(7),
              image: DecorationImage(
                image: NetworkImage(productModel.imagePatch[0])
              )
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(productModel.productNo)
                    ),
                    productModel.inStock ? Container() :
                    const Text(
                      '已下架',
                      style: TextStyle(color: Colors.redAccent),
                    )
                  ],
                ),
                Text(
                  productModel.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text('已售出 : ${productModel.sold}'),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CurrencyTextView(
                      value: productModel.price, 
                      textStyle: productModel.discountPrice == 0 ? 
                      const TextStyle() : 
                      const TextStyle(decoration: TextDecoration.lineThrough)
                    ),
                    Container(width: 10,),
                    productModel.discountPrice == 0 ? const Text('') :
                    CurrencyTextView(
                      value: productModel.discountPrice, 
                      textStyle: const TextStyle(color: Colors.redAccent),
                    ),
                  ],
                )

              ],
            ),
          )
        ],
      ),
    );
  }
}
