import 'package:alternate_store_cms/screen/order/order_itemviews.dart';
import 'package:alternate_store_cms/screen/order/receive_details.dart';
import 'package:flutter/material.dart';
import 'package:alternate_store_cms/constants.dart';
import 'package:alternate_store_cms/model/orderreceive_model.dart';
import 'package:provider/provider.dart';

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
      appBar: _buildSearchAppBar(context),
      // ignore: unnecessary_null_comparison
      body: orderReceiveModel == null ? Container() :
      ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: orderReceiveModel.length,
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 150),
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

  AppBar _buildSearchAppBar(BuildContext context){
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
              onPressed: () => Navigator.pop(context), 
              icon: const Icon(
                Icons.arrow_back, 
                size: 20,
                color: Colors.white,
              )
            ),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(0),
                  isDense: true,
                  hintText: '訂單編號捜尋'
                ),
                onChanged: (val){},
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