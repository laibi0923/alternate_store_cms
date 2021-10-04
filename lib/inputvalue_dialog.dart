import 'package:flutter/material.dart';
import 'package:alternate_store_cms/constants.dart';

Widget inputValueDialog(BuildContext context, String title, String hints){

  TextEditingController _textEditingController = TextEditingController();

  void _submit(){
    Navigator.pop(context, _textEditingController.text);
  }

  void _cancel(){
    Navigator.pop(context);
  }

  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(17)
    ),
    elevation: 0,
    backgroundColor: Colors.transparent,
    child: Container(
      margin: const EdgeInsets.only(left: 25, right: 25),
      decoration: BoxDecoration(
        color: const Color(backgroundDark),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Padding(
            padding: const EdgeInsets.only(top: 20, bottom:20),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          Container(
            padding: const EdgeInsets.only(top: 10, bottom:20),
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: TextFormField(
              autofocus: true,
              controller: _textEditingController,
              decoration: InputDecoration(
                enabledBorder:  const OutlineInputBorder(
                  borderSide:  BorderSide(color: Colors.grey, width: 0.0),
                ),
                focusedBorder:  const OutlineInputBorder(
                  borderSide:  BorderSide(color: Colors.grey, width: 0.0),
                ),
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 10, bottom: 5, top: 5, right: 10),
                hintText: hints,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14)
              ),
            ),
          ),
          
          Row(
            children: [

              Expanded(
                child: GestureDetector(
                  onTap: () => _submit(), 
                  child: Container(
                    height: 40,
                    color: Colors.transparent,
                    child: const Center(
                      child: Text(
                        '輸入',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                ),
              ),

              Expanded(
                child: GestureDetector(
                  onTap: () => _cancel(), 
                  child: Container(
                    height: 40,
                    color: Colors.transparent,
                    child: const Center(
                      child: Text(
                        '取消',
                        style: TextStyle(color: Colors.redAccent)),
                      ),
                    ),
                  )
              ),

            ],
          )

        ],
      ),
    ),
  );
  
}