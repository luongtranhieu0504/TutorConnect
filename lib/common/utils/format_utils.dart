
import 'package:intl/intl.dart';

class FormatUtils {
  /// 👉 Chuyển `DateTime` thành chuỗi "dd/MM/yyyy"
  static String formatDate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  /// 👉 Chuyển `DateTime` thành chuỗi giờ "HH:mm"
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
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

}
