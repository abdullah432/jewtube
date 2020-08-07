import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jewtube/model/video.dart';
import 'package:jewtube/model/channel.dart';
import 'package:jewtube/util/Resources.dart';
import 'package:jewtube/model/downloaded_files.dart';
import 'package:jewtube/util/sqflite_helper.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';

Future<Map> getVideos(String path, {bool needSubsInQuery = false}) async {
  List<VideoModel> videoList = List();
  List<Channel> channelList = List();
  List<String> channelIDs = List();
  var subArray = List();

  //retrieve subscribed channel list
  //retrieve subarray will be used to determined as the video channel is subscribed or not
  if (Resources.userID != "") {
    Response sub = await Dio()
        .get("http://${Resources.BASE_URL}/subscribe/${Resources.userID}");

    if (sub.data != null) {
      // print("Sub.data: "+sub.data);
      subArray = sub.data['channel'];
    }
  }

  // print("needSubsInQuery: "+needSubsInQuery.toString());
  // print("Subscribed channels"+subArray.toString());


  Response response;
  // print("getvideos Path: "+path);

  if (needSubsInQuery) {
    //if need only subscribe channel videos
    response = await Dio().post(path, data: {"channelIDs": subArray});
  } else {
    response = await Dio().get(path);
  }
  // print("Response Data");
  // print(response.data);
  if (response.data != null && response.data is List) {
    response.data.forEach((video) {
      // print("subarray: "+subArray.length.toString());
      // print("channelID: "+video['channelID'].toString());
      // print("thumbnails: "+video["thumbNail"].length.toString());
      // print("mp4URL: "+video["mp4URL"].toString());
      // print("mp4URL Length: "+video["mp4URL"].length.toString());
      // print("after");
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
          mp4URL: video['mp4URL'][0], //sometime mp4 array can contain 2 files
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

Future<void> loadDownloadedFilesList() {
  DatabaseHelper databaseHelper = DatabaseHelper();
  final Future<Database> dbFuture = databaseHelper.initializeDatabase();
  dbFuture.then((database) {
    Future<List<DownloadedFile>> filesListFuture =
        databaseHelper.getDownloadedFilesList();
    filesListFuture.then((downloadedFileList) {
      Resources.listOfDownloadedFiles = downloadedFileList;
      //debug
      print('ListOfDownloadFile: '+Resources.listOfDownloadedFiles.toString());
    });
  });

}

showToast({@required String message}) {
  Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
}