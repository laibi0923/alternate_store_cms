import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alternate_store_cms/constants.dart';
import 'package:alternate_store_cms/currency_formatter.dart';
import 'package:alternate_store_cms/customize_textfield.dart';
import 'package:alternate_store_cms/model/coupon_model.dart';
import 'package:alternate_store_cms/custom_snackbar.dart';
import 'package:alternate_store_cms/service/coupon_service.dart';
import 'package:intl/intl.dart';

class CouponEditor extends StatefulWidget {
  final bool editModel;
  final CouponModel couponModel;
  const CouponEditor({ Key? key, required this.editModel, required this.couponModel }) : super(key: key);

  @override
  _CouponEditorState createState() => _CouponEditorState();
}

class _CouponEditorState extends State<CouponEditor> {

  String appBarTitle = '';
  final TextEditingController _couponCodeTextEditingController = TextEditingController();
  final TextEditingController _couponPriceTextEditingController = TextEditingController();
  final TextEditingController _couponPercentageTextEditingController = TextEditingController();
  final TextEditingController _remarkTextEditingController = TextEditingController();
  final TextEditingController _validDateTextEditingController = TextEditingController();
  DateTime _validDate = DateTime.now();
  bool _unLimited = false;

  //  上載
  void _uploadCoupon(){

    if(_couponCodeTextEditingController.text.isEmpty){
      CustomSnackBar().show(context, 'content');
      return;
    }

    double _couponPrice = 0.00;
    double _couponPercentage = 0.00;

    _couponPrice = double.parse(_couponPriceTextEditingController.text.replaceAll(',', ''));
    _couponPercentage = double.parse(_couponPercentageTextEditingController.text.replaceAll(',', ''));

    if(_couponPrice == 0 && _couponPercentage == 0){
      CustomSnackBar().show(context, '請輸入折扣');
      return;
    }

    if(widget.editModel == true){

      CouponService().updateCoupon(
        widget.couponModel.docId,
        CouponModel(
          widget.couponModel.createDate, 
          _couponCodeTextEditingController.text, 
          _couponPrice, 
          _couponPercentage, 
          Timestamp.fromDate(_validDate), 
          _remarkTextEditingController.text, 
          _unLimited,
          ''
        )
      );
      

    } else {

      CouponService().addCoupon(
        CouponModel(
          Timestamp.now(), 
          _couponCodeTextEditingController.text, 
          _couponPrice, 
          _couponPercentage, 
          Timestamp.fromDate(_validDate), 
          _remarkTextEditingController.text, 
          _unLimited,
          ''
        )
      );

    }

    Navigator.pop(context, true);

  }

