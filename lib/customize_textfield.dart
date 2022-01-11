import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:asher_store_cms/constants.dart';

class CustomizeTextField extends StatelessWidget {
  final String title;
  final bool isPassword;
  final TextEditingController mTextEditingController;
  final bool isenabled;
  final int minLine;
  final int maxLine;

  const CustomizeTextField({Key? key, required this.title, required this.isPassword, required this.mTextEditingController, required this.isenabled, required this.minLine, required this.maxLine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
      margin: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        color: Color(backgroundDark),
        borderRadius: BorderRadius.all(Radius.circular(7))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          TextField(
            minLines: minLine,
            maxLines: maxLine,
            enabled: isenabled,
            scrollPhysics: const BouncingScrollPhysics(),
            controller: mTextEditingController,
            obscureText: isPassword == true ? true : false,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(0),
              isDense: true,
              border: InputBorder.none
            ),
          ),
        ],
      ),
    );
  }
}

