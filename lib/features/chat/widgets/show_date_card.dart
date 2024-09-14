import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ult_whatsapp/common/extension/custom_theme_extension.dart';

class ShowDateCard extends StatelessWidget {
  const ShowDateCard({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
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
        DateFormat.yMMMMd().format(date),
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
