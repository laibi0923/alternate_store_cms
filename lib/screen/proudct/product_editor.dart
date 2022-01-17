import 'dart:io';
import 'package:asher_store_cms/constants.dart';
import 'package:asher_store_cms/controller/producteditor_controller.dart';
import 'package:asher_store_cms/model/product_model.dart';
import 'package:asher_store_cms/randomstring_gender.dart';
import 'package:asher_store_cms/widget/currency_formatter.dart';
import 'package:asher_store_cms/widget/custom_cachednetworkimage.dart';
import 'package:asher_store_cms/widget/customize_textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProductEditor extends StatelessWidget {
  final ProductModel? productModel;
  const ProductEditor({ Key? key, this.productModel }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _productEditorController = Get.put(ProductEditorController());

    if(productModel == null){
      _productEditorController.productNumberController.text = 'SKU${randomStringGender(10, false)}';
      _productEditorController.priceController.text = '0.00';
      _productEditorController.discountController.text = '0.00';
    } else {
      _productEditorController.getModelData(productModel!);
    }

    return Obx((){
      return Scaffold(
        backgroundColor: const Color(backgroundDark),
        body: Stack(
          children: [
            ListView(
              children: [

                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('新增商品', style: TextStyle(fontSize: 22)),
                ),
      
                // Product Image
                GestureDetector(
                  onTap: () => _productEditorController.addLocalImage(),
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: const Color(primaryDark),
                      borderRadius: BorderRadius.circular(7)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  '貨品圖片',
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: const Color(backgroundDark),
                                  borderRadius: BorderRadius.circular(99)
                                ),
                                child: const Icon(Icons.add)
                              )
                            ],
                          ),
                        ),
                        
                        _productEditorController.localImageList.isEmpty && _productEditorController.imagePatchList.isEmpty ? 
                        const Padding(
                          padding: EdgeInsets.only(top: 75, bottom: 75),
                          child: Center(
                            child: Text('點撃新增'),
                          ),
                        ) :
                        Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 20),
                          height: 150,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            children: [
                              
                              ListView.builder(
                                itemCount: _productEditorController.imagePatchList.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index){
                                  return GestureDetector(
                                    onTap: () => _productEditorController.removeImage(index),
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 150,
                                          width: 150,
                                          padding: const EdgeInsets.all(10),
                                          margin: const EdgeInsets.only(left: 15),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(7),
                                            child: CachedNetworkImage(
                                              imageUrl: _productEditorController.imagePatchList[index]
                                            ),
                                          ),
                                        ),
                                        const Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Icon(
                                            Icons.cancel, 
                                            color: Colors.redAccent,
                                            size: 30,
                                          )
                                        )
                                      ],
                                    ),
                                  );
                                }
                              ),

                              ListView.builder(
                                itemCount: _productEditorController.localImageList.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index){
                                  return GestureDetector(
                                    onTap: () => _productEditorController.removeLocalImage(index),
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 150,
                                          width: 150,
                                          padding: const EdgeInsets.all(10),
                                          margin: const EdgeInsets.only(left: 15),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(7),
                                            child: Image.file(
                                              File(_productEditorController.localImageList[index].path),
                                              fit: BoxFit.cover
                                            ),
                                          ),
                                        ),
                                        const Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Icon(
                                            Icons.cancel, 
                                            color: Colors.redAccent,
                                            size: 30,
                                          )
                                        )
                                      ],
                                    ),
                                  );
                                }
                              ),

                            ],
                          )
                        ),
                      
                      ],
                    ),
                  ),
                ),
                
                // Product Number
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: CustomizeTextField(
                    title: '貨品編號 (自動新增)',
                    mTextEditingController: _productEditorController.productNumberController,
                    isenabled: false,
                    isPassword: false, 
                    maxLine: 1, 
                    minLine: 1,
                  ),
                ),

                // Product Name
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: CustomizeTextField(
                    title: '貨品名稱',
                    mTextEditingController: _productEditorController.productNameController, 
                    isenabled: true, 
                    isPassword: false, 
                    minLine: 1,
                    maxLine: 1, 
                  ),
                ),
      
                //  Description
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: CustomizeTextField(
                    title: '貨品說明',
                    mTextEditingController: _productEditorController.descriptionController,
                    minLine: 4,
                    isenabled: true, 
                    isPassword: false, 
                    maxLine: 4, 
                  ),
                ),
      
                //  Price & Discount Price
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
      
                      _buildPriceTextFiled('價格', _productEditorController.priceController),
      
                      Container(width: 20),
      
                      _buildPriceTextFiled('特價', _productEditorController.discountController),
      
                    ],
                  ),
                ),
      
                // Size
                GestureDetector(
                  onTap: () => _productEditorController.addSize(),
                  child: Container(
                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xff2f2f2f),
                      borderRadius: BorderRadius.circular(7)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  '呎碼',
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: const Color(backgroundDark),
                                  borderRadius: BorderRadius.circular(99)
                                ),
                                child: const Icon(Icons.add)
                              )
                            ],
                          ),
                        ),
                        _productEditorController.sizeList.isEmpty ? 
                        const Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 40),
                          child: Center(
                            child: Text('點撃新增'),
                          ),
                        ):
                        Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 20),
                          height: 50,
                          child: ListView.builder(
                            itemCount: _productEditorController.sizeList.length,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index){
                              return GestureDetector(
                                onTap: () => _productEditorController.removeSize(index),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  margin: const EdgeInsets.only(left: 15),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey
                                    ),
                                    borderRadius: BorderRadius.circular(99)
                                  ),
                                  child: Center(
                                    child: Text(
                                      _productEditorController.sizeList[index],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    )
                                  ),
                                ),
                              );
                            }
                          )
                        ),
                
                      ],
                    ),
                  ),
                ),
              
                // Color
                GestureDetector(
                  onTap: () => _productEditorController.addColor(),
                  child: Container(
                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xff2f2f2f),
                      borderRadius: BorderRadius.circular(7)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                '顏色',
                                  style: TextStyle(fontWeight: FontWeight.bold)
                              ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: const Color(backgroundDark),
                                  borderRadius: BorderRadius.circular(99)
                                ),
                              child: const Icon(Icons.add)
                              )
                            ],
                          ),
                        ),
                        _productEditorController.colorList.isEmpty && _productEditorController.localColorList.isEmpty ? 
                        const Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 40),
                          child: Center(
                            child: Text('點撃新增')
                          ),
                        ) :
                        Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 20),
                          height: 110,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            children: [

                              // _productEditorController.colorList.isEmpty ? Container() :
                              ListView.builder(
                                itemCount: _productEditorController.colorList.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index){
                                  return GestureDetector(
                                    onTap: () => _productEditorController.removeColor(index),
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(                                  
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 60,
                                                width: 60,
                                                margin: const EdgeInsets.only(left: 15),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(999),
                                                  child: cachedNetworkImage(
                                                    _productEditorController.colorList[index]['COLOR_IMAGE'],
                                                    BoxFit.cover
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 50,
                                                margin: const EdgeInsets.only(left: 15),
                                                padding: const EdgeInsets.only(top: 10),
                                                child: Center(
                                                  child: Text(
                                                    _productEditorController.colorList[index]['COLOR_NAME'],
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  )
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Icon(
                                            Icons.cancel,
                                            color: Colors.redAccent,
                                          )
                                        )
                                      ],
                                    ),
                                  );
                                }
                              ),
                              
                              ListView.builder(
                                itemCount: _productEditorController.localColorList.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index){
                                  return GestureDetector(
                                    onTap: () => _productEditorController.removeColor(index),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Container(
                                                height: 60,
                                                width: 60,
                                                margin: const EdgeInsets.only(left: 15),
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: FileImage(_productEditorController.localColorList[index]['COLOR_IMAGE']),
                                                    fit: BoxFit.cover
                                                  ),
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Colors.grey
                                                  ),
                                                  borderRadius: BorderRadius.circular(99)
                                                ),
                                              ),
                                            ),
                                            const Positioned(
                                              top: 0,
                                              right: 0,
                                              child: Icon(
                                                Icons.cancel,
                                                color: Colors.redAccent,
                                              )
                                            )
                                          ],
                                        ),
                                        Container(
                                          width: 50,
                                          margin: const EdgeInsets.only(left: 15),
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Center(
                                            child: Text(
                                              _productEditorController.localColorList[index]['COLOR_NAME'],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              ),

                            ],
                          )
                        ),
                
                      ],
                    ),
                  ),
                ),
              
                // Tag
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: CustomizeTextField(
                    title: '標籤',
                    mTextEditingController: _productEditorController.tagController,
                    isenabled: true, 
                    isPassword: false, 
                    maxLine: 1, 
                    minLine: 1,
                  ),
                ),
      
                // Category
                GestureDetector(
                  onTap: () => _productEditorController.addCategory(),
                  child: Container(
                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xff2f2f2f),
                      borderRadius: BorderRadius.circular(7)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  '分類',
                                  style: TextStyle(fontWeight: FontWeight.bold)
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: const Color(backgroundDark),
                                  borderRadius: BorderRadius.circular(99)
                                ),
                                child: const Icon(Icons.add)
                              )
                            ],
                          ),
                        ),
                        _productEditorController.categoryList.isEmpty ? 
                        const Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 40),
                          child: Center(
                            child: Text('點撃新增'),
                          ),
                        ) :
                        Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 20),
                          height: 30,
                          child: ListView.builder(
                            itemCount: _productEditorController.categoryList.length,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index){
                              return GestureDetector(
                                onTap: () => _productEditorController.removeCategory(index),
                                child: Container(
                                  margin: const EdgeInsets.only(left: 15),
                                  padding: const EdgeInsets.only(left: 15, right: 15),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey
                                    ),
                                    borderRadius: BorderRadius.circular(99)
                                  ),
                                  child: Center(
                                    child: Text(
                                      _productEditorController.categoryList[index].name!, 
                                      style: const TextStyle(color: Colors.grey),
                                    )
                                  ),
                                ),
                              );
                            }
                          )
                        ),
                      ],
                    ),
                  ),
                ),
      
                //  InStock Status
                GestureDetector(
                  onTap: () => _productEditorController.toggleInStockStatus(),
                  child: Container(
                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xff2f2f2f),
                      borderRadius: BorderRadius.circular(7)
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text('上架狀態')
                        ),
                        _productEditorController.inStock.value == true ? const Text('已上架') : const Text('未上架', style: TextStyle(color: Colors.redAccent),),
                      ],
                    )
                  ),
                ),
      
                // refund
                GestureDetector(
                  onTap: () => _productEditorController.toggleRefundStatus(),
                  child: Container(
                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xff2f2f2f),
                      borderRadius: BorderRadius.circular(7)
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text('退款選擇')
                        ),
                        _productEditorController.refundable.value == true ? const Text('可退款', style: TextStyle(color: Colors.redAccent)) : const Text('不可退款'),
                      ],
                    )
                  ),
                ),
      
                _productEditorController.createDate == null ? Container() :
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent
                    ),
                    onPressed: () => _productEditorController.delProduct(),
                    child: const Text('刪除此商')
                  ),
                ),

              ],
            ),
            //  
            Positioned(
              top: 60,
              right: 70,
              child: GestureDetector(
                onTap: () => _productEditorController.saveProduct(),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(backgroundDark),
                    borderRadius: BorderRadius.circular(999)
                  ),
                  child: const Icon(Icons.upload, color: Colors.grey)
                )
              ),
            ),
            //  Close Button
            Positioned(
              top: 60,
              right: 20,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(backgroundDark),
                    borderRadius: BorderRadius.circular(999)
                  ),
                  child: const Icon(Icons.close, color: Colors.grey,)
                )
              ),
            )
          ],
        ),
      );

    });
  
  }

  Expanded _buildPriceTextFiled(String title, TextEditingController controller){
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
        margin: const EdgeInsets.only(top: 20),
        decoration: const BoxDecoration(
          color: Color(primaryDark),
          borderRadius: BorderRadius.all(Radius.circular(7))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            TextField(
              maxLines: 1,
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: 'HK\$',
                contentPadding: EdgeInsets.all(0),
                isDense: true,
                border: InputBorder.none
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CurrencyFormatter(8)
              ],
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }
  
}