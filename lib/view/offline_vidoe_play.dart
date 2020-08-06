import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jewtube/model/video.dart';
import 'package:chewie/chewie.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';

class OfflineVideoPlayer extends StatefulWidget {
  final String oflineVideoPath;
  OfflineVideoPlayer({@required this.oflineVideoPath});
  @override
  _OfflineVideoPlayerState createState() =>
      _OfflineVideoPlayerState(oflineVideoPath);
}

class _OfflineVideoPlayerState extends State<OfflineVideoPlayer>
    with SingleTickerProviderStateMixin {
  VideoModel videoModel;
  bool isOfline;
  String oflineVideoPath;
  _OfflineVideoPlayerState(this.oflineVideoPath);
  //offline file
  File file;

  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    file = File(oflineVideoPath);
    _videoPlayerController = VideoPlayerController.file(file);

    super.initState();

    //
    _chewieController = ChewieController(
      // videoPlayerController: VideoPlayerController.network(videoModel.videoURL)..initialize(),
      videoPlayerController: _videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
      // autoInitialize: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Chewie(
                  controller: _chewieController,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              basenameWithoutExtension(file.path),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
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
