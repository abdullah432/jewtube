import 'package:animated_card/animated_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:jewtube/model/video.dart';
import 'package:jewtube/util/Resources.dart';
import 'package:jewtube/util/utils.dart';
import 'package:jewtube/widgets/subscribe.dart';
import 'package:jewtube/widgets/videoItemWidgetHorizontal.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

enum Download { NO, YES }
enum DownloadState { INPROGRESS, SUCCESS, FAIL }

class VideoPlayerScreen extends StatefulWidget {
  final VideoModel videoModel;
  final VideoModel prevModel;
  VideoPlayerScreen({@required this.videoModel, this.prevModel});
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState(videoModel);
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with SingleTickerProviderStateMixin {
  // VideoPlayerController _videoPlayerController = VideoPlayerController.network(
  //       "https://d3ofruocozqolb.cloudfront.net/9b928440-9d6c-43a4-9150-1d10705c4d2a/hls/jewtube-_-_-a1fb300d-84b6-4c07-bc8d-9ad7eeced748-_-_-TalkingTom2(9).m3u8");
  VideoModel videoModel;
  _VideoPlayerScreenState(this.videoModel);
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  List subList = List();
  // List<VideoModel> _videoList = List();
  bool init = false;
  //to animate download icon
  AnimationController _animationController;
  Animation<Color> _colorAnimation;
  Color beginColor = Colors.blueGrey;
  Color endColor = Colors.blue[900];
  bool downloaded = false;

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.network(videoModel.videoURL);
    super.initState();
    //
    _animationController = AnimationController(
      duration: Duration(seconds: 3),
      reverseDuration: Duration(seconds: 4),
      vsync: this,
    );
    _colorAnimation = ColorTween(begin: beginColor, end: endColor)
        .animate(_animationController);
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
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // VideoModel videoModel = ModalRoute.of(context).settings.arguments;

    //if (!init) {
    // getAllVideos();
    // init = true;

    // _videoPlayerController = VideoPlayerController.network(
    //     "https://d3ofruocozqolb.cloudfront.net/9b928440-9d6c-43a4-9150-1d10705c4d2a/hls/jewtube-_-_-a1fb300d-84b6-4c07-bc8d-9ad7eeced748-_-_-TalkingTom2(9).m3u8")
    //   ..initialize().then((_) => setState(() {}));

    print("AAAAAAAA   : " + videoModel.videoURL);

    // _chewieController = ChewieController(
    //   // videoPlayerController: VideoPlayerController.network(videoModel.videoURL)..initialize(),
    //   videoPlayerController: _videoPlayerController,
    //   aspectRatio: 3 / 2,
    //   autoPlay: true,
    //   looping: true,
    //   // autoInitialize: true,
    // );
    //}
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                              videoModel.videoTitle,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(videoModel.channelName)
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          SubscribeWidget(
                            videoModel.sub,
                            onClick: (status) async {
                              Response response = await Dio().post(
                                  "http://${Resources.BASE_URL}/subscribe/add",
                                  data: {
                                    "userID": Resources.userID,
                                    "ChannelID": videoModel.channelID
                                  });

                              setState(() {
                                videoModel.sub = status;
                              });

                              //getAllVideos();
                            },
                          ),
                          Row(
                            children: [
                              downloaded
                                  ? IconButton(
                                      onPressed: downloadFile,
                                      color: Colors.blueGrey,
                                      icon: Icon(Icons.file_download_done))
                                  : IconButton(
                                      onPressed: downloadFile,
                                      color: _colorAnimation.value,
                                      icon: Icon(Icons.file_download),
                                    ),
                              SizedBox(width: 12.0),
                              IconButton(
                                onPressed: shareLink,
                                color: Colors.blueGrey,
                                icon: Icon(Icons.share),
                              ),
                            ],
                          )
                        ],
                      )
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

  Future<void> shareLink() async {
    await FlutterShare.share(
        title: videoModel.videoTitle,
        text: 'Share with friends',
        linkUrl: videoModel.videoURL,
        chooserTitle: 'Example Chooser Title');
  }

  Future<void> downloadFile() async {
    beginColor = Colors.green;
    _colorAnimation = ColorTween(begin: beginColor, end: endColor)
        .animate(_animationController)
          ..addListener(() {
            setState(() {});
          });
    _animationController.repeat(reverse: true);

    // Future.delayed(Duration(seconds: 5)).then((value) => {
    //   setState(() {
    //     _animationController.stop();
    //     downloaded = true;
    //   })
    // });

    Dio dio = Dio();
    String dumyUrl = "https://videoapp-destination-1067snc02adqb.s3.amazonaws.com/02fa2a9c-cab8-462b-af15-468614be9fbb/mp4/jewtube-_-_-781d7ca0-f7e5-444c-aa8b-be73573d98c8-_-_-El+Camino+Al+Exito_Mp4_Avc_Aac_16x9_1280x720p_24Hz_4.5Mbps_qvbr.mp4";
    var dir = await getDownloadsDirectory();
    print("Directory: ${dir.path}/JewTube2.mp4");
    dio.download(dumyUrl, "${dir.path}JewTube.mp4",
        onReceiveProgress: (rec, total) {
      print('Rec: $rec, Total: $total');
    }, deleteOnError: true).catchError((onError) {
      print('Download Error');
      _animationController.stop();
    }).whenComplete(() {
      print("Complete");
      _animationController.stop();
      setState(() {
        downloaded = true;
      });
    });

    // dio.download(
    //     videoModel.videoURL, "${dir.path}/${videoModel.videoTitle}.mp4",
    //     onReceiveProgress: (rec, total) {
    //   print('Rec: $rec, Total: $total');
    // }, deleteOnError: true).catchError((onError) {
    //   _animationController.stop();
    // }).then((value) => {_animationController.stop(), downloaded = true});
  }
}
