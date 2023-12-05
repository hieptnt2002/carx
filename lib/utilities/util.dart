  import 'package:intl/intl.dart';

String formattedAmountCar(int amount) {
    NumberFormat currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    currencyFormat.maximumFractionDigits = 0;
    String formattedAmount = currencyFormat.format(amount);

    return formattedAmount;
  }