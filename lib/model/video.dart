import 'package:flutter/cupertino.dart';

class VideoModel {
  VideoModel(
      {@required this.channelID,
      @required this.channelName,
      @required this.channelImage,
      @required this.videoTitle,
      @required this.videoURL,
      @required this.videoId,
      @required this.thumbNail,
      @required this.sub,
      @required this.videoUuid});

  final String channelID;
  final String channelName;
  final String channelImage;
  final String videoTitle;
  final String videoURL;
  final String thumbNail;
  bool sub;
  final String videoId;
  final String videoUuid;
}
