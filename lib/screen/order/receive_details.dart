import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alternate_store_cms/cart_summary_itemview.dart';
import 'package:alternate_store_cms/comfirmation_dialog.dart';
import 'package:alternate_store_cms/constants.dart';
import 'package:intl/intl.dart';
import 'package:alternate_store_cms/service/product_database.dart';
import 'package:alternate_store_cms/custom_cachednetworkimage.dart';

class ReceiveDetails extends StatelessWidget {
  final DocumentReference reference;
  final String docId;
  const ReceiveDetails({ Key? key, required this.reference, required this.docId }) : super(key: key);

  Future<void> _onShipping(BuildContext context, int index, List dataList) async {

    if(dataList[index]['SHIPPING_STATUS'] == false){
      bool dialogResult = await showDialog(
        context: context, 
        builder: (BuildContext context){
          return comfirmationDialog(
            context,
            '出貨確定',
            "確定將 ${dataList[index]['PRODUCT_NAME']} 發貨?",
            '確定',
            '取消',
          );
        }
      );

      if(dialogResult == true){
        List newDataList  = dataList;

        newDataList[index].remove('SHIPPING_STATUS');
        newDataList[index].addAll({
          'SHIPPING_STATUS' : true,
          'SHIPPING_DATE' : Timestamp.now()
        });

        reference.update({
          'ORDER_PRODUCT' : newDataList
        });

        ProductDatabase().soldProduct(dataList[index]['SKU']);

        //  判斷每項出貨狀態 = True總和如相等於貨品數目, 則更新 Order ISCOMPLETE
        int isCompleteProduct = 0;
        for (var element in dataList) {
          if(element['SHIPPING_STATUS'] == true){
            isCompleteProduct++;
          }
        }

        if(isCompleteProduct == dataList.length){
          DocumentReference ref = FirebaseFirestore.instance.collection('order').doc(docId);
          ref.update({
            'ISCOMPLETE' : true
          });
        }

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(backgroundDark),
      appBar: AppBar(
        elevation: 0,

      ),
      body: StreamBuilder(
        stream: reference.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
          return snapshot.data == null ? Container() :
          Stack(
            children: [

              ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 20, right: 20),
                children: [

                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      '訂單#${snapshot.data['ORDER_NUMBER']}',
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),

                  _buildOrderHeader(
                    snapshot.data['ORDER_DATE'],
                    snapshot.data['ORDER_NUMBER']
                  ),

                  _buildRecipientInfo(
                    snapshot.data['RECIPIENT_INFO']['RECEIPIENT_NAME'],
                    snapshot.data['RECIPIENT_INFO']['CONTACT'],
                    snapshot.data['RECIPIENT_INFO']['UNIT_AND_BUILDING'],
                    snapshot.data['RECIPIENT_INFO']['ESTATE'],
                    snapshot.data['RECIPIENT_INFO']['DISTRICT']
                  ),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data['ORDER_PRODUCT'].length,
                    padding: const EdgeInsets.only(top: 20),
                    itemBuilder: (context, index){
                      return GestureDetector(
                        onTap: () => _onShipping(context, index, snapshot.data['ORDER_PRODUCT']),
                        child: _buildProductItemView(snapshot.data['ORDER_PRODUCT'][index]),
                      );
                    },
                  ),

                  _buildSummary(
                    snapshot.data['SUB_AMOUNT'], 
                    snapshot.data['DISCOUNT_CODE'], 
                    snapshot.data['DISCOUNT_AMOUNT'], 
                    snapshot.data['SHIPPING_FREE'], 
                    snapshot.data['TOTAL_AMOUNT'], 
                    snapshot.data['PAYMENT_METHOD']
                  ),
   
                  Container(height: 80,),
                ]
              ),

              Positioned(
                top: 15,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: const Color(backgroundDark),
                      borderRadius: BorderRadius.circular(999)
                    ),
                    child: const Icon(Icons.close, color: Colors.grey,)
                  )
                ),
              )
            
            ],
          );
        },
      ),
    );
  }
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

Container _buildRecipientInfo(String name, String phone, String building, String estate, String district){
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
          value: name,
          isbold: false, 
          showAddBox: false
        ),

        CartSummaryItemView(
          title: '聯絡電話', 
          value: phone, 
          isbold: false, 
          showAddBox: false
        ),
        
        CartSummaryItemView(
          title: '運送地址', 
          value: '$building\n$estate\n$district', 
          isbold: false, 
          showAddBox: false
        ),
      ],
    ),
  );
} 

Container _buildProductItemView(Map<String, dynamic> orderProductData){
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
                  child: cachedNetworkImage(orderProductData['PRODUCT_IMAGE'])
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
                    orderProductData['REFUND_ABLE'] == false ? Container() :
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
                        Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey
                            ),
                            borderRadius: BorderRadius.circular(999)
                          ),
                          margin: const EdgeInsets.only(right: 15),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: cachedNetworkImage(orderProductData['COLOR_IMAGE'])
                          ),
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
                              Text(
                                'HKD\$ ' + orderProductData['PRICE'].toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 11,
                                  decoration: TextDecoration.lineThrough
                                ),
                              ),
                              
                              //  判斷如商品冇特價時顯示正價, 相反以紅色顯示特價銀碼
                              orderProductData['DISCOUNT'] != 0 ?
                              Text(
                                'HKD\$ ' + orderProductData['DISCOUNT'].toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.redAccent
                                ),
                              ) :
                              Text(
                                'HKD\$ ' + orderProductData['PRICE'].toStringAsFixed(2),
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
            orderProductData['SHIPPING_STATUS'] == true ? 
            const Text(
              '已出貨',
              style: TextStyle(color: Colors.blueAccent),
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

Column _buildSummary(double subAmount, String discountCode, double discountAmount, double shippingFree, double totalAmount, String payMethod){
  return Column(
    children: [

      CartSummaryItemView(
        title: '小計', 
        value: 'HKD\$ $subAmount}', 
        isbold: false, 
        showAddBox: false
      ),

      CartSummaryItemView(
        title: discountCode == '' ? '折扣' : '折扣 【$discountCode】',
        value: '-HKD\$ $discountAmount', 
        isbold: false, 
        showAddBox: false
      ),

      CartSummaryItemView(
        title: '運費', 
        value: 'HKD\$ $shippingFree', 
        isbold: false, 
        showAddBox: false
      ),

      CartSummaryItemView(
        title: '總計', 
        value: 'HKD\$ $totalAmount', 
        isbold: true, 
        showAddBox: false
      ),

      CartSummaryItemView(
        title: '支付方式', 
        value: payMethod, 
        isbold: false, 
        showAddBox: false
      ),

    ],
  );
}