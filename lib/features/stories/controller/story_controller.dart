import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat_app/features/auth/controller/auth_controller.dart';
import 'package:private_chat_app/features/stories/repository/story_repository.dart';

import '../../../models/story_model.dart';

final storyControllerProvider = Provider((ref) {
  final storyRepository = ref.read(storyRepositoryProvider);
  return StoryController(storyRepository: storyRepository, ref: ref);
});

class StoryController {
  final StoryRepository storyRepository;
  final ProviderRef ref;
  StoryController({
    required this.storyRepository,
    required this.ref,
  });

  void addStory(File file, BuildContext context) {
    ref.watch(userDataAuthProvider).whenData((value) => {
          storyRepository.uploadStory(
              username: value!.name,
              profilePic: value.profilePic,
              phoneNumber: value.phoneNumber,
              storyImage: file,
              context: context)
        });
  }

  Future<List<StoryModel>> getStories(BuildContext context) async {
    List<StoryModel> stories = await storyRepository.getStories(context);
    return stories;
  }

  void setStorySeen(BuildContext context, String storyId) {
    storyRepository.setStorySeen(context, storyId);
  }
}
