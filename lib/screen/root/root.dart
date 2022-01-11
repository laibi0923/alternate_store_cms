import 'package:asher_store_cms/screen/root/login_page.dart';
import 'package:flutter/material.dart';

class RootPage extends StatelessWidget {
  const RootPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginPage(),
    );
  }
}