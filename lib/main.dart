import 'package:asher_store_cms/constants.dart';
import 'package:asher_store_cms/controller/auth_controller.dart';
import 'package:asher_store_cms/controller/banner_controller.dart';
import 'package:asher_store_cms/controller/categorylistview_controller.dart';
import 'package:asher_store_cms/controller/memberlistview_controller.dart';
import 'package:asher_store_cms/controller/orderlistview_controller.dart';
import 'package:asher_store_cms/controller/privatepolicy_controller.dart';
import 'package:asher_store_cms/controller/productlistview_controller.dart';
import 'package:asher_store_cms/controller/refundlistview_controller.dart';
import 'package:asher_store_cms/controller/refundpolicy_controller.dart';
import 'package:asher_store_cms/controller/root_controller.dart';
import 'package:asher_store_cms/screen/root/root.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    Get.put(AuthController());
    Get.put(RootPageController());
    Get.put(BannerController());
    Get.put(ProductListViewController());
    Get.put(CategoryListViewController());
    Get.put(MemberListViewController());
    Get.put(OrderListViewController());
    Get.put(RefundListViewController());
    Get.put(RefundPolicyController());
    Get.put(PrivatePolicyController());
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
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
            color: Color(xMainColor)
          ),
        ),
      ),
      
      home: const RootPage()
    );
  }
}