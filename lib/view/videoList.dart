import 'dart:convert';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jewtube/model/video.dart';
import 'package:jewtube/util/Resources.dart';
import 'package:jewtube/util/utils.dart';
import 'package:jewtube/view/videoPlay.dart';
import 'package:jewtube/widgets/videoItemWidget.dart';

class VideoListScreen extends StatefulWidget {
  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  List<VideoModel> _videoList = List();
  String url = "http://${Resources.BASE_URL}/video/getvideos";
  bool _progress = true;
  bool init = false;
  @override
  void initState() {
    super.initState();
  }

  Future<Null> getAllVideos() async {
    setState(() {
      _progress = true;
    });
    await getVideos(url).then((value) => {
          if (mounted)
            {
              setState(() {
                _videoList.clear();
                _videoList =  value['videos'];

                // print(jsonEncode(_videoList));
                _progress = false;
              })
            }
        });

    // Response sub = await Dio()
    //     .get("http://${Resources.BASE_URL}/subscribe/${Resources.userID}");
    // print(sub.data);
    // var subArray = List();
    // if (sub.data != null) {
    //   subArray = sub.data['channel'];
    // }
    // Response response =
    //     await Dio().get("http://${Resources.BASE_URL}/video/getvideos");
    // print(response.data);
    // if (response.data != null) {
    //   setState(() {
    //     _videoList.clear();
    //     response.data.forEach((video) {
    //       _videoList.add(VideoModel(
    //           channelID: video['channelID'],
    //           channelName: video['channelName'],
    //           channelImage: video['channelImage'],
    //           videoTitle: video['videoTitle'],
    //           videoURL: video['videoURL'],
    //           videoId: video['videoId'],
    //           sub: video['channelID'] == "" || subArray==null
    //               ? false
    //               : subArray.contains(video['channelID']),
    //           thumbNail:
    //               video['thumbNail'].length > 0 ? video['thumbNail'][0] : ""));
    //     });

    //     // print(jsonEncode(_videoList));
    //     _progress = false;
    //   });
    //   return null;
    // } else {
    //   setState(() {
    //     _progress = false;
    //   });
    //   return null;
    // }
  }

  @override
  Widget build(BuildContext context) {
    Map search = ModalRoute.of(context).settings.arguments as Map;
    if (!init) {
      if (search != null && search['issearch']) {
        String searchTxt = search['txt'];
        print("SSSSSSSSSSSSSSSSSSSS   " + searchTxt);
        url = "http://${Resources.BASE_URL}/video/getvideos/search/${searchTxt.toString()}";
          print("SSSSSSSSSSSSSSSSSSSS   " + url);
      }
      getAllVideos();
      init = true;
    }
    return _progress
        ? Center(child: CircularProgressIndicator())
        : _videoList.length > 0
            ? RefreshIndicator(
                onRefresh: getAllVideos,
                child: ListView.builder(
                
                    itemCount: _videoList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        child: VideoItemWidget(_videoList[index], () {
                          Resources.navigationKey.currentState.pushNamed(
                              '/player',
                              arguments: _videoList[index]);
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (builder) =>
                          //             VideoPlayerScreen(_videoList[index])));
                        }, () {
                          getAllVideos();
                        }),
                      );
                    }),
              )
            : Text("No Video Found");
  }
}
