import 'package:flutter/material.dart';
import 'package:private_chat_app/common/utils/colors.dart';
import 'package:private_chat_app/common/enums/message_enum.dart';
import 'package:private_chat_app/features/chat/widgets/display_text_image_gif.dart';
import 'package:swipe_to/swipe_to.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onLeftSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;
  final bool isSeen;

  const MyMessageCard(
      {Key? key,
      required this.message,
      required this.date,
      required this.type,
      required this.onLeftSwipe,
      required this.repliedText,
      required this.username,
      required this.repliedMessageType,
      required this.isSeen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;
    return SwipeTo(
      onLeftSwipe: onLeftSwipe,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 100, minWidth: 150),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: mainColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                    padding: type == MessageEnum.text
                        ? const EdgeInsets.only(
                            left: 5,
                            right: 25,
                            top: 5,
                            bottom: 20,
                          )
                        : const EdgeInsets.only(
                            left: 5, top: 5, right: 5, bottom: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                  username,
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
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.done_all,
                        size: 20,
                        color: isSeen ? Colors.blue : Colors.white60,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
