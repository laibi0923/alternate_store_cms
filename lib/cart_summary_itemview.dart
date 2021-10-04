import 'package:flutter/material.dart';

class CartSummaryItemView extends StatelessWidget {
  final String title;
  final String value;
  final bool isbold;
  final bool showAddBox;
  const CartSummaryItemView({ Key? key, required this.title, required this.value, required this.isbold, required this.showAddBox }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  title,
                  style: isbold == true ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16) : null,  
                ),
                showAddBox == false ? Container() : 
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.add_box, color: Colors.grey),
                )
              ],
            )
          ),
          Text(
            value,
            style: isbold == true ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16) : null,
          ),
        ],
      ),
    );
  }
}