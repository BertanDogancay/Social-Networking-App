import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat_app/common/utils/colors.dart';
import 'package:private_chat_app/features/stories/controller/story_controller.dart';

class ConfirmStoryScreen extends ConsumerWidget {
  static const String routeName = '/confirm-story-screen';
  final File file;
  const ConfirmStoryScreen({Key? key, required this.file}) : super(key: key);

  void addStory(WidgetRef ref, BuildContext context) {
    ref.read(storyControllerProvider).addStory(file, context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Image.file(file),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addStory(ref, context),
        backgroundColor: tabColor,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
