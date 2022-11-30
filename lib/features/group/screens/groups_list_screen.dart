import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:private_chat_app/common/utils/colors.dart';
import 'package:private_chat_app/common/widgets/loader.dart';
import 'package:private_chat_app/features/chat/controller/chat_controller.dart';
import 'package:private_chat_app/features/chat/screens/mobile_chat_screen.dart';
import 'package:private_chat_app/models/group_model.dart';

class GroupsListScreen extends ConsumerWidget {
  const GroupsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SingleChildScrollView(
        child: Column(children: [
          StreamBuilder<List<GroupModel>>(
              stream: ref.watch(chatControllerProvider).getChatGroups(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var groupData = snapshot.data![index];
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, MobileChatScreen.routeName,
                                arguments: {
                                  'name': groupData.groupName,
                                  'uid': groupData.groupId,
                                  'profilePic': groupData.groupPic,
                                  'isGroupChat': true
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              title: Text(
                                groupData.groupName,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Text(
                                  groupData.lastMessage,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  groupData.groupPic,
                                ),
                                radius: 30,
                              ),
                              trailing: Text(
                                DateFormat.Hm().format(groupData.timeSent),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
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