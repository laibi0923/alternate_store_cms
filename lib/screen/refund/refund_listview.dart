import 'package:asher_store_cms/constants.dart';
import 'package:asher_store_cms/controller/refundlistview_controller.dart';
import 'package:asher_store_cms/currency_textview.dart';
import 'package:asher_store_cms/custom_cachednetworkimage.dart';
import 'package:asher_store_cms/model/order_model.dart';
import 'package:asher_store_cms/model/order_product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RefundListView extends StatelessWidget {
  const RefundListView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _controller = Get.find<RefundListViewController>();
    
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
          shrinkWrap: true,
          itemCount: _controller.refundList.length,
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 80),
          itemBuilder: (context, index){
            
            return StreamBuilder<DocumentSnapshot>(
              stream: _controller.refundList[index].ref.snapshots(),
              builder: (context, snapshots){

                if(snapshots.data == null){
                  return const CircularProgressIndicator(color: Color(xMainColor),);
                }

                OrderModel _orderModel = OrderModel.fromDocumentSnapshot(snapshots.data!, snapshots.data!.id);

                for(int m = 0; m < _orderModel.orderProduct!.length; m ++){

                  OrderProductModel _orderProductModel = OrderProductModel.fromFirestore(_orderModel.orderProduct![m]);

                  if(_controller.refundList[index].orderProductNo == _orderProductModel.orderProductNo){

                    return Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(top: 5, bottom: 5),
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
                                child: Text('訂單編號')
                              ),
                              Text(
                                _controller.refundList[index].orderNumber,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              _orderProductModel.refundStatus == '退貨申請中' ?
                              Container(
                                padding: const EdgeInsets.only(left: 15, right: 15),
                                decoration: BoxDecoration(
                                  color: const Color(xMainColor),
                                  borderRadius: BorderRadius.circular(999)
                                ),
                                child: Text(_orderProductModel.refundStatus.toString())
                              ) :
                              Container(
                                padding: const EdgeInsets.only(left: 15, right: 15),
                                decoration: BoxDecoration(
                                  color: _orderProductModel.refundStatus == '已退貨' ? Colors.greenAccent : Colors.redAccent,
                                  borderRadius: BorderRadius.circular(999)
                                ),
                                child: Text(_orderProductModel.refundStatus.toString())
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
                                      Text(
                                        _orderProductModel.productNo!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),

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
                                                
                                                // 判斷如商品冇特價時不顯示, 相反則顥示正價 (刪除線)
                                                _orderProductModel.discount == 0 ? Container() :
                                                CurrencyTextView(
                                                  value: double.parse(_orderProductModel.price.toString()), 
                                                  textStyle: const TextStyle(
                                                    fontSize: 11,
                                                    decoration: TextDecoration.lineThrough
                                                  )
                                                ),
                                                
                                                //  判斷如商品冇特價時顯示正價, 相反以紅色顯示特價銀碼
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
                                child: Text('出貨日期')
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

                          Row(
                            children: [
                              const Expanded(
                                child: Text('退貨申請日期')
                              ),
                              Text(
                                DateFormat('yyyy/MM/dd  kk:mm').format(
                                  DateTime.fromMicrosecondsSinceEpoch(_controller.refundList[index].createDate.microsecondsSinceEpoch)
                                )
                              )
                            ],
                          ),

                          Row(
                            children: [
                              const Expanded(
                                child: Text('退貨日期')
                              ),
                              _orderProductModel.refundDate == null ? 
                              const Text(
                                '-',
                              ) : 
                              Text(
                                DateFormat('yyyy/MM/dd  kk:mm').format(
                                  DateTime.fromMicrosecondsSinceEpoch(_orderProductModel.refundDate!.microsecondsSinceEpoch)
                                )
                              )
                            ],
                          ),

                          _controller.refundList[index].isCompleted == true ? Container() :
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(xMainColor)
                                  ),
                                  onPressed: () => _controller.refundApproval(_orderModel.orderProduct!, m, _controller.refundList[index]), 
                                  child: const Text('APPROVAL')
                                ),
                              ),
                              Container(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.redAccent
                                  ),
                                  onPressed: () => _controller.refundReject(_orderModel.orderProduct!, m, _controller.refundList[index]), 
                                  child: const Text('REJECT')
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  }
                }
                
                return Container();

              }
            );
          
          }
        )
      );
    });
    
  }
}