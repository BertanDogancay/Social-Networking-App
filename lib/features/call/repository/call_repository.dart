import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat_app/common/utils/utils.dart';
import 'package:private_chat_app/features/call/screens/call_screen.dart';
import 'package:private_chat_app/models/call_model.dart';
import 'package:private_chat_app/models/group_model.dart';

final callRepositoryProvider = Provider((ref) => CallRepository(
    firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class CallRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  CallRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<DocumentSnapshot> get callStream =>
      firestore.collection('calls').doc(auth.currentUser!.uid).snapshots();

  void createCall(BuildContext context, CallModel senderCallData,
      CallModel recieverCallData) async {
    try {
      await firestore
          .collection('calls')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      await firestore
          .collection('calls')
          .doc(recieverCallData.recieverId)
          .set(recieverCallData.toMap());
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CallScreen(
                  channelId: senderCallData.callId,
                  call: senderCallData,
                  isGroupCall: false)));
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void createGroupCall(BuildContext context, CallModel senderCallData,
      CallModel recieverCallData) async {
    try {
      await firestore
          .collection('calls')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());

      var groupSnapshot = await firestore
          .collection('groups')
          .doc(senderCallData.recieverId)
          .get();
      GroupModel group = GroupModel.fromMap(groupSnapshot.data()!);

      for (var id in group.memberUids) {
        await firestore
            .collection('calls')
            .doc(id)
            .set(recieverCallData.toMap());
      }

      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CallScreen(
                  channelId: senderCallData.callId,
                  call: senderCallData,
                  isGroupCall: true)));
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void endCall(BuildContext context, String callerId, String recieverId) async {
    try {
      await firestore.collection('calls').doc(callerId).delete();
      await firestore.collection('calls').doc(recieverId).delete();
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void endGroupCall(
      BuildContext context, String callerId, String recieverId) async {
    try {
      await firestore.collection('calls').doc(callerId).delete();
      var groupSnapshot =
          await firestore.collection('groups').doc(recieverId).get();
      GroupModel group = GroupModel.fromMap(groupSnapshot.data()!);
      for (var id in group.memberUids) {
        await firestore.collection('calls').doc(id).delete();
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
