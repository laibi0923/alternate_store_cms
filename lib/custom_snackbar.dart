import 'package:flutter/material.dart';

class CustomSnackBar{
  
  void show(BuildContext context, String content){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xff2f2f2f),
        content: Text(
          content,
          style: const TextStyle(color: Colors.grey),
        ),
        action: SnackBarAction(
          textColor: Colors.grey,
          label: 'Dismiss', 
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()
        ),
      ),
    );
  }

}