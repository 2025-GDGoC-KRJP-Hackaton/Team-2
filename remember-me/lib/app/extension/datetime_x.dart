import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  String formatDate() {
    return DateFormat('yyyy.MM.dd').format(this);
  }

  String formatTime() {
    return DateFormat('HH:mm').format(this);
  }

  String formatDateTime() {
    return DateFormat('yyyy.MM.dd HH:mm').format(this);
  }

  String formatAgoTime() {
    final now = DateTime.now();

    final difference = now.difference(this);

    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }
}
