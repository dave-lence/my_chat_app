import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/common/enum/message_enum.dart';
import 'package:my_chat/features/chats/widgets/video_player_item.dart';
import 'package:uuid/uuid.dart';

class TextFileWidget extends ConsumerWidget {
  final String message;
  final MessageEnum type;
  const TextFileWidget({super.key, required this.message, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String audioPlayerId = const Uuid().v1();
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer(
      playerId: audioPlayerId,
    );

    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : type == MessageEnum.audio
            ? StatefulBuilder(builder: (context, setState) {
                return IconButton(
                  constraints: const BoxConstraints(
                    minWidth: 100,
                  ),
                  onPressed: () async {
                    if (isPlaying) {
                      await audioPlayer.pause();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      await audioPlayer.play(
                        UrlSource(message),
                        volume: 1,
                      );
                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },
                  icon: Icon(
                    isPlaying ? Icons.pause_circle : Icons.play_circle,
                  ),
                );
              })
            : type == MessageEnum.video
                ? VideoPlayerItem(videoUrl: message)
                : type == MessageEnum.gif
                    ? CachedNetworkImage(
                        imageUrl: message,
                        height: 300,
                        fit: BoxFit.contain,
                      )
                    : CachedNetworkImage(
                        fit: BoxFit.contain, height: 300, imageUrl: message);
  }
}
