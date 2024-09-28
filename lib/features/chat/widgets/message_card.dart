import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ult_whatsapp/common/extension/custom_theme_extension.dart';
import 'package:ult_whatsapp/common/enum/message_type.dart' as my_type;
import 'package:ult_whatsapp/common/models/message_model.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.isSender,
    required this.haveNip,
    required this.message,
  });

  final bool isSender;
  final bool haveNip;
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      margin: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: isSender
            ? 80
            : haveNip
                ? 10
                : 15,
        right: isSender
            ? haveNip
                ? 10
                : 15
            : 80,
      ),
      child: CustomPaint(
        painter: BubblePainter(
          isSender: isSender,
          bubbleColor: isSender
              ? context.theme.senderChatCardBg!
              : context.theme.receiverChatCardBg!,
        ),
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
              color: isSender
                  ? context.theme.senderChatCardBg
                  : context.theme.receiverChatCardBg,
              borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
              boxShadow: const [
                BoxShadow(color: Colors.black38),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: message.type == my_type.MessageType.image
                  ? Padding(
                      padding: const EdgeInsets.only(right: 3, top: 3, left: 3),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image(
                          image:
                              CachedNetworkImageProvider(message.textMessage),
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(
                        top: 8,
                        bottom: 8,
                        left: isSender ? 10 : 15,
                        right: isSender ? 15 : 10,
                      ),
                      child: Text(
                        "${message.textMessage}         ",
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Arial',
                          letterSpacing: 0,
                          color: context.theme.colorTextMessage,
                        ),
                      ),
                    ),
            ),
          ),
          Positioned(
            bottom: message.type == my_type.MessageType.text ? 2 : 4,
            right: message.type == my_type.MessageType.text
                ? isSender
                    ? 15
                    : 10
                : 4,
            child: message.type == my_type.MessageType.text
                ? Text(
                    DateFormat('h:mm a').format(message.timeSent),
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'Arial',
                      letterSpacing: 0,
                      color: context.theme.timechat,
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.only(
                        left: 90, right: 10, bottom: 10, top: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: const Alignment(0, -1),
                        end: const Alignment(1, 1),
                        colors: [
                          context.theme.greyColor!.withOpacity(0),
                          context.theme.greyColor!.withOpacity(.5),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(300),
                        bottomRight: Radius.circular(100),
                      ),
                    ),
                    child: Text(
                      DateFormat('h:mm a').format(message.timeSent),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                      ),
                    ),
                  ),
          )
        ]),
      ),
    );
  }
}

class BubblePainter extends CustomPainter {
  final bool isSender;
  final Color bubbleColor;

  BubblePainter({required this.isSender, required this.bubbleColor});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = bubbleColor
      ..style = PaintingStyle.fill;

    var path = Path();

    if (isSender) {
      // Right-side bubble
      path.moveTo(size.width + 8, 0);
      path.lineTo(size.width, 10);
      path.lineTo(size.width - 10, 0);
    } else {
      // Receiver's bubble
      path.lineTo(0, size.height - 10);
      path.lineTo(-10, size.height - 20);
      path.lineTo(0, size.height - 30);
      path.quadraticBezierTo(0, size.height - 20, 10, size.height - 20);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
