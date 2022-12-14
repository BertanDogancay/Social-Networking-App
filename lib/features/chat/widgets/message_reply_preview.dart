import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat_app/common/utils/colors.dart';
import 'package:private_chat_app/common/providers/message_reply_provider.dart';
import 'package:private_chat_app/features/chat/widgets/display_text_image_gif.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({Key? key}) : super(key: key);

  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);
    return Container(
      width: 350,
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                messageReply!.isMe ? 'Me' : 'Other',
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
              GestureDetector(
                onTap: () => cancelReply(ref),
                child: const Icon(
                  Icons.close,
                  size: 16,
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: 300,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: backgroundColor),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DisplayTextImageGIF(
                  message: messageReply.message,
                  type: messageReply.messageEnum),
            ),
          )
        ],
      ),
    );
  }
}
