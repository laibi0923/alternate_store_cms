import 'package:alternate_store_cms/constants.dart';
import 'package:alternate_store_cms/currency_textview.dart';
import 'package:alternate_store_cms/model/orderreceive_model.dart';
import 'package:alternate_store_cms/screen/category/catergory_listview.dart';
import 'package:alternate_store_cms/screen/coupon/coupon_controller.dart';
import 'package:alternate_store_cms/screen/member/member_listview.dart';
import 'package:alternate_store_cms/screen/order/order_itemviews.dart';
import 'package:alternate_store_cms/screen/order/order_listview.dart';
import 'package:alternate_store_cms/screen/order/receive_details.dart';
import 'package:alternate_store_cms/screen/policy/private_policy.dart';
import 'package:alternate_store_cms/screen/policy/return_policy.dart';
import 'package:alternate_store_cms/screen/proudct/product_listview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HomeWapper extends StatelessWidget {
  const HomeWapper({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(backgroundDark),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: const [
            Icon(
              Icons.menu, 
              color: Colors.white
            ),
            Spacer(),
            Icon(
              Icons.settings, 
              color: Colors.white,
            )
          ],
        )
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          _customHeader(context),
          _functionButton(context),
          _orderListView(context),
        ],
      )
    );
  }
}

Widget _customHeader(BuildContext context){

  final orderReceiveModel = Provider.of<List<OrderReceiveModel>>(context);
  
  double turnover = 0;
  DateTime now = DateTime.now();
  final formatter = NumberFormat("###,###,###,##0", "en");

  if(orderReceiveModel != null){
    for(int i = 0; i < orderReceiveModel.length; i++){
      if(
        orderReceiveModel[i].orderDate.toDate().year == now.year &&
        orderReceiveModel[i].orderDate.toDate().month == now.month &&
        orderReceiveModel[i].orderDate.toDate().day == now.day
      ){
        turnover = turnover + orderReceiveModel[i].xtotalAmount;
      }
    }
  }

  return SizedBox(
    height: 100,
    child: Center(
      child: Column(
        children: [
          const Text(
            '本日收益',
            style: TextStyle(color: Colors.greenAccent, fontSize: 18)
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'HKD\$${formatter.format(int.parse(turnover.toStringAsFixed(0)))}.',
                style: const TextStyle(fontSize: 30, color: Colors.greenAccent)
              ),
              Text(
                turnover.toStringAsFixed(2).substring(
                  turnover.toStringAsFixed(2).length - 2, 
                  turnover.toStringAsFixed(2).length
                ),
                style: const TextStyle(fontSize: 20, color: Colors.greenAccent)
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _functionButton(BuildContext context){

  var size = MediaQuery.of(context).size;
  const double itemHeight = 250;
  final double itemWidth = size.width / 2;

  return Container(
    decoration: BoxDecoration(
      color: const Color(primaryDark),
      borderRadius: BorderRadius.circular(7)
    ),
    margin: const EdgeInsets.only(left: 20, right: 20),
    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
    child: GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: (itemWidth / itemHeight)
      ),
      children: [
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductListView())),
          child: _functionButtonItemView(
            const Icon(Icons.widgets, size: 30,), 
            '商品管理'
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CatergoryListView(selectOpen: false, selectedList: [],))),
          child: _functionButtonItemView(
            const Icon(Icons.category_outlined, size: 30,), 
            '類別管理'
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CouponController())),
          child: _functionButtonItemView(
            const Icon(Icons.card_giftcard, size: 30,), 
            '優惠代碼'
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderListView())),
          child: _functionButtonItemView(
            const Icon(Icons.inbox_rounded, size: 30,), 
            '訂單查詢'
          ),
        ),

        GestureDetector(
          onTap: (){},
          child: _functionButtonItemView(
            const Icon(Icons.outbox_rounded, size: 30,), 
            '退貨管理'
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MemberListView())),
          child: _functionButtonItemView(
            const Icon(Icons.person, size: 30,), 
            '會員系統'
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivatePolicy())),
          child: _functionButtonItemView(
            const Icon(Icons.admin_panel_settings_outlined, size: 30,), 
            '私人政策'
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReturnPolicy())),
          child: _functionButtonItemView(
            const Icon(Icons.admin_panel_settings_outlined, size: 30,), 
            '退貨政策'
          ),
        ),

      ],
    ),
  );
}

Widget _functionButtonItemView(Icon icon, String title){
  return Column(
    children: [
      Expanded(
        child: icon,
      ),
      Text(title)
    ],
  );
}

Widget _orderListView(BuildContext context){

  final orderReceiveModel = Provider.of<List<OrderReceiveModel>>(context);
  
  return Padding(
    padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '最新訂單',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
        ),
        orderReceiveModel == null ?  Container() :
        ListView.builder(
          shrinkWrap: true,
          itemCount: orderReceiveModel.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index){
            return orderReceiveModel[index].isComplete == true ? Container() :
            GestureDetector(
              onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => ReceiveDetails(
                  reference: orderReceiveModel[index].ref,
                  docId: orderReceiveModel[index].docId
                )
              )),
              child: OrderItemView(orderReceiveModel: orderReceiveModel[index]),
            );
          }
        )
      ],
    ),
  );
}