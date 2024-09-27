import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ult_whatsapp/common/extension/custom_theme_extension.dart';

class ShowDateCard extends StatelessWidget {
  const ShowDateCard({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentDate = DateTime(now.year, now.month, now.day);
    final yesterday = currentDate.subtract(const Duration(days: 1));
    final lastWeek = currentDate.subtract(const Duration(days: 7));

    String displayText;

    if (date.year == currentDate.year && date.month == currentDate.month && date.day == currentDate.day) {
      displayText = 'Today';
    } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      displayText = 'Yesterday';
    } else if (date.isAfter(lastWeek) && date.year == currentDate.year && date.month == currentDate.month) {
      displayText = DateFormat.EEEE().format(date);
    } else {
      displayText = DateFormat.yMMMMd().format(date);
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: context.theme.receiverChatCardBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          fontSize: 13,
          fontFamily: 'Arial',
          color: context.theme.greyColor,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
