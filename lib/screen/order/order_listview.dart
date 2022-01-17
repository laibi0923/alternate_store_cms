import 'package:asher_store_cms/constants.dart';
import 'package:asher_store_cms/controller/orderlistview_controller.dart';
import 'package:asher_store_cms/screen/order/order_itemviews.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderListView extends StatelessWidget {
  const OrderListView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _controller = Get.find<OrderListViewController>();

    return Obx((){
      return Scaffold(
        backgroundColor: const Color(backgroundDark),
        appBar: AppBar(
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
                    controller: _controller.searchTextController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(0),
                      isDense: true,
                      hintText: '訂單編號捜尋'
                    ),
                    onSubmitted: (val) => _controller.searchOrder(val),
                    onChanged: (val) => _controller.clearSearchData(val)
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
        ),
        body: _controller.searchResultList.isEmpty && _controller.searchTextController.text.isNotEmpty ? 
        const Center(
          child: Text(
            '找不到捜尋結果',
            style: TextStyle(color: Colors.grey),
          ),
        ) :
        ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 80),
          itemCount: _controller.searchResultList.isNotEmpty ? _controller.searchResultList.length : _controller.orderlist.length,
          itemBuilder: (context, index){
            return OrderItemView(
              orderReceiveModel : _controller.searchResultList.isNotEmpty ?
              _controller.searchResultList[index] :
              _controller.orderlist[index]
            );
          }
        ),
      );
    });
  }

}