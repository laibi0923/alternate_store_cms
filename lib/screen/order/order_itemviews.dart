// ignore: file_names
import 'package:alternate_store_cms/constants.dart';
import 'package:alternate_store_cms/currency_textview.dart';
import 'package:alternate_store_cms/model/orderreceive_model.dart';
import 'package:alternate_store_cms/screen/order/order_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderItemView extends StatelessWidget {
  final OrderReceiveModel orderReceiveModel;
  const OrderItemView({Key? key, required this.orderReceiveModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReceiveDetails(
          reference: orderReceiveModel.ref, 
          docId: orderReceiveModel.docId,
          status: orderReceiveModel.isComplete
        )
      )),
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
            StreamBuilder(
              stream: orderReceiveModel.ref.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshots){
                
                var arrayProductName = [];

                if(snapshots.data == null) { return Container(); }

                for(int i = 0; i < snapshots.data['ORDER_PRODUCT'].length; i++){
                  arrayProductName.add(snapshots.data!['ORDER_PRODUCT'][i]['PRODUCT_NAME']);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      arrayProductName.toString().replaceAll('[', '').replaceAll(']', ''),
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
                          value: snapshots.data!['TOTAL_AMOUNT'], 
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                        ),
                      ],
                    )
                  ],
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}