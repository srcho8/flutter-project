import 'package:intl/intl.dart';

extension ToDate on String {
  DateTime stringToDate() {
    return DateTime.parse(this);
  }

  String dateToString(String dateFormat) {
    DateTime date = DateTime.parse(this);
    String result = DateFormat(dateFormat).format(date);
    return result;
  }
}
