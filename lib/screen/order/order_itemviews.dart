import 'package:asher_store_cms/constants.dart';
import 'package:asher_store_cms/controller/orderlistview_controller.dart';
import 'package:asher_store_cms/model/order_model.dart';
import 'package:asher_store_cms/model/orderreceive_model.dart';
import 'package:asher_store_cms/screen/order/order_details.dart';
import 'package:asher_store_cms/widget/currency_textview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderItemView extends StatelessWidget {
  final OrderReceiveModel orderReceiveModel;
  const OrderItemView({ Key? key, required this.orderReceiveModel }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _controller = Get.find<OrderListViewController>();

    return StreamBuilder<DocumentSnapshot>(
      stream: orderReceiveModel.ref.snapshots(),
      builder: (context, snapshots){

        if(snapshots.data == null){
          return Container();
        } else {
          
          OrderModel _orderModel = OrderModel.fromDocumentSnapshot(snapshots.data!, snapshots.data!.id);

          return GestureDetector(
            onTap: () => Get.to(() => OrderDetails(orderModel: _orderModel, orderReceiveModel: orderReceiveModel)),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(primaryDark),
                borderRadius: BorderRadius.circular(7)
              ),
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 10, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        '訂單摘要',
                        style: TextStyle(fontSize: 18),
                      ),
                      orderReceiveModel.isComplete == true ? 
                      const Text('') : 
                      const Text(
                        '  (未完成)',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      const Spacer(),
                      Text(
                        DateFormat('yyyy/MM/dd  kk:mm').format(DateTime.fromMicrosecondsSinceEpoch(orderReceiveModel.orderDate.microsecondsSinceEpoch)),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  Container(height: 20,),
                  Text(
                    '訂單編號 ${orderReceiveModel.orderNumber}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _controller.combineProductName(_orderModel),
                          style: const TextStyle(color: Colors.grey),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                      ),
                      Container(height: 20,),
                      const Divider(color: Colors.grey),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              '總計',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                            )
                          ),
                          CurrencyTextView(
                            value: _orderModel.totalAmount!, 
                            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        }
      }
    );
  }
}