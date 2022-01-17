import 'package:asher_store_cms/constants.dart';
import 'package:asher_store_cms/controller/couponlistview_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class CouponListView extends StatelessWidget {
  const CouponListView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _couponListViewController = Get.put(CouponListViewController());

    return Obx((){
      return Scaffold(
        backgroundColor: const Color(backgroundDark),
        appBar: _buildSearchAppBar(),
        floatingActionButton: FloatingActionButton(
        onPressed: () => _couponListViewController.addCoupon(),
        child: const Icon(Icons.add, color: Colors.grey),
        backgroundColor: const Color(primaryDark),
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: _couponListViewController.searchList.isEmpty && _couponListViewController.searchTextController.text.isNotEmpty ?
        const Center(
          child: Text(
            '找不到捜尋結果',
            style: TextStyle(color: Colors.grey),
          ),
        ) :
        _couponListView(
          _couponListViewController.searchList.isEmpty ? 
          _couponListViewController.couponlist : 
          _couponListViewController.searchList
        )
      );
    });
  }

  Widget _couponListView(List list){

    final _couponListViewController = Get.find<CouponListViewController>();

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 15, right: 15),
      itemCount: list.length,
      itemBuilder: (context, index){
        return GestureDetector(
          onTap: () => _couponListViewController.editCoupon(_couponListViewController.couponlist[index]),
          child: Container(
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
                  child: list[index].percentage !=0 ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${list[index].percentage.toStringAsFixed(0)}%'),
                      const Text('OFF'),
                    ],
                  ) : 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('全單扣減'),
                      Text('\$${list[index].discountAmount.toStringAsFixed(2)}'),
                    ],
                  ) ,
                ),
                Container(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '建立日期 : ${ 
                        DateFormat('yyyy/MM/dd  kk:mm').format(DateTime.fromMicrosecondsSinceEpoch(list[index].createDate.microsecondsSinceEpoch))
                      }',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(
                      '折扣代碼: ${list[index].couponCode}',
                    ),
                    const Spacer(),
                    list[index].unLimited == false ? 
                    Text(
                      '使用限期: ${ 
                        DateFormat('yyyy/MM/dd').format(DateTime.fromMicrosecondsSinceEpoch(list[index].validDate.microsecondsSinceEpoch))
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
          ),
        );
      }
    );
  }

  AppBar _buildSearchAppBar(){

    final _couponListViewController = Get.find<CouponListViewController>();

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
                controller: _couponListViewController.searchTextController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(0),
                  isDense: true,
                  hintText: '優惠碼捜尋'
                ),
                onSubmitted: (val) => _couponListViewController.searchCoupon(val),
                onChanged: (val) => _couponListViewController.clearCoupon(val),
                // onChanged: (val) => _searchCoupon(val, list),
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

}