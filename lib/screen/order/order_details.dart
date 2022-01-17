import 'package:asher_store_cms/constants.dart';
import 'package:asher_store_cms/controller/orderdetails_controller.dart';
import 'package:asher_store_cms/model/order_model.dart';
import 'package:asher_store_cms/model/orderreceive_model.dart';
import 'package:asher_store_cms/widget/cart_summary_itemview.dart';
import 'package:asher_store_cms/widget/currency_textview.dart';
import 'package:asher_store_cms/widget/custom_cachednetworkimage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderDetails extends StatelessWidget {
  final OrderReceiveModel orderReceiveModel;
  final OrderModel orderModel;
  const OrderDetails({ Key? key, required this.orderModel, required this.orderReceiveModel }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _controller = Get.put(OrderDetailsController());
    
    return Scaffold(
      backgroundColor: const Color(backgroundDark),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Spacer(),
            IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.close, color: Colors.white)
            )
          ],
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 15, right: 15),
        children: [
          _buildOrderHeader(orderReceiveModel.orderDate, orderReceiveModel.orderNumber),

          _buildRecipientInfo(orderModel),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderModel.orderProduct!.length,
            padding: const EdgeInsets.only(top: 20),
            itemBuilder: (context, index){
              return GestureDetector(
                onTap: () => _controller.onShipping(index, orderModel.orderProduct!, orderReceiveModel),
                child: _buildProductItemView(orderModel.orderProduct![index]),
              );
            },
          ),

          _buildSummary(orderModel),

          Container(height: 30),

          orderReceiveModel.isComplete == true ? Container() :
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.greenAccent
            ),
            onPressed: () => _controller.shippingAll(context, orderModel.orderProduct!, orderReceiveModel),
            child: const Text('一鍵出貨')
          ),

          Container(height: 80),

        ],
      )
    );
  }

  Container _buildOrderHeader(Timestamp orderDate, String orderNumber){
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: const Color(primaryDark),
        borderRadius: BorderRadius.circular(7)
      ),
      child: Column(
        children: [

          CartSummaryItemView(
            title: '訂單日期', 
            value: DateFormat('yyyy/MM/dd  kk:mm').format(
              DateTime.fromMicrosecondsSinceEpoch(orderDate.microsecondsSinceEpoch)
            ), 
            isbold: false, 
            showAddBox: false
          ),

          CartSummaryItemView(
            title: '訂單編號', 
            value: orderNumber, 
            isbold: false, 
            showAddBox: false
          ),
          
        ],
      ),
    );
  }

  Container _buildRecipientInfo(OrderModel orderModel){
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: const Color(primaryDark),
        borderRadius: BorderRadius.circular(7)
      ),
      child: Column(
        children: [
          CartSummaryItemView(
            title: '收件人名稱', 
            value: orderModel.receipientInfo!['RECEIPIENT_NAME'],
            isbold: false, 
            showAddBox: false
          ),

          CartSummaryItemView(
            title: '聯絡電話', 
            value: orderModel.receipientInfo!['CONTACT'],
            isbold: false, 
            showAddBox: false
          ),
          
          CartSummaryItemView(
            title: '運送地址', 
            value: '${orderModel.receipientInfo!['UNIT_AND_BUILDING']}\n${orderModel.receipientInfo!['ESTATE']}\n${orderModel.receipientInfo!['DISTRICT']}', 
            isbold: false, 
            showAddBox: false
          ),
        ],
      ),
    );
  } 

  Container _buildProductItemView(orderProductData){
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: const BoxDecoration(
        color: Color(primaryDark),
        borderRadius: BorderRadius.all(Radius.circular(7))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              const Expanded(
                child: Text('貨品編號')
              ),
              Text(
                orderProductData['PRODUCT_NO'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          Container(
            height: 110,
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(7))
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                //  Product Image
                Container(
                  height: 110,
                  width: 110,
                  margin: const EdgeInsets.only(right: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: cachedNetworkImage(
                      orderProductData['PRODUCT_IMAGE'],
                      BoxFit.cover
                    )
                  ),
                ),
                
                //  Product Name / Refund
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      //  Product Name
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          orderProductData['PRODUCT_NAME'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      const Spacer(),

                      //  Refund
                      orderProductData['REFUND_ABLE'] == true ? Container() :
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          refundableText,
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),


                      // Product Color / Size / Price
                      Row(
                        children: [
                          // Product Color
                          Text(
                            orderProductData['COLOR_NAME'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        
                          const Text(
                            "  |  ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          //  Product Size
                          Text(
                            orderProductData['SIZE'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          // Prouct Price
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children:  [
                                
                                // 判斷如商品冇特價時不顯示, 相反則顥示正價 (刪除線)
                                orderProductData['DISCOUNT'] == 0 ? Container() :
                                CurrencyTextView(
                                  value: double.parse(orderProductData['PRICE'].toString()), 
                                  textStyle: const TextStyle(
                                    fontSize: 11,
                                    decoration: TextDecoration.lineThrough
                                  )
                                ),
                                
                                //  判斷如商品冇特價時顯示正價, 相反以紅色顯示特價銀碼
                                orderProductData['DISCOUNT'] != 0 ?
                                CurrencyTextView(
                                  value: double.parse(orderProductData['DISCOUNT'].toString()), 
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.redAccent
                                  )
                                ) :
                                CurrencyTextView(
                                  value: double.parse(orderProductData['PRICE'].toString()), 
                                  textStyle: const TextStyle()
                                )
                        
                              ],
                            ),
                          ),

                        ],
                      ),
                      
                    ],
                  )
                ),

              ],
            ),
          ),

          Row(
            children: [
              const Expanded(
                child: Text('出貨狀況')
              ),
              orderProductData['SHIPPING_STATUS'].isNotEmpty ? 
              Text(
                orderProductData['SHIPPING_STATUS'],
                style: const TextStyle(color: Colors.greenAccent),
              ) : 
              const Text(
                '未出貨',
                style: TextStyle(color: Colors.redAccent),
              )
            ],
          ),

          Row(
            children: [
              const Expanded(
                child: Text('出貨日期')
              ),
              orderProductData['SHIPPING_DATE'] == null ? 
              const Text(
                '-',
              ) : 
              Text(
                DateFormat('yyyy/MM/dd  kk:mm').format(
                  DateTime.fromMicrosecondsSinceEpoch(orderProductData['SHIPPING_DATE'].microsecondsSinceEpoch)
                )
              )
            ],
          ),
        ],
      ),
    );
  }

  Column _buildSummary(OrderModel orderModel){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        CartSummaryItemView(
          title: '小計', 
          value: 'HKD\$ ${orderModel.subAmount!.toStringAsFixed(2)}', 
          isbold: false, 
          showAddBox: false
        ),

        CartSummaryItemView(
          title: '折扣', 
          value: '-HKD\$ ' + orderModel.discountAmount!.toStringAsFixed(2),
          isbold: false,
          showAddBox: false,
        ),

        orderModel.discountCode!.isEmpty ? Container() :
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: [
              Text(
                '優惠代碼【${orderModel.discountCode}】  ', 
                style: const TextStyle(color: Colors.grey)
              ),
            ],
          ),
        ),

        CartSummaryItemView(
          title: '運費', 
          value: 'HKD\$ ${orderModel.shippingAmount!.toStringAsFixed(2)}', 
          isbold: false, 
          showAddBox: false
        ),

        CartSummaryItemView(
          title: '總計', 
          value: 'HKD\$ ${orderModel.totalAmount!.toStringAsFixed(2)}', 
          isbold: true, 
          showAddBox: false
        ),

        CartSummaryItemView(
          title: '支付方式', 
          value: orderModel.paymentMothed!, 
          isbold: false, 
          showAddBox: false
        ),

      ],
    );

  }
}