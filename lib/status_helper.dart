import 'package:ult_whatsapp/status_item_model.dart';

class StatusHelper {
  static var statusList = [
    StatusItemModel("Joy", "Just now", imagePath: "assets/dp2.jpg"),
    StatusItemModel("Sophie", "10 minutes ago", imagePath: "assets/dp1.jpg"),
    StatusItemModel("Ezra", "59 minutes ago", imagePath: "assets/dp.jpg"),
    StatusItemModel("Brain", "10:22 am", imagePath: "assets/dp2.jpg"),
    StatusItemModel("Victor", "7:02 am", imagePath: "assets/dp2.jpg"),
    StatusItemModel("Sharry", "5:33 am", imagePath: "assets/dp2.jpg"),
    StatusItemModel("Austin", "1:22 am", imagePath: "assets/dp5.jpg"),
    StatusItemModel("Beka", "Yesterday", imagePath: "assets/dp5.jpg"),
    StatusItemModel("Sis", "Yesterday", imagePath: "assets/dp3.jpg"),
    StatusItemModel("Vitz", "Yesterday", imagePath: "assets/dp2.jpg"),
    StatusItemModel("Mercy", "Yesterday", imagePath: "assets/dp2.jpg")
  ];

  static StatusItemModel getStatusItem(int position) {
    return statusList[position];
  }

  static var itemCount = statusList.length;
}
