import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:private_chat_app/common/utils/colors.dart';
import 'package:private_chat_app/common/widgets/loader.dart';
import 'package:private_chat_app/features/chat/controller/chat_controller.dart';
import 'package:private_chat_app/features/chat/screens/mobile_chat_screen.dart';
import 'package:private_chat_app/models/chat_contact_model.dart';

class ContactsList extends ConsumerStatefulWidget {
  const ContactsList({Key? key}) : super(key: key);
  
  @override
  ConsumerState<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends ConsumerState<ContactsList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SingleChildScrollView(
        child: Column(children: [
          StreamBuilder<List<ChatContactModel>>(
              stream: ref.watch(chatControllerProvider).getChatContacts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var chatContactData = snapshot.data![index];
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            ref
                                .read(chatControllerProvider)
                                .decrementUnseenMessages(
                                    context, chatContactData.contactId);
                            Navigator.pushNamed(
                                context, MobileChatScreen.routeName,
                                arguments: {
                                  'name': chatContactData.name,
                                  'uid': chatContactData.contactId,
                                  'profilePic': chatContactData.profilePic,
                                  'isGroupChat': false
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              title: Text(
                                chatContactData.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: chatContactData.unseenMessages > 0 ? AnimatedTextKit(
                                  totalRepeatCount: 1,
                                  animatedTexts: [
                                    TypewriterAnimatedText(
                                      chatContactData.lastMessage,
                                      speed: const Duration(milliseconds: 80))
                                  ],
                                ) : Text(chatContactData.lastMessage)
                              ),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  chatContactData.profilePic,
                                ),
                                radius: 30,
                              ),
                              trailing: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  chatContactData.unseenMessages > 0
                                      ? CircleAvatar(
                                          backgroundColor: mainColor,
                                          radius: 10,
                                          child: Text(
                                            chatContactData.unseenMessages
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        )
                                      : const CircleAvatar(
                                          backgroundColor: backgroundColor,
                                          radius: 5,
                                        ),
                                  Text(
                                    DateFormat.Hm()
                                        .format(chatContactData.timeSent),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Divider(color: dividerColor, indent: 85),
                      ],
                    );
                  },
                );
              }),
        ]),
      ),
    );
  }
}
