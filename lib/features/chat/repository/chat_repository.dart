import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat_app/common/enums/message_enum.dart';
import 'package:private_chat_app/common/providers/message_reply_provider.dart';
import 'package:private_chat_app/common/repositories/common_firebase_storage_repository.dart';
import 'package:private_chat_app/common/utils/utils.dart';
import 'package:private_chat_app/models/chat_contact_model.dart';
import 'package:private_chat_app/models/group_model.dart';
import 'package:private_chat_app/models/message_model.dart';
import 'package:uuid/uuid.dart';
import '../../../models/user_model.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(
    firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({required this.firestore, required this.auth});

  Stream<List<ChatContactModel>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContactModel> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContactModel.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);
        contacts.add(ChatContactModel(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
            unseenMessages: chatContact.unseenMessages));
      }
      return contacts;
    });
  }

  Stream<List<GroupModel>> getChatGroups() {
    return firestore.collection('groups').snapshots().map((event) {
      List<GroupModel> groups = [];
      for (var document in event.docs) {
        var group = GroupModel.fromMap(document.data());
        if (group.memberUids.contains(auth.currentUser!.uid)) {
          groups.add(group);
        }
      }
      return groups;
    });
  }

  Stream<List<MessageModel>> getChatStream(String recieverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<MessageModel> messages = [];
      for (var document in event.docs) {
        messages.add(MessageModel.fromMap(document.data()));
      }
      return messages;
    });
  }

  Stream<List<MessageModel>> getGroupChatStream(String groupId) {
    return firestore
        .collection('groups')
        .doc(groupId)
        .collection('chats')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<MessageModel> messages = [];
      for (var document in event.docs) {
        messages.add(MessageModel.fromMap(document.data()));
      }
      return messages;
    });
  }

  void _saveDataToContactsSubcollection(
      UserModel senderUserData,
      UserModel? recieverUserData,
      String text,
      DateTime timeSent,
      String recieverUserId,
      int unseenMessages,
      bool isGroupChat) async {
    if (isGroupChat) {
      await firestore.collection('groups').doc(recieverUserId).update({
        'lastMessage': text,
        'timeSent': DateTime.now().millisecondsSinceEpoch
      });
    } else {
      // users -> reciever user id => chats -> current user id -> set data
      var senderChatContact = ChatContactModel(
          name: senderUserData.name,
          profilePic: senderUserData.profilePic,
          contactId: senderUserData.uid,
          timeSent: timeSent,
          lastMessage: text,
          unseenMessages: unseenMessages);
      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .set(senderChatContact.toMap());
      // users -> current user id => chats -> reciever user id -> set data
      int numUnseenMessages = 0;
      var senderChatContactSnapshot = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .get();
      if (senderChatContactSnapshot.data() != null) {
        ChatContactModel senderChatContactData =
            ChatContactModel.fromMap(senderChatContactSnapshot.data()!);
        numUnseenMessages = senderChatContactData.unseenMessages;
      }

      var recieverChatContact = ChatContactModel(
          name: recieverUserData!.name,
          profilePic: recieverUserData.profilePic,
          contactId: recieverUserData.uid,
          timeSent: timeSent,
          lastMessage: text,
          unseenMessages: numUnseenMessages);
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .set(recieverChatContact.toMap());
    }
  }

  void _saveMessageToMessageSubcollection(
      {required String recieverUserId,
      required String text,
      required DateTime timeSent,
      required String messageId,
      required String username,
      required String? recieverUserame,
      required MessageEnum messageType,
      required MessageReplyProvider? messageReply,
      required String senderUsername,
      required bool isGroupChat}) async {
    final message = MessageModel(
        senderId: auth.currentUser!.uid,
        senderName: senderUsername,
        recieverId: recieverUserId,
        text: text,
        type: messageType,
        timeSent: timeSent,
        messageId: messageId,
        isSeen: false,
        repliedMessage: messageReply == null ? '' : messageReply.message,
        repliedTo: messageReply == null ? '' : messageReply.senderName,
        repliedMessageType:
            messageReply == null ? MessageEnum.text : messageReply.messageEnum);

    if (isGroupChat) {
      await firestore
          .collection('groups')
          .doc(recieverUserId)
          .collection('chats')
          .doc(messageId)
          .set(message.toMap());
    } else {
      // users -> sender id -> reciever id -> messages -> message id -> store message
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());
      // users -> reciever id -> sender id -> messages -> message id -> store message
      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());
    }
  }

  void sendTextMessage(
      {required BuildContext context,
      required String text,
      required String recieverUserId,
      required UserModel senderUser,
      required MessageReplyProvider? messageReply,
      required bool isGroupChat}) async {
    try {
      var timeSent = DateTime.now();
      UserModel? recieverUserData;

      if (!isGroupChat) {
        var userDataMap =
            await firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      var messageId = const Uuid().v4();

      int unSeenMessageNumber = await incrementUnseenMessages(recieverUserId);

      _saveDataToContactsSubcollection(senderUser, recieverUserData, text,
          timeSent, recieverUserId, unSeenMessageNumber, isGroupChat);

      _saveMessageToMessageSubcollection(
          recieverUserId: recieverUserId,
          text: text,
          timeSent: timeSent,
          messageId: messageId,
          username: senderUser.name,
          recieverUserame: recieverUserData?.name,
          messageType: MessageEnum.text,
          messageReply: messageReply,
          senderUsername: senderUser.name,
          isGroupChat: isGroupChat);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage(
      {required BuildContext context,
      required File file,
      required String recieverUserId,
      required UserModel senderUserData,
      required ProviderRef ref,
      required MessageEnum messageEnum,
      required MessageReplyProvider? messageReply,
      required bool isGroupChat}) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v4();

      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
              'chats/${messageEnum.type}/${senderUserData.uid}/$recieverUserId/$messageId',
              file);

      UserModel? recieverUserData;
      if (!isGroupChat) {
        var userDataMap =
            await firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      String contactMsg;

      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = '📷 Photo';
          break;
        case MessageEnum.video:
          contactMsg = '🎥 Video';
          break;
        case MessageEnum.audio:
          contactMsg = '🎙️ Audio';
          break;
        case MessageEnum.gif:
          contactMsg = 'GIF';
          break;
        default:
          contactMsg = 'GIF';
      }

      int unSeenMessageNumber = await incrementUnseenMessages(recieverUserId);

      _saveDataToContactsSubcollection(
          senderUserData,
          recieverUserData,
          contactMsg,
          timeSent,
          recieverUserId,
          unSeenMessageNumber,
          isGroupChat);
      _saveMessageToMessageSubcollection(
          recieverUserId: recieverUserId,
          text: imageUrl,
          timeSent: timeSent,
          messageId: messageId,
          username: senderUserData.name,
          recieverUserame: recieverUserData?.name,
          messageType: messageEnum,
          senderUsername: senderUserData.name,
          messageReply: messageReply,
          isGroupChat: isGroupChat);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendGIFMessage(
      {required BuildContext context,
      required String gifUrl,
      required String recieverUserId,
      required UserModel senderUser,
      required MessageReplyProvider? messageReply,
      required bool isGroupChat}) async {
    try {
      var timeSent = DateTime.now();
      UserModel? recieverUserData;

      if (!isGroupChat) {
        var userDataMap =
            await firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      var messageId = const Uuid().v4();
      int unSeenMessageNumber = await incrementUnseenMessages(recieverUserId);

      _saveDataToContactsSubcollection(senderUser, recieverUserData, 'GIF',
          timeSent, recieverUserId, unSeenMessageNumber, isGroupChat);

      _saveMessageToMessageSubcollection(
          recieverUserId: recieverUserId,
          text: gifUrl,
          timeSent: timeSent,
          messageId: messageId,
          username: senderUser.name,
          recieverUserame: recieverUserData?.name,
          messageType: MessageEnum.gif,
          messageReply: messageReply,
          senderUsername: senderUser.name,
          isGroupChat: isGroupChat);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void setChatMessageSeen(
      BuildContext context, String recieverUserId, String messageId) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<int> incrementUnseenMessages(String recieverUserId) async {
    try {
      var recieverChatContactSnapshot = await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .get();
      if (recieverChatContactSnapshot.data() == null) {
        return 1;
      } else {
        ChatContactModel recieverChatContact =
            ChatContactModel.fromMap(recieverChatContactSnapshot.data()!);
        recieverChatContact.unseenMessages++;
        return recieverChatContact.unseenMessages;
      }
    } catch (e) {
      return 0;
    }
  }

  void decrementUnseenMessages(BuildContext context, String recieverId) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverId)
          .update({'unseenMessages': 0});
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
