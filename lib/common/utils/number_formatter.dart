import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:intl/intl.dart';

class NumberFormatter {
  static String formatNumber(
      double value,
      int decimalDigits,
      ) {
    final number = Decimal.parse(value.toString());
    final format = NumberFormat.decimalPatternDigits(
      locale: 'vi',
      decimalDigits: decimalDigits,
    );
    final formatter = DecimalFormatter(format);
    return formatter.format(number);
  }

  static String formatCurrency(
      int value, {
        int decimalDigits = 0,
        bool withSymbol = false,
      }) {
    final number = Decimal.parse(value.toString());
    final format = NumberFormat.simpleCurrency(
      locale: 'vi',
      name: withSymbol ? 'VND' : '',
      decimalDigits: decimalDigits,
    );
    final formatter = DecimalFormatter(format);
    return formatter.format(number);
  }



  NumberFormatter._();
}
