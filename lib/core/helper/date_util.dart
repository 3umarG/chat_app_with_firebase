import 'package:flutter/material.dart';

abstract class DateUtil {
  static String getFormattedDateFromMillis(BuildContext context , String millis){
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(millis));
    return TimeOfDay.fromDateTime(date).format(context);
  }
}