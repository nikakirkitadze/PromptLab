extension DateTimeX on DateTime {
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return '$m ${m == 1 ? 'minute' : 'minutes'} ago';
    }
    if (diff.inHours < 24) {
      final h = diff.inHours;
      return '$h ${h == 1 ? 'hour' : 'hours'} ago';
    }
    final d = diff.inDays;
    if (d < 7) return '$d ${d == 1 ? 'day' : 'days'} ago';

    return '${day.toString().padLeft(2, '0')}.'
        '${month.toString().padLeft(2, '0')}.'
        '$year';
  }
}
