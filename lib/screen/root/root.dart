import 'package:asher_store_cms/controller/auth_controller.dart';
import 'package:asher_store_cms/screen/root/dashbord.dart';
import 'package:asher_store_cms/screen/root/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RootPage extends GetWidget<AuthController>{
  const RootPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Obx((){
        return controller.user.value == null ?
        const LoginPage() : 
        const DashBordPage();
      })
    );
  }
}