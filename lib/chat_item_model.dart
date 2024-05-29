class ChatItemModel {
  String name;
  String mostRecentMessage;
  String messageDate;
  String imagePath;
  bool isSent; // Flag to indicate if the message is sent
  bool isDelivered; // Flag to indicate if the message is delivered
  bool isRead; // Flag to indicate if the message is read

  ChatItemModel(this.name, this.mostRecentMessage, this.messageDate,
      {required this.imagePath, this.isSent = false, this.isDelivered = false, this.isRead = false});
}
