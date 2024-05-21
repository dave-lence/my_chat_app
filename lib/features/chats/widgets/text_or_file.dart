import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/common/enum/message_enum.dart';
import 'package:my_chat/features/chats/widgets/video_player_item.dart';

class TextFileWidget extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const TextFileWidget({super.key, required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        :  type == MessageEnum.video
                ? VideoPlayerItem(videoUrl: message)
                : type == MessageEnum.gif
            ? CachedNetworkImage(
                imageUrl: message,
              )
            : CachedNetworkImage(
                    fit: BoxFit.contain, height: 300, imageUrl: message);
  }
}
