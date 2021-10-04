import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:alternate_store_cms/constants.dart';
import 'package:alternate_store_cms/loading_indicator.dart';
import 'package:alternate_store_cms/model/paymentmethod_model.dart';
import 'package:alternate_store_cms/service/paymentmethod_service.dart';

import '../custom_snackbar.dart';
import '../customize_textfield.dart';

class PaymentMethodEditor extends StatefulWidget {
  const PaymentMethodEditor({ Key? key }) : super(key: key);

  @override
  State<PaymentMethodEditor> createState() => _PaymentMethodEditorState();
}

class _PaymentMethodEditorState extends State<PaymentMethodEditor> {

  late File _qrCodeFile = File('path');
  final TextEditingController _holderTextEditingController = TextEditingController();
  final TextEditingController _methodNameTextEditingController = TextEditingController();
  final TextEditingController _remarkTextEditingController = TextEditingController();


  void _uploadPaymentMethod(){

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => loadingIndicator()
    );

    PaymentMethodService().uploadQrImage(_qrCodeFile).then((qrImagePatch) {

      PaymentMethodService().addPaymentMethod(
        PaymentMethodModel(
          Timestamp.now(), 
          Timestamp.now(), 
          _holderTextEditingController.text, 
          qrImagePatch, 
          _methodNameTextEditingController.text,
          '', 
          _remarkTextEditingController.text
        )
      ).then((value) {
        Navigator.pop(context);
        Navigator.pop(context);
        CustomSnackBar().show(context, '上載完成');
      });
      
    });

  }

  Future<void> _addImage() async {
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if(image == null){
        return;
      } else {
        final File imageTemporary = File(image.path);
        setState(() {
          _qrCodeFile = imageTemporary;
        });
      }
    } on PlatformException catch (e){
      // ignore: avoid_print
      print('Failed to pick image : $e');
    }
  }

  void _removeQRImage(){
    setState(() {
      _qrCodeFile = File('path');
    });
  }

  @override
  void dispose() {
    super.dispose();
    _holderTextEditingController.dispose();
    _methodNameTextEditingController.dispose();
    _remarkTextEditingController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(backgroundDark),
        body: Stack(
          children: [

            ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [

                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('新增支付方式', style: TextStyle(fontSize: 22)),
                ),

                // QR Image
                GestureDetector(
                  onTap: () => _addImage(),
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xff2f2f2f),
                      borderRadius: BorderRadius.circular(7)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  '二維碼圖片',
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: const Color(backgroundDark),
                                  borderRadius: BorderRadius.circular(99)
                                ),
                                child: const Icon(Icons.add)
                              )
                            ],
                          ),
                        ),
                        // ignore: unnecessary_null_comparison
                        _qrCodeFile == null ? 
                        const Padding(
                          padding: EdgeInsets.only(top: 75, bottom: 75),
                          child: Center(
                            child: Text('點撃新增'),
                          ),
                        ) :
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 20, bottom: 20),
                            height: 150,
                            child: GestureDetector(
                              onTap: () => _removeQRImage(),
                              child: Container(
                                height: 50,
                                width: 150,
                                margin: const EdgeInsets.only(left: 15),
                                decoration: BoxDecoration(
                                  color: Color(primaryDark),
                                  borderRadius: BorderRadius.circular(17),
                                  image: DecorationImage(
                                    image: FileImage(_qrCodeFile),
                                    fit: BoxFit.cover
                                  )
                                ),
                              ),
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Method Name
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: CustomizeTextField(
                    title: '付款方式名稱',
                    mTextEditingController: _methodNameTextEditingController,
                    isenabled: true,
                    isPassword: false, 
                    maxLine: 1, 
                    minLine: 1,
                  ),
                ),

                // Holder Name
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: CustomizeTextField(
                    title: '帳戶持有人名稱',
                    mTextEditingController: _holderTextEditingController,
                    isenabled: true,
                    isPassword: false, 
                    maxLine: 1, 
                    minLine: 1,
                  ),
                ),

                //  Description
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: CustomizeTextField(
                    title: '說明',
                    mTextEditingController: _remarkTextEditingController,
                    minLine: 4,
                    isenabled: true, 
                    isPassword: false, 
                    maxLine: 10, 
                    
                  ),
                ),

              ],
            ),

            Positioned(
              top: 15,
              right: 70,
              child: GestureDetector(
                onTap: () => _uploadPaymentMethod(),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(backgroundDark),
                    borderRadius: BorderRadius.circular(999)
                  ),
                  child: const Icon(Icons.upload, color: Colors.grey)
                )
              ),
             ),

            Positioned(
              top: 15,
              right: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(backgroundDark),
                    borderRadius: BorderRadius.circular(999)
                  ),
                  child: const Icon(Icons.close, color: Colors.grey,)
                )
              ),
            )

          ],
        ),
      ),
    );
  }
}