import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat_app/common/repositories/common_firebase_storage_repository.dart';
import 'package:private_chat_app/common/utils/utils.dart';
import 'package:private_chat_app/models/story_model.dart';
import 'package:private_chat_app/models/story_seen_model.dart';
import 'package:private_chat_app/models/user_model.dart';
import 'package:uuid/uuid.dart';

final storyRepositoryProvider = Provider((ref) => StoryRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref));

class StoryRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;
  StoryRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void uploadStory(
      {required String username,
      required String profilePic,
      required String phoneNumber,
      required File storyImage,
      required BuildContext context}) async {
    try {
      var storyId = const Uuid().v4();
      String uid = auth.currentUser!.uid;
      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase('/stories/$storyId$uid', storyImage);
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      List<String> uidAccessed = [];
      List<StorySeenModel> seenList = [];
      for (int i = 0; i < contacts.length; i++) {
        var userDataFirebase = await firestore
            .collection('users')
            .where('phoneNumber',
                isEqualTo: contacts[i]
                    .phones[0]
                    .number
                    .replaceAll(' ', '')
                    .replaceAll('-', '')
                    .replaceAll('(', '')
                    .replaceAll(')', ''))
            .get();
        if (userDataFirebase.docs.isNotEmpty) {
          var userData = UserModel.fromMap(userDataFirebase.docs[0].data());
          var userSeen = StorySeenModel(userId: userData.uid, isSeen: false);
          uidAccessed.add(userData.uid);
          seenList.add(userSeen);
        }
      }
      List<String> storyImageUrls = [];
      var storiesSnapshot = await firestore
          .collection('stories')
          .where('uid', isEqualTo: auth.currentUser!.uid)
          .get();
      if (storiesSnapshot.docs.isNotEmpty) {
        StoryModel story = StoryModel.fromMap(storiesSnapshot.docs[0].data());
        storyImageUrls = story.photoUrl;
        storyImageUrls.add(imageUrl);
        await firestore
            .collection('stories')
            .doc(storiesSnapshot.docs[0].id)
            .update({
          'photoUrl': storyImageUrls,
          'seen': seenList.map((e) => e.toMap()).toList()
        });
        return;
      } else {
        storyImageUrls = [imageUrl];
      }
      StoryModel story = StoryModel(
          uid: uid,
          username: username,
          phoneNumber: phoneNumber,
          photoUrl: storyImageUrls,
          createdAt: DateTime.now(),
          profilePic: profilePic,
          storyId: storyId,
          seen: seenList,
          usersAccessed: uidAccessed);
      await firestore.collection('stories').doc(storyId).set(story.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<StoryModel>> getStories(BuildContext context) async {
    List<StoryModel> storyData = [];
    try {
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      for (int i = 0; i < contacts.length; i++) {
        var storiesSnapshot = await firestore
            .collection('stories')
            .where('phoneNumber',
                isEqualTo: contacts[i]
                    .phones[0]
                    .number
                    .replaceAll(' ', '')
                    .replaceAll('-', '')
                    .replaceAll('(', '')
                    .replaceAll(')', ''))
            .where('createdAt',
                isGreaterThan: DateTime.now()
                    .subtract(const Duration(hours: 24))
                    .millisecondsSinceEpoch)
            .get();
        for (var tempData in storiesSnapshot.docs) {
          StoryModel tempStory = StoryModel.fromMap(tempData.data());
          if (tempStory.usersAccessed.contains(auth.currentUser!.uid)) {
            storyData.add(tempStory);
          }
        }
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    return storyData;
  }

  void setStorySeen(BuildContext context, String storyId) async {
    var storySnapshot =
        await firestore.collection('stories').doc(storyId).get();
    StoryModel story = StoryModel.fromMap(storySnapshot.data()!);
    for (var element in story.seen) {
      if (element.userId == auth.currentUser!.uid) {
        if (element.isSeen) return;
        element.isSeen = true;
        break;
      }
    }
    await firestore
        .collection('stories')
        .doc(storyId)
        .update({'seen': story.seen.map((x) => x.toMap()).toList()});
  }
}
