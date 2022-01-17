import 'package:asher_store_cms/constants.dart';
import 'package:asher_store_cms/controller/auth_controller.dart';
import 'package:asher_store_cms/controller/orderlistview_controller.dart';
import 'package:asher_store_cms/screen/banner/banner_listview.dart';
import 'package:asher_store_cms/screen/category/catergory_listview.dart';
import 'package:asher_store_cms/screen/coupon/coupon_listview.dart';
import 'package:asher_store_cms/screen/member/member_listview.dart';
import 'package:asher_store_cms/screen/order/order_itemviews.dart';
import 'package:asher_store_cms/screen/order/order_listview.dart';
import 'package:asher_store_cms/screen/policy/private_policy.dart';
import 'package:asher_store_cms/screen/policy/refund_policy.dart';
import 'package:asher_store_cms/screen/proudct/product_listview.dart';
import 'package:asher_store_cms/screen/refund/refund_listview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DashBordPage extends GetWidget<AuthController> {
  const DashBordPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(backgroundDark),
      appBar: _appBar(),
      body: ListView(
        children: [

          //  
          _customHeader(),

          //
          _functionButton(),

          //
          _orderListView()

        ],
      ),
    );
  }

  AppBar _appBar(){
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const Icon(Icons.menu),
          const Expanded(
            child: Center(
              child: Text('')
            )
          ),
          InkWell(
            onTap: () => controller.signOut(),
            child: const Icon(Icons.logout)
          )
        ],
      ),
    );
  }

  Widget _customHeader(){

    final _controller = Get.find<OrderListViewController>();
    final formatter = NumberFormat("###,###,###,##0", "en");
    
    return Obx((){
    _controller.getIncome();
      return SizedBox(
        height: 100,
        child: Center(
          child: Column(
            children: [
              const Text(
                '本日收益',
                style: TextStyle(color: Color(xMainColor), fontSize: 18)
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'HKD\$${formatter.format(int.parse(_controller.turnover.toStringAsFixed(0)))}.',
                    style: const TextStyle(fontSize: 30, color: Color(xMainColor))
                  ),
                  Text(
                    _controller.turnover.toStringAsFixed(2).substring(
                      _controller.turnover.toStringAsFixed(2).length - 2, 
                      _controller.turnover.toStringAsFixed(2).length
                    ),
                    style: const TextStyle(fontSize: 20, color: Color(xMainColor))
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
    
  }

  Widget _functionButton(){

    var size = MediaQuery.of(Get.context!).size;
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
          InkWell(
            splashColor: Colors.transparent,
            onTap: () => Get.to(() => const BannerListView()),
            child: _functionButtonItemView(
              const Icon(Icons.widgets, size: 30,), 
              '封面列表'
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            onTap: () => Get.to(() => const ProductListView()),
            child: _functionButtonItemView(
              const Icon(Icons.widgets, size: 30,), 
              '商品管理'
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            onTap: () => Get.to(() => const CategoryListView()),
            child: _functionButtonItemView(
              const Icon(Icons.category_outlined, size: 30,), 
              '類別管理'
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            onTap: () => Get.to(const CouponListView()),
            child: _functionButtonItemView(
              const Icon(Icons.card_giftcard, size: 30,), 
              '優惠代碼'
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            onTap: () => Get.to(() => const OrderListView()),
            child: _functionButtonItemView(
              const Icon(Icons.inbox_rounded, size: 30,), 
              '訂單查詢'
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            onTap: () => Get.to(() => const RefundListView()),
            child: _functionButtonItemView(
              const Icon(Icons.autorenew, size: 30,), 
              '退貨管理'
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            onTap: () => Get.to(() => const MemberListView()),
            child: _functionButtonItemView(
              const Icon(Icons.person, size: 30,), 
              '會員系統'
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            onTap: () => Get.to(() => const PrivatePolicy()),
            child: _functionButtonItemView(
              const Icon(Icons.admin_panel_settings_outlined, size: 30,), 
              '私人政策'
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            onTap: () => Get.to(() => const RefundPolicy()),
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

  Widget _orderListView(){

    final _controller = Get.find<OrderListViewController>();

    return Obx((){
      return Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '最新訂單',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
            ),
            _controller.checkNotComplete().isEmpty ?  
            const SizedBox(
              height: 160,
              child: Center(
                child: Text(
                  '暫無新的訂單',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ) :
            ListView.builder(
              shrinkWrap: true,
              itemCount: _controller.orderlist.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return _controller.orderlist[index].isComplete == true ? Container() :
                OrderItemView(orderReceiveModel: _controller.orderlist[index]);
              }
            )
          ],
        ),
      );
    });

    
  }

}