import 'package:flutter/cupertino.dart';

class VideoModel {
  final String channelID;
  final String channelName;
  final String channelImage;
  final String videoTitle;
  final String videoURL;
  final String mp4URL;
  final String thumbNail;
  bool sub;
  final String videoId;
  final String videoUuid;

  VideoModel(
      {@required this.channelID,
      @required this.channelName,
      @required this.channelImage,
      @required this.videoTitle,
      @required this.videoURL,
      @required this.mp4URL,
      @required this.videoId,
      @required this.thumbNail,
      @required this.sub,
      @required this.videoUuid});

  factory VideoModel.fromJson({@required Map<String, dynamic> json, @required subArray}) {
    return VideoModel(
      channelID: json['channelID'],
      channelName: json['channelName'],
      channelImage: json['channelImage'],
      videoTitle: json['videoTitle'],
      videoURL: json['videoURL'],
      mp4URL: json['mp4URL'][0],
      videoId: json['videoID'],
      thumbNail: json['thumbNail'].length > 0 ? json['thumbNail'][0] : "",
      sub: json['channelID'] == "" || subArray == null ||
                  subArray.length == 0
              ? false
              : subArray.contains(json['channelID']),
      videoUuid: json['videoUUID'],
    );
  }
}
