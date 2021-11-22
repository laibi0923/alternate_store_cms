// @dart=2.9
import 'package:alternate_store_cms/constants.dart';
import 'package:alternate_store_cms/screen/home_wapper.dart';
import 'package:alternate_store_cms/screen/order/order_listview.dart';
import 'package:alternate_store_cms/screen/proudct/product_listview.dart';
import 'package:alternate_store_cms/service/product_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alternate_store_cms/model/privatepolicy_model.dart';
import 'package:alternate_store_cms/model/returnpolicy_model.dart';
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
        StreamProvider.value(value: OrderService().getOrder,),
        // ignore: missing_required_param
        StreamProvider.value(value: PaymentMethodService().getPaymentMethod),
        // ignore: missing_required_param
        StreamProvider.value(value: ProductDatabase().showProduct),

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
        
        home: const HomeWapper()
      ),
    );
  }
}