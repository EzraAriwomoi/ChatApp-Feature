import 'package:ult_whatsapp/call_item_model.dart';

class CallHelper {
  static var callList = [
    CallItemModel("Sophie", "Yesterday, 03:39", imagePath: "assets/dp1.jpg"),
    CallItemModel("Brain", "(2) 16/02/2024", imagePath: "assets/dp2.jpg"),
    CallItemModel("Beka", "(1) 11/02/2024", imagePath: "assets/dp5.jpg"),
    CallItemModel("Sharry", "27/01/2024", imagePath: "assets/dp2.jpg")
  ];

  static CallItemModel getCallItem(int position) {
    return callList[position];
  }

  static var itemCount = callList.length;
}
