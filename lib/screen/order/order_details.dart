import 'package:asher_store_cms/constants.dart';
import 'package:asher_store_cms/controller/orderdetails_controller.dart';
import 'package:asher_store_cms/model/order_model.dart';
import 'package:asher_store_cms/model/order_product_model.dart';
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
            child: const Text('????????????')
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
            title: '????????????', 
            value: DateFormat('yyyy/MM/dd  kk:mm').format(
              DateTime.fromMicrosecondsSinceEpoch(orderDate.microsecondsSinceEpoch)
            ), 
            isbold: false, 
            showAddBox: false
          ),

          CartSummaryItemView(
            title: '????????????', 
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
            title: '???????????????', 
            value: orderModel.receipientInfo!['RECEIPIENT_NAME'],
            isbold: false, 
            showAddBox: false
          ),

          CartSummaryItemView(
            title: '????????????', 
            value: orderModel.receipientInfo!['CONTACT'],
            isbold: false, 
            showAddBox: false
          ),
          
          CartSummaryItemView(
            title: '????????????', 
            value: '${orderModel.receipientInfo!['UNIT_AND_BUILDING']}\n${orderModel.receipientInfo!['ESTATE']}\n${orderModel.receipientInfo!['DISTRICT']}', 
            isbold: false, 
            showAddBox: false
          ),
        ],
      ),
    );
  } 

  Container _buildProductItemView(orderProductData1){

    OrderProductModel _orderProductModel = OrderProductModel.fromFirestore(orderProductData1);

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
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text('????????????'),
              ),
              Text(
                _orderProductModel.productNo!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color: _orderProductModel.shippingStatus == "" ? Colors.transparent : Colors.greenAccent,
                  borderRadius: BorderRadius.circular(999)
                ),
                child:  _orderProductModel.shippingStatus == "" ?
                const Text('?????????') :
                Text(_orderProductModel.shippingStatus.toString()),
              )

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
                      _orderProductModel.productImage!,
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
                          _orderProductModel.productName!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      const Spacer(),

                      //  Refund
                      _orderProductModel.refundAble == true ? Container() :
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
                            _orderProductModel.colorName!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        
                          const Text(
                            "  |  ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          //  Product Size
                          Text(
                            _orderProductModel.size!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          // Prouct Price
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children:  [
                                
                                // ????????????????????????????????????, ????????????????????? (?????????)
                                _orderProductModel.discount == 0 ? Container() :
                                CurrencyTextView(
                                  value: double.parse(_orderProductModel.price.toString()), 
                                  textStyle: const TextStyle(
                                    fontSize: 11,
                                    decoration: TextDecoration.lineThrough
                                  )
                                ),
                                
                                //  ???????????????????????????????????????, ?????????????????????????????????
                                _orderProductModel.discount != 0 ?
                                CurrencyTextView(
                                  value: double.parse(_orderProductModel.discount.toString()), 
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.redAccent
                                  )
                                ) :
                                CurrencyTextView(
                                  value: double.parse(_orderProductModel.price.toString()), 
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
                child: Text('????????????')
              ),
              _orderProductModel.shippingDate == null ? 
              const Text(
                '-',
              ) : 
              Text(
                DateFormat('yyyy/MM/dd  kk:mm').format(
                  DateTime.fromMicrosecondsSinceEpoch(_orderProductModel.shippingDate!.microsecondsSinceEpoch)
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
          title: '??????', 
          value: 'HKD\$ ${orderModel.subAmount!.toStringAsFixed(2)}', 
          isbold: false, 
          showAddBox: false
        ),

        CartSummaryItemView(
          title: '??????', 
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
                '???????????????${orderModel.discountCode}???  ', 
                style: const TextStyle(color: Colors.grey)
              ),
            ],
          ),
        ),

        CartSummaryItemView(
          title: '??????', 
          value: 'HKD\$ ${orderModel.shippingAmount!.toStringAsFixed(2)}', 
          isbold: false, 
          showAddBox: false
        ),

        CartSummaryItemView(
          title: '??????', 
          value: 'HKD\$ ${orderModel.totalAmount!.toStringAsFixed(2)}', 
          isbold: true, 
          showAddBox: false
        ),

        CartSummaryItemView(
          title: '????????????', 
          value: orderModel.paymentMothed!, 
          isbold: false, 
          showAddBox: false
        ),

      ],
    );

  }
}