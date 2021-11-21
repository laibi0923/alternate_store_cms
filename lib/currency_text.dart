import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyTextView extends StatelessWidget {
  final double value;
  final TextStyle textStyle;
  const CurrencyTextView({Key? key, required this.value, required this.textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("###,###,###,##0.00", "en");
    String newText =  formatter.format(value);
    return Text(
      '\$$newText',
      style: textStyle,
    );
  }
}