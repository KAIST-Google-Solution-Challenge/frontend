class ChatModel {
  final int? threadId;
  final String? address;
  final String? lastMessage;
  final int? lastMessageDate;

  ChatModel({
    required this.threadId,
    required this.address,
    required this.lastMessage,
    required this.lastMessageDate,
  });
}
