import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat_app/common/enums/message_enum.dart';
import 'package:private_chat_app/common/providers/message_reply_provider.dart';
import 'package:private_chat_app/features/auth/controller/auth_controller.dart';
import 'package:private_chat_app/features/chat/repository/chat_repository.dart';
import 'package:private_chat_app/models/chat_contact_model.dart';
import 'package:private_chat_app/models/group_model.dart';
import 'package:private_chat_app/models/message_model.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  Stream<List<ChatContactModel>> getChatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<GroupModel>> getChatGroups() {
    return chatRepository.getChatGroups();
  }

  Stream<List<MessageModel>> getChatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }

  Stream<List<MessageModel>> getGroupChatStream(String groupId) {
    return chatRepository.getGroupChatStream(groupId);
  }

  void sendTextMessage(BuildContext context, String text, String recieverUserId,
      bool isGroupChat) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendTextMessage(
            context: context,
            text: text,
            recieverUserId: recieverUserId,
            senderUser: value!,
            messageReply: messageReply,
            isGroupChat: isGroupChat));
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendFileMessage(BuildContext context, File file, String recieverUserId,
      MessageEnum messageEnum, bool isGroupChat) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendFileMessage(
            context: context,
            file: file,
            recieverUserId: recieverUserId,
            senderUserData: value!,
            ref: ref,
            messageEnum: messageEnum,
            messageReply: messageReply,
            isGroupChat: isGroupChat));
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendGIFMessage(BuildContext context, String gifUrl,
      String recieverUserId, bool isGroupChat) {
    final messageReply = ref.read(messageReplyProvider);
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newGIFUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';

    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendGIFMessage(
            context: context,
            gifUrl: newGIFUrl,
            recieverUserId: recieverUserId,
            senderUser: value!,
            messageReply: messageReply,
            isGroupChat: isGroupChat));
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void setChatMessageSeen(
      BuildContext context, String recieverUserId, String messageId) {
    chatRepository.setChatMessageSeen(context, recieverUserId, messageId);
  }

  void decrementUnseenMessages(BuildContext context, String recieverUserId) {
    chatRepository.decrementUnseenMessages(context, recieverUserId);
  }
}
