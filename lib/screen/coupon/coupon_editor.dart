import 'package:asher_store_cms/constants.dart';
import 'package:asher_store_cms/controller/couponeditor_controller.dart';
import 'package:asher_store_cms/currency_formatter.dart';
import 'package:asher_store_cms/customize_textfield.dart';
import 'package:asher_store_cms/model/coupon_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CouponEditor extends StatelessWidget {
  final CouponModel? couponModel;
  const CouponEditor({ Key? key, this.couponModel }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _contorller = Get.put(CouponEditorController());
    if(couponModel != null){
      _contorller.setupCouponData(couponModel!);
    }

    return  Obx((){
      return Scaffold(
        backgroundColor: const Color(backgroundDark),
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [

              GestureDetector(
                onTap: () => _contorller.uploadCoupon(couponModel),
                child: const Icon(Icons.upload, color: Colors.grey)
              ),

              Expanded(
                child: Center(
                  child: Text(couponModel == null ? "新增優惠碼" : "修改優惠碼") 
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
                mTextEditingController: _contorller.couponCodeTextEditingController,
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
                    _contorller.couponPriceTextEditingController,
                    _contorller.couponPercentageTextEditingController
                  ),

                  Container(
                    width: 20,
                  ),

                  _buildPercentageTextFiled(
                    '百分比扣減(%OFF)',
                    _contorller.couponPercentageTextEditingController,
                    _contorller.couponPriceTextEditingController
                  ),
                  
                ],
              ),
            ),

            //  優惠代碼說明
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: CustomizeTextField(
                title: '優惠代碼說明',
                mTextEditingController: _contorller.remarkTextEditingController,
                minLine: 4,
                isenabled: true, 
                isPassword: false, 
                maxLine: 4, 
              ),
            ),

            //  優惠限期
            GestureDetector(
              onTap: () => _contorller.setUnLimited(),
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
                    _contorller.unLimited.isTrue ? const Text('無限期') : const Text('有限期', style: TextStyle(color: Colors.redAccent),)
                  ],
                )
              ),
            ),

            //  有效使用期至
            _contorller.unLimited.isTrue ? Container() :
            GestureDetector(
              onTap: () => _contorller.pickValidDate(),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: CustomizeTextField(
                  title: '有效使用期',
                  mTextEditingController: _contorller.validDateTextEditingController,
                  isenabled: false,
                  isPassword: false, 
                  maxLine: 1, 
                  minLine: 1,
                ),
              ),
            ),

            couponModel == null ? Container() :
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.redAccent
                ),
                onPressed: () => _contorller.delCoupon(couponModel!), 
                child: const Text('刪除')
              ),
            ),

            couponModel == null ? Container() :
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Center(
                child: Text(
                  '此優惠碼於 ${
                    DateFormat('yyyy年MM月dd日').format(DateTime.fromMicrosecondsSinceEpoch(couponModel!.createDate.microsecondsSinceEpoch))
                  } 建立',
                  style: const TextStyle(color: Colors.grey),
                )
              ),
            )

          ],
        ),
      );
    });
    
  }

  Expanded _buildPriceTextFiled(String title, TextEditingController controller, TextEditingController anotherCotroller){
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