import 'package:asher_store_cms/constants.dart';
import 'package:asher_store_cms/controller/productlistview_controller.dart';
import 'package:asher_store_cms/model/product_model.dart';
import 'package:asher_store_cms/screen/proudct/product_editor.dart';
import 'package:asher_store_cms/widget/currency_textview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _productlistController = Get.find<ProductListViewController>();
    _productlistController.clearSearch();

    return Scaffold(
      backgroundColor: const Color(backgroundDark),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: _buildSearchAppBar(),
      body: Obx((){
        return _productlistController.resultlist.isEmpty && _productlistController.searchEditingController.text.isNotEmpty?
        const Center(
          child: Text(
            '找不到捜尋結果',
            style: TextStyle(color: Colors.grey),
          ),
        ) :
        Column(
          children: [
            _productlistController.counter.value == 0 ? Container() :
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                '共找到 ${_productlistController.counter.value} 筆相關資料',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _productlistController.resultlist.isNotEmpty ?
                 _productlistController.resultlist.length :
                _productlistController.productlist.length,
                itemBuilder: (context, index){
                  return productListItem(
                    _productlistController.resultlist.isNotEmpty ?
                    _productlistController.resultlist[index] :
                    _productlistController.productlist[index]
                  );
                }
              ),
            ),
          ],
        );
      })
      
    );

  }

  AppBar _buildSearchAppBar(){
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
              onPressed: () => Get.back(), 
              icon: const Icon(
                Icons.arrow_back, 
                size: 20,
                color: Colors.white,
              )
            ),
            Expanded(
              child: TextField(
                controller: Get.find<ProductListViewController>().searchEditingController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(0),
                  isDense: true,
                  hintText: '商品名稱 / 編號捜尋'
                ),
                onSubmitted: (val) => Get.find<ProductListViewController>().searchProduct(),
                onChanged: (val) => val.isNotEmpty ? null : Get.find<ProductListViewController>().clearSearch()
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

  FloatingActionButton _buildFloatingActionButton(){
    return FloatingActionButton(
      onPressed: () => Get.to(() => const ProductEditor()),
      child: const Icon(Icons.add, color: Colors.grey),
      backgroundColor: const Color(primaryDark),
      elevation: 0,
    );
  }

  Widget productListItem(ProductModel productModel){
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => Get.to(() => ProductEditor(productModel: productModel)),
      child: Container(
        height: 120,
        width: MediaQuery.of(Get.context!).size.width,
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
                  image: NetworkImage(productModel.imagePatch![0])
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
                        child: Text(productModel.productNo!)
                      ),
                      productModel.inStock! ? Container() :
                      const Text(
                        '已下架',
                        style: TextStyle(color: Colors.redAccent),
                      )
                    ],
                  ),
                  Text(
                    productModel.productName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('已售出 : ${productModel.sold}'),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CurrencyTextView(
                        value: productModel.price!, 
                        textStyle: productModel.discountPrice == 0 ? 
                        const TextStyle() : 
                        const TextStyle(decoration: TextDecoration.lineThrough)
                      ),
                      Container(width: 10,),
                      productModel.discountPrice == 0 ? const Text('') :
                      CurrencyTextView(
                        value: productModel.discountPrice!, 
                        textStyle: const TextStyle(color: Colors.redAccent),
                      ),
                    ],
                  )

                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}