// ignore_for_file: prefer_const_constructors

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late CachedVideoPlayerController videoPlayerController;
  bool isPlay = false;

  @override
  void initState() {
    super.initState();
    videoPlayerController = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.setLooping(true);
        videoPlayerController.setVolume(1);
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: videoPlayerController.value.aspectRatio,
          child: Stack(
            children: [
              CachedVideoPlayer(videoPlayerController),
              Align(
                alignment: Alignment.center,
                child: IconButton(
                  onPressed: () {
                    if (isPlay) {
                      videoPlayerController.pause();
                    } else {
                      videoPlayerController.play();
                    }
        
                    setState(() {
                      isPlay = !isPlay;
                    });
                  },
                  icon: Icon(
                    isPlay ? Icons.pause_circle : Icons.play_circle,
                  ),
                ),
              ),
            ],
          ),
        ),
         Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.replay_10),
              onPressed: () {
                videoPlayerController.seekTo(Duration(seconds: videoPlayerController.value.position.inSeconds - 10));
              },
            ),
            IconButton(
              icon: const Icon(Icons.forward_10),
              onPressed: () {
                videoPlayerController.seekTo(Duration(seconds: videoPlayerController.value.position.inSeconds + 10));
              },
            ),
          ],
        ),
        if (videoPlayerController.value.isInitialized)
          VideoProgressIndicator(
            colors: VideoProgressColors(
              playedColor: Colors.white
            ),
            videoPlayerController,
            allowScrubbing: true,
          ),
      ],
    );
  }
}
