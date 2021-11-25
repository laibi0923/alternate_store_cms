// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:alternate_store_cms/constants.dart';
import 'package:alternate_store_cms/model/privatepolicy_model.dart';
import 'package:alternate_store_cms/service/policy_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PrivatePolicy extends StatefulWidget {
  const PrivatePolicy({ Key? key }) : super(key: key);

  @override
  State<PrivatePolicy> createState() => _PrivatePolicyState();
}

class _PrivatePolicyState extends State<PrivatePolicy> {

  TextEditingController textEditingController = TextEditingController();

  void _updatePolicy(){
    PolicyService().updatePrivatePolicy(textEditingController.text);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final privatePolicy = Provider.of<PrivatePolicyModel>(context);

    textEditingController.text = privatePolicy.content;

    return Scaffold(
      backgroundColor: const Color(backgroundDark),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            onPressed: () => _updatePolicy(), 
            icon: const Icon(Icons.upload, color: Colors.grey,)
          ),
        ),
        title: const Text('私隱政策'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () => Navigator.pop(context), 
              icon: const Icon(Icons.close, color: Colors.grey,)
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text('最後更新日期 : ${DateFormat('yyyy年MM月dd日').format(DateTime.fromMicrosecondsSinceEpoch(privatePolicy.lastModify.microsecondsSinceEpoch))}'),
            ),

            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2f2f2f),
                  borderRadius: BorderRadius.circular(7)
                ),
                child: TextField(
                  controller: textEditingController,
                  scrollPhysics: const BouncingScrollPhysics(),
                  maxLines: 900,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(height: 1.3),
                )
              ),
            )

          ],
        ),
      ),
    );
  }
}