import 'package:asher_store_cms/constants.dart';
import 'package:asher_store_cms/controller/auth_controller.dart';
import 'package:asher_store_cms/controller/root_controller.dart';
import 'package:asher_store_cms/customize_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _rootController = Get.find<RootPageController>();
    final _authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(backgroundDark),
      body: Padding(
        padding: const EdgeInsets.only(top: 200, left: 20, right: 20),
        child: Column(
          children: [
            const Center(
              child: Text(
                'ASHER STORE',
                style: TextStyle(fontSize: 30),
              )
            ),
            Container(height: 50),
            CustomizeTextField(
              title: 'Please Enter Password', 
              isPassword: true, 
              mTextEditingController: _rootController.pwEditingController, 
              isenabled: true, 
              minLine: 1, 
              maxLine: 1
            ),
            Container(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 10),
              child : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color(xMainColor),
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                ),
                onPressed: () {
                  _authController.signIn(
                    'asher.co.hk@gmail.com', 
                    _rootController.pwEditingController.text
                  );
                  _rootController.pwEditingController.clear();
                },
                child: const Text('LOGIN'),
              )
            ),
            
          ],
        ),
      )
    );
  }
}