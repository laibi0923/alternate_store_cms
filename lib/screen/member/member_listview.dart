import 'package:alternate_store_cms/constants.dart';
import 'package:flutter/material.dart';

class MemberListView extends StatelessWidget {
  const MemberListView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(backgroundDark),
      appBar: AppBar(
        elevation: 0,
        // automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Spacer(),
            
          ],
        ),
      ),
      body: Container(),
    );
  }
}