// @dart=2.9
import 'package:alternate_store_cms/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alternate_store_cms/model/privatepolicy_model.dart';
import 'package:alternate_store_cms/model/returnpolicy_model.dart';
import 'package:alternate_store_cms/screen/catergory_controller.dart';
import 'package:alternate_store_cms/screen/coupon_controller.dart';
import 'package:alternate_store_cms/screen/paymentmethod_editor.dart';
import 'package:alternate_store_cms/screen/private_policy.dart';
import 'package:alternate_store_cms/screen/product_editor.dart';
import 'package:alternate_store_cms/screen/return_policy.dart';
import 'package:alternate_store_cms/screen/receive_order.dart';
import 'package:alternate_store_cms/service/category_database.dart';
import 'package:alternate_store_cms/service/coupon_service.dart';
import 'package:alternate_store_cms/service/order_service.dart';
import 'package:alternate_store_cms/service/paymentmethod_service.dart';
import 'package:alternate_store_cms/service/policy_service.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    //  強制直屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    //  Status Bar 透明化
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        //  Statusbar 顏色
        statusBarColor: Color(backgroundDark),
        //  Statusbar Icon 顏色
        statusBarIconBrightness: Brightness.light,
        //  底部導航欄顏色
        systemNavigationBarColor: Color(backgroundDark), 
        //  底部導航欄 Icon 顏色
        systemNavigationBarIconBrightness: Brightness.light, 
      )
    );
    
    return MultiProvider(
      providers: [
        StreamProvider.value(value: CategoryDatabase().getCategory, initialData: null,),
        StreamProvider.value(value: PolicyService().getPrivatePolicyContent, initialData: PrivatePolicyModel.initialData()),
        StreamProvider.value(value: PolicyService().getReturnPolicyContent, initialData: ReturnPolicyModel.initialData()),

        // ignore: missing_required_param
        StreamProvider.value(value: CouponService().getCouponCode),
        // ignore: missing_required_param
        StreamProvider.value(value: OrderService().getOrder),
        // ignore: missing_required_param
        StreamProvider.value(value: PaymentMethodService().getPaymentMethod),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: ThemeData(
    
          brightness: Brightness.dark,
          //  主顏色
          //  White = Statusbar icon = black;  
          //  Black = Statusbar icon = white;
          primaryColor: Colors.grey,
          
          //  ???
          //  primarySwatch: Colors.red,
      
          //  下劃線樣式
          dividerColor: Colors.white54,
      
          //  
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.grey
          ),
      
          //  文字樣式
          primaryTextTheme: const TextTheme(
          ),
          
          //  Appbar 樣式
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(backgroundDark),
            titleTextStyle: TextStyle(
              color: Colors.grey,
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
            iconTheme: IconThemeData(
              color: Colors.black
            ),
          ),
        ),
        
        home: const Home(),
      ),
    );
  }
}


class Home extends StatelessWidget {
  const Home({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    const double itemHeight = 250;
    final double itemWidth = size.width / 2;

    return Scaffold(
      backgroundColor: const Color(backgroundDark),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
        children: [
          
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              '商品相關',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
    
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              childAspectRatio: (itemWidth / itemHeight)
            ),
            children: [
    
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductEditor())),
                child: gridViewItemView(
                  '上載商品', 
                  const Icon(Icons.widgets, size: 60,),
                  '未完成'
                ),
              ),
    
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CatergoryController(selectOpen: false, selectedList: [],))),
                child: gridViewItemView(
                  '貨品類別', 
                  const Icon(Icons.category_outlined, size: 60,),
                  '完成'
                ),
              ),
    
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CouponController())),
                child: gridViewItemView(
                  '優惠代碼', 
                  const Icon(Icons.card_giftcard, size: 60,),
                  '完成'
                ),
              ),
              
            ],
          ),
    
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              '訂單相關',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
    
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              childAspectRatio: (itemWidth / itemHeight)
            ),
            children: [

              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReceivedOrder())),
                child: gridViewItemView(
                  '訂單管理', 
                  const Icon(Icons.inbox_rounded, size: 60,),
                  '完成'
                ),
              ),
    
              gridViewItemView(
                '退貨管理', 
                const Icon(Icons.outbox_rounded, size: 60,),
                '未完成'
              ),
            ],
          ),

          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentMethodEditor())),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: const Color(primaryDark),
                borderRadius: BorderRadius.circular(7)
              ),
              child: gridViewItemView(
                '支付管理', 
                const Icon(Icons.payment_outlined, size: 60,),
                '未完成'
              ),
            )
          ),
    
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              '會員相關',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
    
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              childAspectRatio: (itemWidth / itemHeight)
            ),
            children: [
              
              gridViewItemView(
                '會員管理', 
                const Icon(Icons.person, size: 60,),
                '未完成'
              ),
    
            ],
          ),
    
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              '政策相關',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
    
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              childAspectRatio: (itemWidth / itemHeight)
            ),
            children: [
    
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivatePolicy())),
                child: gridViewItemView(
                  '私隱政策', 
                  const Icon(Icons.admin_panel_settings_outlined, size: 60,),
                  '完成'
                ),
              ),
    
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReturnPolicy())),
                child: gridViewItemView(
                  '退貨政策', 
                  const Icon(Icons.admin_panel_settings_outlined, size: 60,),
                  '完成'
                ),
              ),
    
            ],
          ),
    
    
        ],
      ),
    );
  }
}


Widget gridViewItemView(String title, Icon xicon, String status){
  return Container(
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.only(bottom: 20),
    decoration: BoxDecoration(
      color: const Color(0xFF2f2f2f),
      borderRadius: BorderRadius.circular(17)
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title
        ),
        Expanded(
          child: Center(
            child: xicon
          )
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(status),
        )
      ],
    ),
  );
}


Widget dividerWithTitle(String title){
  return Row(
    children: [
      const Expanded(
        child: Divider()
      ),
      Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(title)
        ),
      ),
      const Expanded(
        child: Divider()
      ),
    ],
  );
}