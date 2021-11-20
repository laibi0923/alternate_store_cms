import 'package:alternate_store_cms/screen/order/receive_details.dart';
import 'package:flutter/material.dart';
import 'package:alternate_store_cms/constants.dart';
import 'package:alternate_store_cms/model/orderreceive_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OrderListView extends StatefulWidget {
  const OrderListView({ Key? key }) : super(key: key);

  @override
  _OrderListViewState createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  @override
  Widget build(BuildContext context) {

    final orderReceiveData = Provider.of<List<OrderReceiveModel>>(context);

    return Scaffold(
      backgroundColor: const Color(backgroundDark),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('訂單接收'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.grey)
            ),
          )
        ],
      ),
      // ignore: unnecessary_null_comparison
      body: orderReceiveData == null ? Container() :
      ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: orderReceiveData.length,
        padding: const EdgeInsets.only(left: 20, right: 20),
        itemBuilder: (context, index){
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: const Color(primaryDark),
              borderRadius: BorderRadius.circular(7)
            ),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReceiveDetails(
                  reference: orderReceiveData[index].ref, 
                  docId: orderReceiveData[index].docId
                )
              )),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text('訂單日期 : ')
                        ),
                        Text(
                          DateFormat('yyyy/MM/dd  kk:mm').format(DateTime.fromMicrosecondsSinceEpoch(orderReceiveData[index].orderDate.microsecondsSinceEpoch))
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(
                          child: Text('訂單編號 : ')
                        ),
                        Text(orderReceiveData[index].orderNumber),
                      ],
                    ),
                    Row(
                      children: [
                         const Expanded(
                          child: Text('訂單狀態 : ')
                        ),
                        orderReceiveData[index].isComplete == true ?
                        const Text(
                          '已完成',
                          style: TextStyle(color: Colors.blueAccent),
                        ) :
                        const Text(
                          '未完成',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

}