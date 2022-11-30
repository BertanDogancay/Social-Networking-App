import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat_app/features/auth/controller/auth_controller.dart';
import 'package:private_chat_app/features/call/repository/call_repository.dart';
import 'package:private_chat_app/models/call_model.dart';
import 'package:uuid/uuid.dart';

final callControllerProvider = Provider((ref) {
  final callRepository = ref.read(callRepositoryProvider);
  return CallController(
      callRepository: callRepository, auth: FirebaseAuth.instance, ref: ref);
});

class CallController {
  final CallRepository callRepository;
  final ProviderRef ref;
  final FirebaseAuth auth;
  CallController(
      {required this.callRepository, required this.ref, required this.auth});

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;

  void createCall(BuildContext context, String recieverName, String recieverId,
      String recieverPic, bool isGroupCall) {
    ref.read(userDataAuthProvider).whenData((value) {
      String callId = const Uuid().v4();
      CallModel senderCallData = CallModel(
          callerId: auth.currentUser!.uid,
          callerName: value!.name,
          callerPic: value.profilePic,
          recieverId: recieverId,
          recieverName: recieverName,
          recieverPic: recieverPic,
          callId: callId,
          hasDialled: true);
      CallModel recieverCallData = CallModel(
          callerId: auth.currentUser!.uid,
          callerName: value.name,
          callerPic: value.profilePic,
          recieverId: recieverId,
          recieverName: recieverName,
          recieverPic: recieverPic,
          callId: callId,
          hasDialled: false);

      if (isGroupCall) {
        callRepository.createGroupCall(
            context, senderCallData, recieverCallData);
      } else {
        callRepository.createCall(context, senderCallData, recieverCallData);
      }
    });
  }

  void endCall(BuildContext context, String callerId, String recieverId,
      bool isGroupCall) {
    if (isGroupCall) {
      callRepository.endGroupCall(context, callerId, recieverId);
    } else {
      callRepository.endCall(context, callerId, recieverId);
    }
  }
}
