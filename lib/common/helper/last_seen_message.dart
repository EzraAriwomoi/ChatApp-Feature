import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> lastSeenMessage(String userId, int lastSeen) async {
  final isActive = await _checkUserActivity(userId);

  if (isActive) {
    return 'online';
  }

  DateTime now = DateTime.now();
  DateTime lastSeenDateTime = DateTime.fromMillisecondsSinceEpoch(lastSeen);
  Duration differenceDuration = now.difference(lastSeenDateTime);

  if (now.day != lastSeenDateTime.day) {
    // Past midnight handling
    if (differenceDuration.inDays == 1) {
      return 'last seen yesterday at ${_formatTime(lastSeenDateTime)}';
    } else if (differenceDuration.inDays < 7) {
      // Display the weekday for recent past
      return 'last seen ${_formatDayOfWeek(lastSeenDateTime.weekday)} at ${_formatTime(lastSeenDateTime)}';
    } else {
      // Beyond a week
      return 'last seen ${_formatDate(lastSeenDateTime)} at ${_formatTime(lastSeenDateTime)}';
    }
  }

  // Last seen was today
  if (differenceDuration.inMinutes < 60) {
    return 'last seen today at ${_formatTime(lastSeenDateTime)}';
  } else if (differenceDuration.inHours < 24) {
    return 'last seen today at ${_formatTime(lastSeenDateTime)}';
  }
  // For any other case, use 'yesterday'
  return 'last seen yesterday at ${_formatTime(lastSeenDateTime)}';
}

Future<bool> _checkUserActivity(String userId) async {
  try {
    // Fetch the user document from Firestore
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    // Check if the document exists and retrieve the 'is_online' field
    if (userDoc.exists) {
      final data = userDoc.data();
      return data?['is_online'] ?? false;
    } else {
      // Document does not exist
      return false;
    }
  } catch (e) {
    // print('Error fetching user activity: $e');
    return false;
  }
}

String _formatTime(DateTime dateTime) {
  return "${dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}";
}

String _formatDayOfWeek(int weekday) {
  List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  return days[weekday % 7];
}

String _formatDate(DateTime dateTime) {
  if (DateTime.now().year == dateTime.year) {
    return "${_formatMonth(dateTime.month)} ${dateTime.day}";
  } else {
    return "${_formatMonth(dateTime.month)} ${dateTime.day}, ${dateTime.year}";
  }
}

String _formatMonth(int month) {
  List<String> months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return months[month - 1];
}
