import 'package:intl/intl.dart';

class Formatters {
  const Formatters._();

  static final NumberFormat currency = NumberFormat.currency(
    locale: 'en_KE',
    symbol: 'KSh ',
    decimalDigits: 0,
  );

  static final DateFormat shortDate = DateFormat('d MMM y');
  static final DateFormat fullTimestamp = DateFormat('d MMM y • h:mm a');

  static String currencyValue(num value) => currency.format(value);

  static String date(DateTime value) => shortDate.format(value);

  static String timestamp(DateTime value) => fullTimestamp.format(value);
}
