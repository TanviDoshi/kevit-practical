import 'package:intl/intl.dart';


class DateUtil{
  static String toPrettyDateFromIso(String isoString) {
    final dt = DateTime.parse(isoString);
    return toPrettyDate(dt.millisecondsSinceEpoch);
  }
  static String toPrettyDate(int timestampMillis) {
    final now = DateTime.now();
    final neededTime = DateTime.fromMillisecondsSinceEpoch(timestampMillis);
    final today = DateTime(now.year, now.month, now.day);
    final neededDay = DateTime(
        neededTime.year, neededTime.month, neededTime.day);

    dateFormat(String pattern) => DateFormat(pattern, 'en_US');

    final difference = now.difference(neededTime);
    final minutes = difference.inMinutes;
    final hours = difference.inHours;

    if (now.year == neededTime.year) {
      if (now.month == neededTime.month) {
        if (neededDay
            .difference(today)
            .inDays == 1) {
          return 'Tomorrow at ${dateFormat('hh:mm a').format(neededTime)}';
        } else if (neededDay == today) {
          if (minutes < 1) {
            return 'Just now';
          } else if (minutes >= 1 && minutes < 10) {
            return '$minutes min ago';
          } else {
            return dateFormat('hh:mm a').format(neededTime);
          }
        } else if (today
            .difference(neededDay)
            .inDays == 1) {
          return 'Yesterday, ${dateFormat('hh:mm a').format(neededTime)}';
        } else if (isThisOrLastWeek(neededTime)) {
          return dateFormat('EEE, hh:mm a').format(neededTime);
        } else {
          return dateFormat('dd MMM, hh:mm a').format(neededTime);
        }
      } else {
        return dateFormat('d MMM, hh:mm a').format(neededTime);
      }
    } else {
      return dateFormat('dd MMM yyyy').format(neededTime);
    }
  }

  static bool isThisOrLastWeek(DateTime date) {
    final now = DateTime.now();
    final currentWeek = _weekNumber(now);
    final targetWeek = _weekNumber(date);

    return now.year == date.year && (currentWeek - targetWeek <= 1);
  }

// ISO week number calculator (simple version)
  static int _weekNumber(DateTime date) {
    final beginningOfYear = DateTime(date.year, 1, 1);
    final daysSinceStart = date
        .difference(beginningOfYear)
        .inDays;
    final adjusted = daysSinceStart + beginningOfYear.weekday;
    return ((adjusted - 1) / 7).floor() + 1;
  }
}