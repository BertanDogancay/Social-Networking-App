import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class DisplayVideo extends StatefulWidget {
  final String videoUrl;
  const DisplayVideo({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<DisplayVideo> createState() => _DisplayVideoState();
}

class _DisplayVideoState extends State<DisplayVideo> {
  late CachedVideoPlayerController videoPlayerController;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    videoPlayerController = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.setVolume(1);
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          CachedVideoPlayer(videoPlayerController),
          Align(
              alignment: Alignment.center,
              child: IconButton(
                  onPressed: () {
                    if (isPlaying) {
                      videoPlayerController.pause();
                    } else {
                      videoPlayerController.play();
                    }
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                  },
                  icon:
                      Icon(isPlaying ? Icons.pause_circle : Icons.play_circle)))
        ],
      ),
    );
  }
}
