// @dart=2.9
import 'package:asher_store_cms/constants.dart';
import 'package:asher_store_cms/screen/home_wapper.dart';
import 'package:asher_store_cms/screen/root/login_page.dart';
import 'package:asher_store_cms/screen/root/root.dart';
// import 'package:asher_store_cms/service/banner_service.dart';
// import 'package:asher_store_cms/service/member_database.dart';
// import 'package:asher_store_cms/service/product_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:asher_store_cms/model/privatepolicy_model.dart';
// import 'package:asher_store_cms/model/returnpolicy_model.dart';
// import 'package:asher_store_cms/service/category_database.dart';
// import 'package:asher_store_cms/service/coupon_service.dart';
// import 'package:asher_store_cms/service/order_service.dart';
// import 'package:asher_store_cms/service/paymentmethod_service.dart';
// import 'package:asher_store_cms/service/policy_service.dart';
import 'package:get/route_manager.dart';


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
    
    return GetMaterialApp(
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
      
      home: const RootPage()
    );
  }
}