
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/model/schedule_slot.dart';

class FormatUtils {
  /// 👉 Chuyển `DateTime` thành chuỗi "dd/MM/yyyy"
  static String formatDate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  /// 👉 Chuyển `DateTime` thành chuỗi giờ "HH:mm"
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  static String formatTimeOfDay(TimeOfDay time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  /// 👉 Lấy khoảng thời gian kết thúc dựa trên thời gian bắt đầu và thời lượng
  static String formatTimeRange(DateTime start, int durationMinutes) {
    final startTime = formatTime(start);
    final endTime =
    formatTime(start.add(Duration(minutes: durationMinutes)));
    return "$startTime - $endTime";
  }

  static String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return dateTime.toString().substring(0, 10);  // Show as date
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }



  static String weekdayName(int weekday) {
    const weekdays = ['Chủ nhật', 'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7'];
    return weekdays[(weekday % 7)];
  }

  static DateTime calculateScheduleDateTime(DateTime startDate, ScheduleSlot slot) {
    final dayMap = {
      'Monday': 1, 'Tuesday': 2, 'Wednesday': 3, 'Thursday': 4,
      'Friday': 5, 'Saturday': 6, 'Sunday': 7,
      'Thứ 2': 1, 'Thứ 3': 2, 'Thứ 4': 3, 'Thứ 5': 4,
      'Thứ 6': 5, 'Thứ 7': 6, 'Chủ nhật': 7,
    };

    final startDay = startDate.weekday;

    int daysToAdd = slot.weekday! - startDay;
    if (daysToAdd < 0) daysToAdd += 7;

    final scheduleDate = startDate.add(Duration(days: daysToAdd));

    final timeParts = slot.startTime;
    final hour = timeParts?.hour;
    final minute = timeParts?.minute;

    return DateTime(
      scheduleDate.year,
      scheduleDate.month,
      scheduleDate.day,
      hour!,
      minute!,
    );
  }



}
