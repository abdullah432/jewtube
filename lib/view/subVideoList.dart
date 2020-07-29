import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:jewtube/model/channel.dart';
import 'package:jewtube/model/video.dart';
import 'package:jewtube/util/Resources.dart';
import 'package:jewtube/util/utils.dart';
import 'package:jewtube/view/login/constants/constants.dart';
import 'package:jewtube/widgets/videoListView.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:bmnav/bmnav.dart' as bmnav;

class SubedVideoList extends StatefulWidget {
  @override
  _SubedVideoListState createState() => _SubedVideoListState();
}

class _SubedVideoListState extends State<SubedVideoList> {
  List<VideoModel> _videoList = List();
  List<Channel> _channelList = List();
  bool _progress = true;
  bool init = false;
  String text = "No Subscriptions";

  Future<Null> getAllVideos() async {
    await getVideos(
            "http://${Resources.BASE_URL}/video/getvideos/ByChannelArray",
            needSubsInQuery: true)
        .then((value) => {
              setState(() {
                _videoList.clear();
                _videoList = value['videos'];
                _channelList = value['channels'];
                // print(jsonEncode(_videoList));
                _progress = false;
              })
            });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height =
        (MediaQuery.of(context).size.height) - AppBar().preferredSize.height;
    double width = MediaQuery.of(context).size.width;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!init) {
        init = true;
        if (Resources.userID != "") {
          getAllVideos();
          setState(() {
            init = true;
            // _progress = false;
          });
        } else {
          setState(() {
            init = true;
            _progress = false;
          });
          text = "Please sign in...!";

          Alert(
            closeFunction: () {},
            context: Resources.scaffoldKey.currentContext,
            style: AlertStyle(
              animationType: AnimationType.fromTop,
              isCloseButton: false,
              isOverlayTapDismiss: false,
              descStyle: TextStyle(fontWeight: FontWeight.bold),
              animationDuration: Duration(milliseconds: 400),
              alertBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
                side: BorderSide(
                  color: Colors.grey,
                ),
              ),
              titleStyle: TextStyle(
                color: Colors.red,
              ),
            ),
            type: AlertType.info,
            title: "LOGIN",
            desc: "You need to login to enable these features.",
            buttons: [
              DialogButton(
                child: Text(
                  "LOGIN",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop( Resources.scaffoldKey.currentContext);
                  Navigator.pushNamed( Resources.scaffoldKey.currentContext, SIGN_IN);
                },
                color: Color.fromRGBO(0, 179, 134, 1.0),
                radius: BorderRadius.circular(0.0),
              ),
            ],
          ).show();
        }
      }
    });

    return _progress
            ? Center(
                child: CircularProgressIndicator(),
              )
            :
            _videoList.length > 0 ?
            Container(
                height: height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                        height: height * 0.1,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _channelList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                
                                onTap: () {
                                    Resources.navigationKey.currentState.pushNamed(
                              '/channel_page',
                              arguments: _channelList[index].channelID);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: CircleAvatar(
                                    radius: height * 0.04,
                                    backgroundImage:
                                        _channelList[index].imgUrl == "" ||
                                                _channelList[index].imgUrl == null
                                            ? AssetImage("assets/no_img.png")
                                            : CachedNetworkImageProvider(
                                                _channelList[index].imgUrl),
                                   
                                  ),
                                ),
                              );
                            })),
                    SizedBox(height: height * 0.05),
                    VideoListViewWidget(
                      _videoList,
                      getAllVideos,
                      () => getAllVideos(),
                      height: height * 0.65,
                    ),
                  ],
                ),
              )
        : Center(
            child: Text(text),
          )
        ;
  }
}
