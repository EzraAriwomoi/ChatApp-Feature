import 'package:ult_whatsapp/chat_item_model.dart';

class ChatHelper {
  static var chatList = [
    ChatItemModel("Sophie", "Aaaaaaw, thank you", "now", imagePath: "assets/dp1.jpg", isSent: true, isDelivered: true, isRead: true),
    ChatItemModel("Sis", "Imagine imekataa kufanya", "10:00", imagePath: "assets/dp3.jpg", isSent: false, isDelivered: true, isRead: true),
    ChatItemModel("Joy", "Ananiboo ata", "Yesterday", imagePath: "assets/dp2.jpg", isSent: true, isDelivered: true, isRead: false),
    ChatItemModel("Brain", "Sawa", "Yesterday", imagePath: "assets/user.jpg", isSent: false, isDelivered: true, isRead: false),
    ChatItemModel("Beka", "Wee mzee", "Yesterday", imagePath: "assets/dp5.jpg", isSent: true, isDelivered: true, isRead: false),
    ChatItemModel("Dad", "Ok then", "Friday", imagePath: "assets/dp4.jpg", isSent: true, isDelivered: true, isRead: true)
  ];

  static ChatItemModel getChatItem(int position) {
    return chatList[position];
  }

  static var itemCount = chatList.length;
}
