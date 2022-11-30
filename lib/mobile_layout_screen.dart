import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat_app/common/utils/colors.dart';
import 'package:private_chat_app/common/utils/utils.dart';
import 'package:private_chat_app/features/auth/controller/auth_controller.dart';
import 'package:private_chat_app/features/group/screens/create_group_screen.dart';
import 'package:private_chat_app/features/group/screens/groups_list_screen.dart';
import 'package:private_chat_app/features/select_contacts/screens/select_contact_screen.dart';
import 'package:private_chat_app/features/chat/widgets/contacts_list.dart';
import 'package:private_chat_app/features/settings/screens/settings_screen.dart';
import 'package:private_chat_app/features/stories/screens/confirm_story_screen.dart';
import 'package:private_chat_app/features/stories/screens/stories_screen.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          centerTitle: false,
          title: Text(
            'Private Chat',
            style: TextStyle(
              fontSize: 20,
              color: mainColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
            PopupMenuButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                ),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.group_add_outlined, color: mainColor),
                            const Text('Create Group'),
                          ],
                        ),
                        onTap: () => Future(() => Navigator.pushNamed(
                            context, CreateGroupScreen.routeName)),
                      ),
                      PopupMenuItem(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.settings, color: mainColor),
                            const Text('Settings')
                          ],
                        ),
                        onTap: () => Future(() => Navigator.pushNamed(context, SettingsScreen.routeName)),
                      )
                    ])
          ],
          bottom: TabBar(
            controller: tabController,
            indicatorColor: mainColor,
            indicatorWeight: 4,
            labelColor: mainColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(
                text: 'CHATS',
              ),
              Tab(
                text: 'GROUPS',
              ),
              Tab(
                text: 'STORIES',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: const [ContactsList(), GroupsListScreen(), StoriesScreen()],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (tabController.index == 0) {
              Navigator.pushNamed(context, SelectContactScreen.routeName);
            } else {
              File? pickedImage = await pickImageFromGallery(context);
              if (pickedImage != null) {
                // ignore: use_build_context_synchronously
                Navigator.pushNamed(context, ConfirmStoryScreen.routeName,
                    arguments: pickedImage);
              }
            }
          },
          backgroundColor: mainColor,
          child: const Icon(
            Icons.message,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
