import 'package:alternate_store_cms/constants.dart';
import 'package:alternate_store_cms/model/coupon_model.dart';
import 'package:alternate_store_cms/screen/coupon/coupon_editor.dart';
import 'package:alternate_store_cms/service/coupon_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CouponListView extends StatefulWidget {
  const CouponListView({ Key? key }) : super(key: key);

  @override
  _CouponListViewState createState() => _CouponListViewState();
}

class _CouponListViewState extends State<CouponListView> {

  void _editCoupon(CouponModel couponModel) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CouponEditor(editModel: true, couponModel: couponModel,)));
  }

  void _addCoupon() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CouponEditor(editModel: false, couponModel: CouponModel.initialData(),)));
  }

  
  
  @override
  Widget build(BuildContext context) {

    final _couponData = Provider.of<List<CouponModel>>(context);
    // ignore: unnecessary_null_comparison
    return Scaffold(
      backgroundColor: const Color(backgroundDark),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addCoupon(),
        child: const Icon(Icons.add, color: Colors.grey),
        backgroundColor: const Color(primaryDark),
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: _buildSearchAppBar(context),
      body: _couponData == null ? Container() :
      ListView.builder(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 150),
        itemCount: _couponData.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: () => _editCoupon(_couponData[index]),
            child: _couponItemView(_couponData[index])
          );
        }
      ),
    );
  }

  AppBar _buildSearchAppBar(BuildContext context){
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
                  hintText: '優惠碼捜尋'
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
  
  Widget _couponItemView(CouponModel couponModel){
    return Container(
      height: 80,
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            decoration: BoxDecoration(
              color: const Color(primaryDark),
              borderRadius: BorderRadius.circular(7)
            ),
            child: couponModel.percentage !=0 ?
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${couponModel.percentage.toStringAsFixed(0)}%'),
                const Text('OFF'),
              ],
            ) : 
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('全單扣減'),
                Text('\$${couponModel.discountAmount.toStringAsFixed(2)}'),
              ],
            ) ,
          ),
          Container(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '建立日期 : ${ 
                  DateFormat('yyyy/MM/dd  kk:mm').format(DateTime.fromMicrosecondsSinceEpoch(couponModel.createDate.microsecondsSinceEpoch))
                }',
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                '折扣代碼: ${couponModel.couponCode}',
              ),
              const Spacer(),
              couponModel.unLimited == false ? 
              Text(
                '使用限期: ${ 
                  DateFormat('yyyy/MM/dd').format(DateTime.fromMicrosecondsSinceEpoch(couponModel.validDate.microsecondsSinceEpoch))
                }',
                style: const TextStyle(color: Colors.grey),
              ) :
              const Text(
                '無限期',
                style: TextStyle(color: Colors.redAccent),
              ),
            ],
          ),
          const Spacer(),
          const Center(
            child: Icon(Icons.more_vert, color: Colors.grey)
          )
        ],
      ),
    );
  }

}