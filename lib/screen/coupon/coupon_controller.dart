import 'package:alternate_store_cms/screen/coupon/coupon_editor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:alternate_store_cms/constants.dart';
import 'package:alternate_store_cms/model/coupon_model.dart';
import 'package:alternate_store_cms/service/coupon_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CouponController extends StatefulWidget {
  const CouponController({ Key? key }) : super(key: key);

  @override
  _CouponControllerState createState() => _CouponControllerState();
}

class _CouponControllerState extends State<CouponController> {

  void _searchItem() {}

  void _editCoupon(CouponModel couponModel) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CouponEditor(editModel: true, couponModel: couponModel,)));
  }

  void _addCoupon() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CouponEditor(editModel: false, couponModel: CouponModel.initialData(),)));
  }

  void _delCoupon(String docId) {
    CouponService().delCoupon(docId);
  }

  @override
  Widget build(BuildContext context) {

    final couponData = Provider.of<List<CouponModel>>(context);

    // ignore: unnecessary_null_comparison
    if(couponData == null) {
      return Container();
    }

    return Scaffold(
      backgroundColor: const Color(backgroundDark),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addCoupon(),
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
                    onTap: () => Navigator.pop(context),
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
                        hintText: '搜尋優惠代碼',
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
          itemCount: couponData.length,
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index){
            return GestureDetector(
              onTap: () => _editCoupon(couponData[index]),
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Row(
                  children: [
            
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '建立日期 : ${ 
                              DateFormat('yyyy/MM/dd  kk:mm').format(DateTime.fromMicrosecondsSinceEpoch(couponData[index].createDate.microsecondsSinceEpoch))
                            }',
                            style: const TextStyle(color: Colors.grey),
                          ),

                          Text(
                            '優惠碼 : ${couponData[index].couponCode}',
                            style: const TextStyle(fontSize: 14),
                          ),

                          couponData[index].percentage != 0 ?
                          Text('全單折扣 ${couponData[index].percentage} %'):
                          Text('全單折扣 HKD\$ ${couponData[index].discountAmount}'),

                          couponData[index].unLimited == true ? 
                          const Text('使用限期 : 無限期') :
                          Text('使用限期 : ${
                            DateFormat('yyyy/MM/dd').format(DateTime.fromMicrosecondsSinceEpoch(couponData[index].validDate.microsecondsSinceEpoch))
                          }'),

                        ],
                      )
                    ),
            
                    Column(
                      children: [
                        
                        couponData[index].unLimited == true ?
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text('有效', style: TextStyle(color: Colors.grey),) 
                        ) :
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: couponData[index].validDate.millisecondsSinceEpoch > Timestamp.now().millisecondsSinceEpoch?
                          const Text('有效', style: TextStyle(color: Colors.grey),) : 
                          const Text('已失效', style: TextStyle(color: Colors.redAccent),),
                        ),
                        GestureDetector(
                          onTap: () => _delCoupon(couponData[index].docId),
                          child: delButton()
                        ),
                      ],
                    ),

            
                  ],
                ),
              ),
            );
          }
        )
      )
    );
  }

}


Widget delButton(){
  return Container(
  padding: const EdgeInsets.all(8),
    margin: const EdgeInsets.only(left: 10, right: 10),
    decoration: BoxDecoration(
      //color: const Color(primaryDark),
      color: Colors.redAccent,
      borderRadius: BorderRadius.circular(999)
    ),
    child: const Icon(Icons.delete, color: Color(backgroundDark)),
  );
}