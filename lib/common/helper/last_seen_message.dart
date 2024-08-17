String lastSeenMessage(int lastSeen) {
  DateTime now = DateTime.now();
  DateTime lastSeenDateTime = DateTime.fromMillisecondsSinceEpoch(lastSeen);
  Duration differenceDuration = now.difference(lastSeenDateTime);

  if (differenceDuration.inMinutes < 60) {
    return 'Last seen today at ${_formatTime(lastSeenDateTime)}';
  } else if (differenceDuration.inHours < 24) {
    return 'Last seen today at ${_formatTime(lastSeenDateTime)}';
  } else if (differenceDuration.inDays == 1) {
    return 'Last seen yesterday at ${_formatTime(lastSeenDateTime)}';
  } else if (differenceDuration.inDays < 7) {
    String dayOfWeek = _formatDayOfWeek(lastSeenDateTime.weekday);
    return 'Last seen on $dayOfWeek at ${_formatTime(lastSeenDateTime)}';
  } else {
    return 'Last seen on ${_formatDate(lastSeenDateTime)} at ${_formatTime(lastSeenDateTime)}';
  }
}

String _formatTime(DateTime dateTime) {
  // Formats time as '10:13 AM' or '10:13 PM'
  return "${dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}";
}

String _formatDayOfWeek(int weekday) {
  // Returns the day of the week from an integer
  List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  return days[weekday - 1];
}

String _formatDate(DateTime dateTime) {
  // Formats the date as 'August 12, 2024'
  return "${_formatMonth(dateTime.month)} ${dateTime.day}, ${dateTime.year}";
}

String _formatMonth(int month) {
  // Returns the month name from an integer
  List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  return months[month - 1];
}
