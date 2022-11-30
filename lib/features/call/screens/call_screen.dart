import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat_app/common/widgets/loader.dart';
import 'package:private_chat_app/config/agora_config.dart';
import 'package:private_chat_app/features/call/controller/call_controller.dart';
import 'package:private_chat_app/models/call_model.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String channelId;
  final CallModel call;
  final bool isGroupCall;
  const CallScreen({
    Key? key,
    required this.channelId,
    required this.call,
    required this.isGroupCall,
  }) : super(key: key);

  @override
  ConsumerState<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  AgoraClient? client;
  String baseUrl = 'http://data.zenexserver.com';

  @override
  void initState() {
    super.initState();
    client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
            appId: AgoraConfig.appId,
            channelName: widget.channelId,
            tokenUrl: baseUrl));
    initAgora();
  }

  void initAgora() async {
    await client!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: client == null
          ? const Loader()
          : SafeArea(
              child: Stack(
              children: [
                AgoraVideoViewer(client: client!),
                AgoraVideoButtons(
                  client: client!,
                  disconnectButtonChild: IconButton(
                      onPressed: () async {
                        await client!.engine.leaveChannel();
                        // ignore: use_build_context_synchronously
                        ref.read(callControllerProvider).endCall(
                            context,
                            widget.call.callerId,
                            widget.call.recieverId,
                            widget.isGroupCall);
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.call_end)),
                ),
              ],
            )),
    );
  }
}
