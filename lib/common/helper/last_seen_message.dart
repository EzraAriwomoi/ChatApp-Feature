import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> lastSeenMessage(String userId, int lastSeen) async {
  final isActive = await _checkUserActivity(userId);

  if (isActive) {
    return 'Online';
  }

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
    // Handle any errors that might occur
    print('Error fetching user activity: $e');
    return false;
  }
}

String _formatTime(DateTime dateTime) {
  return "${dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}";
}

String _formatDayOfWeek(int weekday) {
  List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  return days[weekday - 1];
}

String _formatDate(DateTime dateTime) {
  return "${_formatMonth(dateTime.month)} ${dateTime.day}, ${dateTime.year}";
}

String _formatMonth(int month) {
  List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  return months[month - 1];
}
