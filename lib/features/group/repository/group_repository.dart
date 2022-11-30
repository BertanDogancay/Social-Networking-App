import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat_app/common/repositories/common_firebase_storage_repository.dart';
import 'package:private_chat_app/common/utils/utils.dart';
import 'package:private_chat_app/models/group_model.dart';
import 'package:uuid/uuid.dart';

final groupRepositoryProvider = Provider((ref) => GroupRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref));

class GroupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;
  GroupRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void createGroup(BuildContext context, String groupName, File groupPic,
      List<Contact> selectedContacts) async {
    try {
      List<String> contactUids = [];
      for (int i = 0; i < selectedContacts.length; i++) {
        var userCollection = await firestore
            .collection('users')
            .where('phoneNumber',
                isEqualTo: selectedContacts[i]
                    .phones[0]
                    .number
                    .replaceAll(' ', '')
                    .replaceAll('-', '')
                    .replaceAll('(', '')
                    .replaceAll(')', ''))
            .get();
        if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
          contactUids.add(userCollection.docs[0].data()['uid']);
        }
      }
      var groupId = const Uuid().v4();
      String groupPicUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase('groups/$groupId', groupPic);
      GroupModel group = GroupModel(
          groupName: groupName,
          groupId: groupId,
          groupPic: groupPicUrl,
          senderId: auth.currentUser!.uid,
          lastMessage: '',
          memberUids: [auth.currentUser!.uid, ...contactUids],
          timeSent: DateTime.now());

      await firestore.collection('groups').doc(groupId).set(group.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
