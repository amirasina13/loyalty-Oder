import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../app_setting/app_setting.dart';

class YoutubePlayerCustom extends StatefulWidget {
  final String? videoUrl;

  const YoutubePlayerCustom({super.key, this.videoUrl});

  @override
  State<YoutubePlayerCustom> createState() => YoutubePlayerCustomState();
}

class YoutubePlayerCustomState extends State<YoutubePlayerCustom> {
  late YoutubePlayerController controller;
  late PlayerState playerState;
  late YoutubeMetaData videoMetaData;
  double volume = 100;
  bool muted = false;
  bool isPlayerReady = false;
  String videoId = '';

  @override
  void initState() {
    super.initState();

    videoId = YoutubePlayer.convertUrlToId(widget.videoUrl!)!;

    controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    // _idController = TextEditingController();
    // _seekToController = TextEditingController();
    videoMetaData = const YoutubeMetaData();
    playerState = PlayerState.unknown;
  }

  void listener() {
    if (isPlayerReady && mounted && !controller.value.isFullScreen) {
      setState(() {
        playerState = controller.value.playerState;
        videoMetaData = controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    if (controller.value.isPlaying) {
      controller.pause();
    }
    controller.dispose();
    super.dispose();
  }

  void stopVideoYoutube() {
    // ignore: unnecessary_null_comparison
    if (controller != null) {
      controller.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get the container width and calculate height for 16:9 ratio
        final double width = constraints.maxWidth;
        final double height = width * 9 / 16;

        return YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: controller,
            showVideoProgressIndicator: true,
          ),
          builder: (context, player) {
            return Container(
              width: width,
              height: height,
              color: colorBlack,
              child: Center(child: player),
            );
          },
        );
      },
    );
  }
}
