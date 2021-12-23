import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:asher_store_cms/constants.dart';


Widget comfirmationDialog(BuildContext context, String title, String content, String submitBtnText, String cancelBtnText){

  void _submitOnclick(){
    Navigator.pop(context, true);
  }

  void _cancelOnClick(){
    Navigator.pop(context, false);
  }

  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(17),
    ),
    elevation: 0,
    backgroundColor: Colors.transparent,
    child: Container(
      margin: const EdgeInsets.only(left: 25, right: 25),
      decoration: BoxDecoration(
        color: const Color(backgroundDark),
        borderRadius: BorderRadius.circular(17)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold),)
          ),

          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 30),
            child: Text(content, textAlign: TextAlign.center,)
          ),

          const Divider(color: Colors.grey, height: 1,),

          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => _submitOnclick(), 
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all<Color>(Colors.transparent)
                    ),
                    child: Text(
                      submitBtnText,
                      style: const TextStyle(color: Colors.greenAccent),
                    )
                  )
                ),
                const VerticalDivider(color: Colors.grey,),
                Expanded(
                  child: TextButton(
                    onPressed: () => _cancelOnClick(),
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all<Color>(Colors.transparent)
                    ),
                    child: Text(
                      cancelBtnText,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  )
                )
              ],
            ),
          )
        
        ],
      ),
    )
  ); 

}
