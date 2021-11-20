import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:alternate_store_cms/constants.dart';
import 'package:alternate_store_cms/currency_formatter.dart';
import 'package:alternate_store_cms/customize_textfield.dart';
import 'package:alternate_store_cms/loading_indicator.dart';
import 'package:alternate_store_cms/model/category_model.dart';
import 'package:alternate_store_cms/model/product_model.dart';
import 'package:alternate_store_cms/custom_snackbar.dart';
import 'package:alternate_store_cms/randomstring_gender.dart';
import 'package:alternate_store_cms/screen/catergory_controller.dart';
import 'package:alternate_store_cms/service/product_database.dart';
import 'package:alternate_store_cms/inputvalue_dialog.dart';


class ProductEditor extends StatefulWidget {
  const ProductEditor({ Key? key }) : super(key: key);

  @override
  State<ProductEditor> createState() => _ProductEditorState();
}

class _ProductEditorState extends State<ProductEditor> {

  bool _inStock = false;
  bool _refundable = false;

  List<XFile>? _imageList = [];
  final List _sizeList = [];
  final List<Map<String, dynamic>> _colorList = [];
  List<CategoryModel> _categoryList = [];

  final TextEditingController _productNumberController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  void showLoadingIndicator() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async =>  false,
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))
            ),
            backgroundColor: Colors.black87,
            content: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black.withOpacity(0.8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  
                  Padding(
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(strokeWidth: 3, color: Colors.grey),
                    ),
                    padding: EdgeInsets.only(bottom: 16)
                  ),

                  Padding(
                    child: Text(
                      '請稍等',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                      textAlign: TextAlign.center,
                    ),
                    padding: EdgeInsets.only(bottom: 4)
                  ),


                  Text(
                    '上載產品中...',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14
                    ),
                    textAlign: TextAlign.center,
                  ),

                ],
              ),
            )
          ),
        );
      },
    );
  }

  //  Upload Product to Firestore
  void _uploadProduct(){

    if(_imageList!.isEmpty){
      CustomSnackBar().show(context, '最少一張產品圖片');
      return;
    }

    if(_productNameController.text.isEmpty){
      CustomSnackBar().show(context, '請輸入產品名稱');
      return;
    }

    double _orginalPrice = 0.00;
    double _discountPrice = 0.00;

    _orginalPrice = double.parse(_priceController.text.replaceAll(',', ''));
    _discountPrice = double.parse(_discountController.text.replaceAll(',', ''));


    if(_orginalPrice == 0){
      CustomSnackBar().show(context, '請輸入產品價格');
      return;
    }

    if(_discountPrice >= _orginalPrice){
      CustomSnackBar().show(context, '特價價錢不能大於或等於原本價格');
      return;
    }

    if(_sizeList.isEmpty){
      CustomSnackBar().show(context, '最少輸入一隻呎碼');
      return;
    }

    if(_colorList.isEmpty){
      CustomSnackBar().show(context, '最少輸入一隻顏色');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => loadingIndicator()
    );

    List _tempCategoryList = [];
    for(int i = 0; i < _categoryList.length; i++){
      _tempCategoryList.add(_categoryList[i].name);
    }

    ProductDatabase().uploadProductImage(_imageList!).then((_imageUrlList) {

      ProductDatabase().uploadColorImage(_colorList).then((_colorUrlList) {

        ProductDatabase().createNewProduct(
            _productNumberController.text,
            ProductModel(
              Timestamp.now(), 
              Timestamp.now(), 
              _inStock, 
              0, 
              0, 
              _productNumberController.text, 
              _productNameController.text, 
              _imageUrlList, 
              _descriptionController.text, 
              _orginalPrice, 
              _discountPrice, 
              _sizeList, 
              _colorUrlList, 
              _tagController.text, 
              _tempCategoryList, 
              _refundable
            )
          ).then((value) {
            Navigator.pop(context);
            Navigator.pop(context);
            CustomSnackBar().show(context, '上載完成');
          });
        });

      });
  }

  //  Add Product Image
  Future<void> _addImage() async {

    try{

      _imageList = (await ImagePicker().pickMultiImage());

      if(_imageList!.isNotEmpty){
        setState(() {});
      }
      // final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      // if(image == null){
      //   return;
      // } else {
      //   final File imageTemporary = File(image.path);
      //   setState(() {
      //     _imageList.add(imageTemporary);
      //   });
      // }
    } on PlatformException catch (e){
      // ignore: avoid_print
      print('Failed to pick image : $e');
    }
  }

  _removeProductImage(int index){
    setState(() {
      _imageList!.removeAt(index);  
    });
  }

  //  Add Product Size
  Future<void> _addSize() async {
    String result = await showDialog(
      context: context, 
      builder: (BuildContext context){
        return inputValueDialog(context, '輸入呎碼', 'eg : XL / XXL / 41...');
      }
    );
    // ignore: unnecessary_null_comparison
    if(result != null && result.isNotEmpty) {
      setState(() {
        _sizeList.add(result.toUpperCase().trim());  
      });
    }
  }

  _removeSize(int index){
    setState(() {
      _sizeList.removeAt(index);  
    });
  }

  //  Add Product Color
  Future<void> _addColor() async {
    
    File? imageTemporary;

    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null){
        return;
      } else {
        imageTemporary = File(image.path);
        //_colorImage.add(imageTemporary);
      }
    } on PlatformException catch (e){
      // ignore: avoid_print
      print('Failed to pick image : $e');
    }

    String result = await showDialog(
      context: context, 
      builder: (BuildContext context){
        return inputValueDialog(context, '輸入顏色', 'eg : 0XFF000000...');
      }
    );

    // ignore: unnecessary_null_comparison
    if(result != null && result.isNotEmpty){
      setState(() {
        _colorList.add({
          "COLOR_IMAGE" : imageTemporary,
          "COLOR_NAME" : result.toUpperCase().trim(),
        });  
      });
    }  
  
  }

  _removeColor(int index){
    setState(() {
      _colorList.removeAt(index);  
    });
  }

  //  Add Product Categoty
  Future<void> _addCategory() async {

    List<CategoryModel> selectedList = await Navigator.push(context, MaterialPageRoute(builder: (context) => CatergoryController(selectOpen: true, selectedList: _categoryList,)));

    // ignore: unnecessary_null_comparison
    if(selectedList != null){
      setState(() {
        _categoryList = selectedList;
      });
    } else {
      setState(() {
        _categoryList.clear();  
      });
    }
  }

  _removeCategory(int index){
    setState(() {
      _categoryList.removeAt(index);  
    });
  }

  //  Set Instock Status
  void _inStockStatus(){
    setState(() {
      if(_inStock == true){
        _inStock = false;
      } else {
        _inStock = true;
      }
    });
  }

  //  Set Refund Status
  void _refundStatus(){
    setState(() {
      if(_refundable == true){
        _refundable = false;
      } else {
        _refundable = true;
      }
    });
  }

  @override
  void initState() {
    _productNumberController.text = 'SKU${randomStringGender(10, false)}';
    _priceController.text = '0.00';
    _discountController.text = '0.00';
    super.initState();
  }

  @override
  void dispose() {
    _productNumberController.dispose();
    _productNameController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(backgroundDark),
      body: Stack(
        children: [

          ListView(
            shrinkWrap: false,
            physics: const BouncingScrollPhysics(),
            children: [
    
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text('新增商品', style: TextStyle(fontSize: 22)),
              ),
    
              // Product Image
              GestureDetector(
                onTap: () => _addImage(),
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
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
                      _imageList!.isEmpty ? 
                      const Padding(
                        padding: EdgeInsets.only(top: 75, bottom: 75),
                        child: Center(
                          child: Text('點撃新增'),
                        ),
                      ) :
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        height: 150,
                        child: ListView.builder(
                          itemCount: _imageList!.length,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index){
                            return GestureDetector(
                              onTap: () => _removeProductImage(index),
                              child: Container(
                                height: 50,
                                width: 150,
                                margin: const EdgeInsets.only(left: 15),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(17),
                                  image: DecorationImage(
                                    image: FileImage(File(_imageList![index].path)),
                                    fit: BoxFit.cover
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
              
              // Product Number
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: CustomizeTextField(
                  title: '貨品編號 (自動新增)',
                  mTextEditingController: _productNumberController,
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
                  mTextEditingController: _productNameController, 
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
                  mTextEditingController: _descriptionController,
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
    
                    _buildPriceTextFiled(
                      '價格',
                      _priceController,
                    ),
    
                    Container(
                      width: 20,
                    ),
    
                    _buildPriceTextFiled(
                      '特價',
                      _discountController,
                    ),
    
                  ],
                ),
              ),
    
              // Size
              GestureDetector(
                onTap: () => _addSize(),
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
                       _sizeList.isEmpty ? 
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
                          itemCount: _sizeList.length,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index){
                            return GestureDetector(
                              onTap: () => _removeSize(index),
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
                                    _sizeList[index],
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
                onTap: () => _addColor(),
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
                      _colorList.isEmpty ? 
                      const Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 40),
                        child: Center(
                          child: Text('點撃新增')
                        ),
                      ) :
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        height: 80,
                        child: ListView.builder(
                          itemCount: _colorList.length,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index){
                            return GestureDetector(
                              onTap: () => _removeColor(index),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    margin: const EdgeInsets.only(left: 15),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: FileImage(_colorList[index]['COLOR_IMAGE']),
                                        fit: BoxFit.cover
                                      ),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.grey
                                      ),
                                      borderRadius: BorderRadius.circular(99)
                                    ),
                                  ),
                                  Container(
                                    width: 50,
                                    margin: const EdgeInsets.only(left: 15),
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Center(
                                      child: Text(
                                        _colorList[index]['COLOR_NAME'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
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
                  mTextEditingController: _tagController,
                  isenabled: true, 
                  isPassword: false, 
                  maxLine: 1, 
                  minLine: 1,
                ),
              ),
    
              // Category
              GestureDetector(
                onTap: () => _addCategory(),
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
                      _categoryList.isEmpty ? const Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 40),
                        child: Center(
                          child: Text('點撃新增'),
                        ),
                      ) :
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        height: 30,
                        child: ListView.builder(
                          itemCount: _categoryList.length,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index){
                            return GestureDetector(
                              onTap: () => _removeCategory(index),
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
                                    _categoryList[index].name, 
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
                onTap: () => _inStockStatus(),
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
                      _inStock == true ? const Text('已上架') : const Text('未上架', style: TextStyle(color: Colors.redAccent),),
                    ],
                  )
                ),
              ),
    
              // refund
              GestureDetector(
                onTap: () => _refundStatus(),
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
                      _refundable == true ? const Text('可退款', style: TextStyle(color: Colors.redAccent)) : const Text('不可退款'),
                    ],
                  )
                ),
              ),
    
              Container(
                height: 50,
              )
    
            ],
          ),
        
          Positioned(
            top: 60,
            right: 70,
            child: GestureDetector(
              onTap: () => _uploadProduct(),
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

          Positioned(
            top: 60,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
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
  }

  Expanded _buildPriceTextFiled(String title, TextEditingController controller){
    return 
    Expanded(
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