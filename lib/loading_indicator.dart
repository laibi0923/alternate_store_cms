import 'package:flutter/material.dart';

Widget loadingIndicator(){
  return WillPopScope(
    onWillPop: () async =>  false,
    child: AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0))
      ),
      backgroundColor: Colors.black87,
      content: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.black.withOpacity(0.8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            
            Padding(
              child: SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(strokeWidth: 3, color: Colors.grey),
              ),
              padding: EdgeInsets.only(bottom: 16)
            ),

            Padding(
              child: Text(
                '請稍等',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
                ),
                textAlign: TextAlign.center,
              ),
              padding: EdgeInsets.only(bottom: 4)
            ),


            Text(
              '上載產品中...',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14
              ),
              textAlign: TextAlign.center,
            ),

          ],
        ),
      )
    ),
  );
}