  Future<void> _pickValidDate(BuildContext context) async {

    final ThemeData theme = Theme.of(context);

    // ignore: unnecessary_null_comparison
    assert(theme.platform != null);

    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context);
    }

  }

  /// This builds material date picker in Android
  buildMaterialDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _validDate){
      setState(() {
        _validDate = picked;
        _validDateTextEditingController.text = 
        DateFormat('yyyy/MM/dd').format(DateTime.fromMicrosecondsSinceEpoch(_validDate.microsecondsSinceEpoch));
      });
    }
  }

  /// This builds cupertion date picker in iOS
  buildCupertinoDatePicker(BuildContext context) {
    showModalBottomSheet(
    context: context,
    builder: (BuildContext builder) {
      return Container(
        height: MediaQuery.of(context).copyWith().size.height / 3,
        color: Colors.white,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (picked) {
            // ignore: unnecessary_null_comparison
            if (picked != null && picked != _validDate){
              setState(() {
                _validDate = picked;
                _validDateTextEditingController.text = 
                DateFormat('yyyy/MM/dd').format(DateTime.fromMicrosecondsSinceEpoch(_validDate.microsecondsSinceEpoch));
              });
            }
          },
          initialDateTime: DateTime.now(),
          minimumYear: 2000,
          maximumYear: 2025,
        ),
      );
    });
  }

  //  Delete Coupon
  void _delCoupon(String docId) {
    CouponService().delCoupon(docId);
    Navigator.pop(context, true);
  }

  //  Limite switcher
  void _setUnLimited(){
    setState(() {
      if(_unLimited == true){
        _unLimited = false;
      } else {
        _unLimited = true;
      }
    });
  }
  
  @override
  void initState() {
    super.initState();
    if(widget.editModel == true){
      appBarTitle = '修改優惠碼';
      _couponCodeTextEditingController.text = widget.couponModel.couponCode;
      _couponPriceTextEditingController.text = widget.couponModel.discountAmount.toString();
      final formatter = NumberFormat("###,##0.00", "en");
      String formatterPercentage =  formatter.format(widget.couponModel.percentage);
      _couponPercentageTextEditingController.text = formatterPercentage;
      _remarkTextEditingController.text = widget.couponModel.remark;
      _validDateTextEditingController.text = DateFormat('yyyy/MM/dd').format(DateTime.fromMicrosecondsSinceEpoch(widget.couponModel.validDate.microsecondsSinceEpoch));
      _validDate = DateTime.fromMicrosecondsSinceEpoch(widget.couponModel.validDate.microsecondsSinceEpoch);
      _unLimited = widget.couponModel.unLimited;
    } else {
      appBarTitle = '新增優惠碼';
      _couponPercentageTextEditingController.text = '0.00';
      _couponPriceTextEditingController.text = '0.00';
      _validDateTextEditingController.text = DateFormat('yyyy/MM/dd').format(DateTime.fromMicrosecondsSinceEpoch(_validDate.microsecondsSinceEpoch));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _couponCodeTextEditingController.dispose();
    _couponPriceTextEditingController.dispose();
    _couponPercentageTextEditingController.dispose();
    _remarkTextEditingController.dispose();
    _validDateTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(backgroundDark),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [

            GestureDetector(
              onTap: () => _uploadCoupon(),
              child: const Icon(Icons.upload, color: Colors.grey)
            ),

            Expanded(
              child: Center(
                child: Text(appBarTitle) 
              )
            ),

            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close, color: Colors.grey,)
            )

          ],
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          
          //  優惠代碼名稱
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: CustomizeTextField(
              title: '優惠代碼名稱',
              mTextEditingController: _couponCodeTextEditingController,
              isenabled: true,
              isPassword: false, 
              maxLine: 1, 
              minLine: 1,
            ),
          ),

          //  全單扣減
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [

                _buildPriceTextFiled(
                  '全單扣減',
                  _couponPriceTextEditingController,
                  _couponPercentageTextEditingController
                ),

                Container(
                  width: 20,
                ),

                _buildPercentageTextFiled(
                  '百分比扣減(%OFF)',
                  _couponPercentageTextEditingController,
                  _couponPriceTextEditingController
                ),
                
              ],
            ),
          ),

          //  優惠代碼說明
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: CustomizeTextField(
              title: '優惠代碼說明',
              mTextEditingController: _remarkTextEditingController,
              minLine: 4,
              isenabled: true, 
              isPassword: false, 
              maxLine: 4, 
            ),
          ),

          //  優惠限期
          GestureDetector(
            onTap: () => _setUnLimited(),
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
                    child: Text('優惠限期')
                  ),
                  _unLimited == true ? const Text('無限期') : const Text('有限期', style: TextStyle(color: Colors.redAccent),),
                ],
              )
            ),
          ),

          //  有效使用期至
          _unLimited == true ? Container() :
          GestureDetector(
            onTap: () => _pickValidDate(context),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: CustomizeTextField(
                title: '有效使用期',
                mTextEditingController: _validDateTextEditingController,
                isenabled: false,
                isPassword: false, 
                maxLine: 1, 
                minLine: 1,
              ),
            ),
          ),

          widget.editModel == false ? Container() :
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent
              ),
              onPressed: () => _delCoupon(widget.couponModel.docId), 
              child: const Text('刪除')
            ),
          ),

          widget.editModel == false ? Container() :
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Center(
              child: Text(
                '此優惠碼於 ${
                  DateFormat('yyyy年MM月dd日').format(DateTime.fromMicrosecondsSinceEpoch(widget.couponModel.createDate.microsecondsSinceEpoch))
                } 建立',
                style: const TextStyle(color: Colors.grey),
              )
            ),
          )

        ],
      ),
    );
  }

  Expanded _buildPriceTextFiled(String title, TextEditingController controller, TextEditingController anotherCotroller){
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
              onChanged: (value) {
                anotherCotroller.text = '0.00';
              },
            ),
          ],
        ),
      ),
    );
  }

  Expanded _buildPercentageTextFiled(String title, TextEditingController controller, TextEditingController anotherCotroller){
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
                suffixText: '%',
                contentPadding: EdgeInsets.all(0),
                isDense: true,
                border: InputBorder.none
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CurrencyFormatter(4)
              ],
              onChanged: (value) {
                anotherCotroller.text = '0.00';
              },
            ),
          ],
        ),
      ),
    );
  }
  
}