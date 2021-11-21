import 'package:alternate_store_cms/screen/order/order_itemviews.dart';
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

    final orderReceiveModel = Provider.of<List<OrderReceiveModel>>(context);

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
      body: orderReceiveModel == null ? Container() :
      ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: orderReceiveModel.length,
        padding: const EdgeInsets.only(left: 20, right: 20),
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReceiveDetails(
                reference: orderReceiveModel[index].ref, 
                docId: orderReceiveModel[index].docId
              )
            )),
            child: OrderItemView(orderReceiveModel: orderReceiveModel[index]),
          );
        }
      ),
    );
  }

}