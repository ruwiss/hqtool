import 'package:intl/intl.dart';

extension DatetimeExtensions on DateTime {
  String get monthDaySuffixYear {
    String month = DateFormat('MMMM').format(this); // e.g., "June"
    String daySuffix = dayWithSuffix; // e.g., "6th"
    String year = DateFormat('yyyy').format(this); // e.g., "2024"
    return '$month $daySuffix, $year'; // e.g., "June 6th, 2024"
  }

  String get dayWithSuffix {
    int dayNum = day;
    String suffix;

    if (dayNum >= 11 && dayNum <= 13) {
      suffix = 'th';
    } else {
      switch (dayNum % 10) {
        case 1:
          suffix = 'st';
          break;
        case 2:
          suffix = 'nd';
          break;
        case 3:
          suffix = 'rd';
          break;
        default:
          suffix = 'th';
      }
    }
    return '$dayNum$suffix';
  }
}
