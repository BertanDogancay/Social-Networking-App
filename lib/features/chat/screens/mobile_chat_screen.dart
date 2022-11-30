import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat_app/common/utils/colors.dart';
import 'package:private_chat_app/common/widgets/loader.dart';
import 'package:private_chat_app/features/auth/controller/auth_controller.dart';
import 'package:private_chat_app/features/call/controller/call_controller.dart';
import 'package:private_chat_app/features/call/screens/call_pickup_screen.dart';
import 'package:private_chat_app/models/user_model.dart';
import 'package:private_chat_app/features/chat/widgets/chat_list.dart';
import '../widgets/bottom_chat_field.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  final String profilePic;
  final bool isGroupChat;
  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.isGroupChat,
  }) : super(key: key);

  void createCall(WidgetRef ref, BuildContext context) {
    ref
        .read(callControllerProvider)
        .createCall(context, name, uid, profilePic, isGroupChat);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CallPickupScreen(
      isGroupCall: isGroupChat,
      scaffold: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: isGroupChat
              ? Text(name)
              : StreamBuilder<UserModel>(
                  stream: ref.read(authControllerProvider).userDataById(uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loader();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                        ),
                        snapshot.data!.isOnline
                            ? const Text('online',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.green))
                            : Text('offline',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.yellow.shade700))
                      ],
                    );
                  }),
          centerTitle: false,
          actions: [
            IconButton(
                onPressed: () => createCall(ref, context),
                icon: const Icon(Icons.video_call)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/backgroundImage.png"),
              fit: BoxFit.cover
            )
          ),
          child: Column(
            children: [
              Expanded(
                  child: ChatList(recieverUserId: uid, isGroupChat: isGroupChat)),
              BottomChatField(recieverUserId: uid, isGroupChat: isGroupChat)
            ],
          ),
        ),
      ),
    );
  }
}
