import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jewtube/model/admin_videos.dart';
import 'package:jewtube/model/video.dart';
import 'package:jewtube/util/Resources.dart';
import 'package:jewtube/util/utils.dart';

class AdminAllVideos extends StatefulWidget {
  @override
  _AdminAllVideosState createState() => _AdminAllVideosState();
}

class _AdminAllVideosState extends State<AdminAllVideos> {
  List<AdminVideos> _adminVideos = List();
  List<VideoModel> _videoList = List();
  bool _progress = true;
  Map resVideos = Map();
  String url = "http://${Resources.BASE_URL}/video/getvideos";
  Future<Null> getVideoList() async {
    await getVideos(url).then((value) => {
          if (mounted)
            {
              setState(() {
                _videoList.clear();
                _videoList = value['videos'];
              }),
            },
          Dio()
              .get("http://${Resources.BASE_URL}/adminvideo")
              .then((adminVideoResponse) {
            // print("AAAAAAAAAAAAAA");
            // print(adminVideoResponse);
            if (adminVideoResponse.data != null &&
                adminVideoResponse.data is List) {
              adminVideoResponse.data.forEach((video) {
                // print(video['videoID']);
                resVideos[video['videoID']] = video['title'];
              });
            }
            ;

            _adminVideos.clear();
            _videoList.forEach((videoModel) {
              //  print(videoModel.videoUuid);
              if (resVideos.containsKey(videoModel.videoUuid)) {
                _adminVideos.add(AdminVideos(
                    isUpload: true, videoName: videoModel.videoTitle));
                resVideos.remove(videoModel.videoUuid);
              }
            });

            resVideos.forEach((key, value) {
              _adminVideos.add(AdminVideos(isUpload: false, videoName: value));
            });

            if (mounted) {
              setState(() {
                _progress = false;
              });
            }
          }),
        });
  }

  @override
  void initState() {
    getVideoList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _progress
            ? Center(child: CircularProgressIndicator())
            : Container(
                child: RefreshIndicator(
                    onRefresh: getVideoList,
                    child: ListView.builder(
                        itemCount: _adminVideos.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_adminVideos[index].videoName),
                            trailing: _adminVideos[index].isUpload
                                ? Icon(
                                    FontAwesomeIcons.checkCircle,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    FontAwesomeIcons.spinner,
                                    color: Colors.red,
                                  ),
                          );
                        })),
              ),
      ),
    );
  }
}
