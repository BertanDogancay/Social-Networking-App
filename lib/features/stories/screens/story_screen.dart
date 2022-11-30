import 'package:flutter/material.dart';
import 'package:private_chat_app/common/widgets/loader.dart';
import 'package:private_chat_app/models/story_model.dart';
import 'package:story_view/story_view.dart';

class StoryScreen extends StatefulWidget {
  static const String routeName = '/story-screen';
  final StoryModel story;
  const StoryScreen({Key? key, required this.story}) : super(key: key);

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  StoryController controller = StoryController();
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    super.initState();
    initStoryPageItems();
  }

  void initStoryPageItems() {
    for (int i = 0; i < widget.story.photoUrl.length; i++) {
      storyItems.add(StoryItem.pageImage(
          url: widget.story.photoUrl[i], controller: controller));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItems.isEmpty
          ? const Loader()
          : StoryView(
              storyItems: storyItems,
              controller: controller,
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              },
            ),
    );
  }
}
