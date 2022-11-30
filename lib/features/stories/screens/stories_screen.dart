import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat_app/common/utils/colors.dart';
import 'package:private_chat_app/common/widgets/loader.dart';
import 'package:private_chat_app/features/stories/controller/story_controller.dart';
import 'package:private_chat_app/features/stories/screens/story_screen.dart';
import 'package:private_chat_app/models/story_model.dart';
import 'package:private_chat_app/models/story_seen_model.dart';

class StoriesScreen extends ConsumerStatefulWidget {
  static const String routeName = '/stories-screen';
  const StoriesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends ConsumerState<StoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<StoryModel>>(
      future: ref.watch(storyControllerProvider).getStories(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var storyData = snapshot.data![index];
            StorySeenModel a = storyData.seen.firstWhere((element) =>
                element.userId == FirebaseAuth.instance.currentUser!.uid);
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      ref
                          .read(storyControllerProvider)
                          .setStorySeen(context, storyData.storyId);
                      setState(() {});
                      Navigator.pushNamed(context, StoryScreen.routeName,
                          arguments: storyData);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        title: Text(
                          storyData.username,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue,
                          child: CircleAvatar(
                            radius: a.isSeen ? 30 : 25,
                            backgroundImage: NetworkImage(storyData.profilePic),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(color: dividerColor, indent: 85),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
