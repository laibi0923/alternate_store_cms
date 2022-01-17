import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyFormatter extends TextInputFormatter{
  final int maxDigits;
  CurrencyFormatter(this.maxDigits);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue){

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    // ignore: unnecessary_null_comparison
    if (maxDigits != null && newValue.selection.baseOffset > maxDigits) {
      return oldValue;
    }

    double value = double.parse(newValue.text);
    final formatter = NumberFormat("###,##0.00", "en");
    String newText =  formatter.format(value / 100);
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length)
    );

  }

}