import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final XFile video;

  const CustomVideoPlayer({Key? key, required this.video}) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {

  VideoPlayerController? videoPlayerController;

  @override
  void initState() {
    super.initState();
    // initializeController 가 끝날 때 까지 기다리지는 않는다 (비동기이기 때문에)
    initializeController();
  }

  initializeController() async {
    videoPlayerController = VideoPlayerController.file(
        File(widget.video.path)
    );

    await videoPlayerController!.initialize();

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    if(videoPlayerController == null) {
      return const CircularProgressIndicator();
    }
    return AspectRatio(
      aspectRatio: videoPlayerController!.value.aspectRatio, // 비율 설정
        child: Stack(
          children: [
            VideoPlayer(videoPlayerController!),
            _Controls(
                onPlayPressed: onPlayPressed,
                onForwardPressed: onForwardPressed,
                onReversePressed: onReversePressed,
                isPlaying: videoPlayerController!.value.isPlaying,
            ),
            Positioned(
              right:0,
              child: IconButton(
                  onPressed: (){},
                  color: Colors.white,
                  icon: Icon(Icons.photo_camera_back)),
            )
          ],
        ));
  }

  void onForwardPressed() {
    final maxPosition = videoPlayerController!.value.duration;
    final currentPosition = videoPlayerController!.value.position;

    print("maxPosition : $maxPosition , currentPosition : $currentPosition");

    Duration position = maxPosition;
    if((maxPosition - Duration(seconds: 3)).inSeconds > currentPosition.inSeconds ){
      position = currentPosition + Duration(seconds: 3);
    }
    videoPlayerController!.seekTo(position);
    setState( () {
      if(maxPosition <= position) {
          videoPlayerController!.pause();
          videoPlayerController!.initialize();
      }
    });
  }

  void onPlayPressed() {
    setState(() {
      // 이미 실행중이면 중지
      if(videoPlayerController!.value.isPlaying) {
        videoPlayerController!.pause();
      } else { // 실행중이 아니면 중지
        videoPlayerController!.play();
      }
    });
  }

  void onReversePressed() {
    final currentPosition = videoPlayerController!.value.position;

    Duration position = Duration();
    if(currentPosition.inSeconds > 3 ){
      position = currentPosition - Duration(seconds: 3);
    }
    videoPlayerController!.seekTo(position);
  }
}

class _Controls extends StatelessWidget {

  final VoidCallback onPlayPressed;
  final VoidCallback onForwardPressed;
  final VoidCallback onReversePressed;
  final bool isPlaying;


  const _Controls({
    required this.onPlayPressed,
    required this.onForwardPressed,
    required this.onReversePressed,
    required this.isPlaying,
    Key? key
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          renderIconButton(onPressed: onReversePressed, iconData: Icons.rotate_left),
          renderIconButton(onPressed: onPlayPressed, iconData: isPlaying ? Icons.pause : Icons.play_arrow),
          renderIconButton(onPressed: onForwardPressed, iconData: Icons.rotate_right),
        ],
      ),
    );


  }
  Widget renderIconButton({
    required VoidCallback onPressed,
    required IconData iconData,
  }) {

    return IconButton(
        onPressed: onPressed,
        iconSize: 30.0,
        color: Colors.white,
        icon: Icon(iconData)
    );

  }

}

