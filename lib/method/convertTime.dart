import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyDateUtil {
  static String formatDate(Timestamp timestamp) {
    //Timestamp is the object we retrieve from firebase so to display it.
    //convert to string
    DateTime datetime = timestamp.toDate();

    String year = datetime.year.toString();

    String month = datetime.month.toString();

    String day = datetime.day.toString();

    String formattedDate = '$month/$day/$year';

    return formattedDate;
  }

  static String formatTime(Timestamp timestamp) {
    DateTime datetime = timestamp.toDate();

    String amPm = datetime.hour < 12 ? 'AM' : 'PM';
    int hour = datetime.hour > 12 ? datetime.hour - 12 : datetime.hour;
    String formattedTime =
        '${hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')} $amPm';

    return formattedTime;
  }

  static String formatTimeFromEpoch(
      {required BuildContext context, required String time}) {
    // Convert Unix timestamp (milliseconds since epoch) to DateTime
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getLastMessageTime(
      {required BuildContext context, required String time}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    //check if the current time is equal to the sent time
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }

    return '${sent.day} ${_getMonth(sent)}';
  }

  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }
}
