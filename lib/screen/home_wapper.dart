import 'package:alternate_store_cms/constants.dart';
import 'package:alternate_store_cms/model/orderreceive_model.dart';
import 'package:alternate_store_cms/screen/catergory_controller.dart';
import 'package:alternate_store_cms/screen/coupon_controller.dart';
import 'package:alternate_store_cms/screen/order/order_listview.dart';
import 'package:alternate_store_cms/screen/private_policy.dart';
import 'package:alternate_store_cms/screen/proudct/product_listview.dart';
import 'package:alternate_store_cms/screen/return_policy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        children: [
          customHeader(),
          functionButton(context),
          newOrderListView(context),
        ],
      )
    );
  }
}

Widget customHeader(){
  return SizedBox(
    height: 100,
    child: Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const[
          Text(
            'HKD\$ 9999.',
            style: TextStyle(fontSize: 30, color: Colors.greenAccent)
          ),
          Text(
            '99',
            style: TextStyle(fontSize: 20, color: Colors.greenAccent)
          ),
        ],
      ),
    ),
  );
}

Widget functionButton(BuildContext context){

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
          child: functionButtonItemView(
            const Icon(Icons.widgets), 
            '商品管理'
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CatergoryController(selectOpen: false, selectedList: [],))),
          child: functionButtonItemView(
            const Icon(Icons.category_outlined), 
            '類別管理'
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CouponController())),
          child: functionButtonItemView(
            const Icon(Icons.card_giftcard), 
            '優惠代碼'
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderListView())),
          child: functionButtonItemView(
            const Icon(Icons.inbox_rounded), 
            '訂單查詢'
          ),
        ),

        GestureDetector(
          onTap: (){},
          child: functionButtonItemView(
            const Icon(Icons.outbox_rounded), 
            '退貨管理'
          ),
        ),
        GestureDetector(
          onTap: (){},
          child: functionButtonItemView(
            const Icon(Icons.person), 
            '會員系統'
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivatePolicy())),
          child: functionButtonItemView(
            const Icon(Icons.admin_panel_settings_outlined), 
            '私人政策'
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReturnPolicy())),
          child: functionButtonItemView(
            const Icon(Icons.admin_panel_settings_outlined), 
            '退貨政策'
          ),
        ),

      ],
    ),
  );
}

Widget functionButtonItemView(Icon icon, String title){
  return Column(
    children: [
      Expanded(
        child: icon
      ),
      Text(title)
    ],
  );
}

Widget newOrderListView(BuildContext context){

  final orderReceiveData = Provider.of<List<OrderReceiveModel>>(context);
  
  return Padding(
    padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '最新訂單',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: orderReceiveData.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index){
            return orderReceiveData[index].isComplete != true ?
            neworderItemView() : Container();
          }
        )
      ],
    ),
  );
}

Widget neworderItemView(){
  return Container(
    decoration: BoxDecoration(
      color: const Color(primaryDark),
      borderRadius: BorderRadius.circular(7)
    ),
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.only(bottom: 10, top: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Expanded(
              child: Text('訂單日期 : ')
            ),
            Text('YYYY / MM / DD')
            // Text(
            //   DateFormat('yyyy/MM/dd  kk:mm').format(DateTime.fromMicrosecondsSinceEpoch(orderReceiveData[index].orderDate.microsecondsSinceEpoch))
            // ),
          ],
        ),
        Row(
          children: [
            const Expanded(
              child: Text('訂單編號 : ')
            ),
            // Text(orderReceiveData[index].orderNumber),
          ],
        ),
        Row(
          children: [
              const Expanded(
              child: Text('訂單狀態 : ')
            ),
            // orderReceiveData[index].isComplete == true ?
            // const Text(
            //   '已完成',
            //   style: TextStyle(color: Colors.blueAccent),
            // ) :
            const Text(
              '未完成',
              style: TextStyle(color: Colors.redAccent),
            ),
          ],
        ),
      ],
    ),
  );
}