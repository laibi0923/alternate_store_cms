import 'package:alternate_store_cms/screen/order/order_details.dart';
import 'package:alternate_store_cms/screen/order/order_itemviews.dart';
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

  final List<OrderReceiveModel> _searchList = [];
  final TextEditingController _searchTextController = TextEditingController();
  late int _searchResultCounter = 0;

  void _searchProduct(String val, List<OrderReceiveModel> list){
    setState(() {
      _searchList.clear();
      _searchResultCounter = 0;
      if(val.isNotEmpty) {
        for(int i = 0; i < list.length; i++){
          if(list[i].orderNumber.toUpperCase().contains(val.toUpperCase())){
            _searchList.add(list[i]);
            _searchResultCounter = _searchList.length;
          } 
        }
      }  
    });
  }
  
  @override
  Widget build(BuildContext context) {

    final _dbOrderReceiveList = Provider.of<List<OrderReceiveModel>>(context);

    return Scaffold(
      backgroundColor: const Color(backgroundDark),
      appBar: _buildSearchAppBar(context, _dbOrderReceiveList),
      // ignore: unnecessary_null_comparison
      body: Column(
        children: [
          _searchResultCounter == 0 ? Container() :
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              '共找到 $_searchResultCounter 筆相關資料',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: _searchTextController.text.isNotEmpty || _searchList.isNotEmpty ?
            _orderListView(_searchList) :
            _orderListView(_dbOrderReceiveList)
          )
        ],
      )
    );
  }

  AppBar _buildSearchAppBar(BuildContext context, List<OrderReceiveModel> list){
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
                controller: _searchTextController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(0),
                  isDense: true,
                  hintText: '訂單編號捜尋'
                ),
                onChanged: (val) => _searchProduct(val, list),
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
  
  Widget _orderListView(List<OrderReceiveModel> list){

    // ignore: unnecessary_null_comparison
    if(list == null){
      return const Center(
        child: CircularProgressIndicator(color: Colors.grey),
      );
    }

    if(list.isEmpty){
      return const Center(
        child: Text(
          '找不到捜尋結果',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: list.length,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 150),
      itemBuilder: (context, index){
        return GestureDetector(
          onTap: () async { 
            bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ReceiveDetails(
              reference: list[index].ref, 
              docId: list[index].docId,
              status: list[index].isComplete
            )));

            if(result == true){
              _searchTextController.clear();
              _searchList.clear();
              _searchResultCounter = 0;
            }

          },
          child: OrderItemView(orderReceiveModel: list[index])
        );
      }
    );

  }

}