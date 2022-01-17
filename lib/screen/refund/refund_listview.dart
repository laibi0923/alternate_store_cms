import 'package:asher_store_cms/constants.dart';
import 'package:asher_store_cms/controller/refundlistview_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RefundListView extends StatelessWidget {
  const RefundListView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _controller = Get.find<RefundListViewController>();
    
    return Obx((){
      return Scaffold(
        backgroundColor: const Color(backgroundDark),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Row(
            children: [
              IconButton(
                onPressed: () => Get.back(), 
                icon: const Icon(Icons.arrow_back)
              ),

            ],
          ),
        ),
        body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: _controller.refundList.length,
          padding: const EdgeInsets.only(left: 15, right: 15),
          itemBuilder: (context, index){
            return Container(
              child: Text(_controller.refundList.length.toString()),
            );
          }
        )
      );
    });
    
  }

}