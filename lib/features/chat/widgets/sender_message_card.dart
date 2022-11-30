import 'package:flutter/material.dart';
import 'package:private_chat_app/common/utils/colors.dart';
import 'package:private_chat_app/features/chat/widgets/display_text_image_gif.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../common/enums/message_enum.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard(
      {Key? key,
      required this.message,
      required this.senderName,
      required this.date,
      required this.type,
      required this.onRightSwipe,
      required this.repliedText,
      required this.repliedTo,
      required this.repliedMessageType,
      required this.isGroupChat})
      : super(key: key);
  final String message;
  final String senderName;
  final String date;
  final MessageEnum type;
  final VoidCallback onRightSwipe;
  final String repliedText;
  final String repliedTo;
  final MessageEnum repliedMessageType;
  final bool isGroupChat;

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;
    return SwipeTo(
      onRightSwipe: onRightSwipe,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 100, minWidth: 150),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: senderMessageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                    padding: type == MessageEnum.text
                        ? const EdgeInsets.only(
                            left: 5,
                            right: 30,
                            top: 5,
                            bottom: 20,
                          )
                        : const EdgeInsets.only(
                            left: 5, top: 5, right: 5, bottom: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isGroupChat) ...[
                          Text(
                            senderName,
                            style: TextStyle(fontSize: 13, color: mainColor),
                          ),
                        ],
                        if (isReplying) ...[
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: backgroundColor.withOpacity(0.5),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  repliedTo,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: Colors.orange),
                                ),
                                DisplayTextImageGIF(
                                    message: repliedText,
                                    type: repliedMessageType),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8)
                        ],
                        DisplayTextImageGIF(message: message, type: type),
                      ],
                    )),
                Positioned(
                    bottom: 2,
                    right: 10,
                    child: Text(
                      date,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
