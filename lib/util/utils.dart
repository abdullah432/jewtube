import 'dart:convert';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jewtube/model/video.dart';
import 'package:jewtube/model/channel.dart';
import 'package:jewtube/util/Resources.dart';
import 'package:jewtube/util/utils.dart';
import 'package:jewtube/view/videoPlay.dart';
import 'package:jewtube/widgets/videoItemWidget.dart';

Future<Map> getVideos(String path, {bool needSubsInQuery = false}) async {
  List<VideoModel> videoList = List();
  List<Channel> channelList = List();
  List<String> channelIDs = List();
  var subArray = List();
  if (Resources.userID != "") {
    Response sub = await Dio()
        .get("http://${Resources.BASE_URL}/subscribe/${Resources.userID}");
        
    print(sub.data);
    if (sub.data != null) {
      subArray = sub.data['channel'];
    }
  }

  Response response;
  print(needSubsInQuery);
  print(path);
    print(subArray);
  if (needSubsInQuery) {
    response = await Dio().post(path, data: {"channelIDs": subArray});
  } else {
    response = await Dio().get(path);
  }
   print("QQQQQQQQQQQQQQQQQQQQQQQQQQ");
  print(response.data);
  if (response.data != null && response.data is List) {
    response.data.forEach((video) {
      if (!channelIDs.contains(video['channelID'])) {
        channelIDs.add(video['channelID']);
        channelList.add(Channel(
            channelID: video['channelID'],
            channelName: video['channelName'],
            imgUrl: video['channelImage']));
      }
      videoList.add(VideoModel(
          channelID: video['channelID'],
          channelName: video['channelName'],
          channelImage: video['channelImage'],
          videoTitle: video['videoTitle'],
          videoURL: video['videoURL'],
          videoId: video['videoID'],
          videoUuid: video['videoUUID'],
          sub: video['channelID'] == "" ||
                  subArray == null ||
                  subArray.length == 0
              ? false
              : subArray.contains(video['channelID']),
          thumbNail:
              video['thumbNail'].length > 0 ? video['thumbNail'][0] : ""));
    });

    // print(jsonEncode(_videoList));

    // return null;
  }

  Map map = Map();
  map['videos'] = videoList;
  map['channels'] = channelList;
  return map;
}
