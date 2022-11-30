import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat_app/common/enums/message_enum.dart';

class MessageReplyProvider {
  final String message;
  final String senderName;
  final bool isMe;
  final MessageEnum messageEnum;
  MessageReplyProvider(
      this.message, this.senderName, this.isMe, this.messageEnum);
}

final messageReplyProvider =
    StateProvider<MessageReplyProvider?>((ref) => null);
