import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jewtube/model/video.dart';
import 'package:jewtube/util/Resources.dart';
import 'package:jewtube/widgets/subscribe.dart';

class VideoItemWidget extends StatefulWidget {
  VideoItemWidget(this.videoModel, this.onClick, this.onSub);
  final VideoModel videoModel;
  Function onClick;
  Function onSub;
  @override
  _VideoItemWidgetState createState() => _VideoItemWidgetState();
}

class _VideoItemWidgetState extends State<VideoItemWidget> {
  bool _progress = false;

  @override
  void initState() {
    super.initState();

    print(widget.videoModel.channelImage);

    print(widget.videoModel.thumbNail);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return _progress
        ? Center(child: CircularProgressIndicator())
        : Container(
            child: Column(
            children: <Widget>[
              GestureDetector(
                // child: Image.network(
                //   widget.videoModel.thumbNail,
                //   height: height * 0.25,
                //   width: width,
                //   fit: BoxFit.cover,
                // ),

                //thumbnail
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  height: height * 0.35,
                  width: width,
                  imageUrl: widget.videoModel.thumbNail,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                onTap: () {
                  widget.onClick();
                },
              ),
              //Row below thumbnail: include circular icon, videotitle and description
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: width,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 27,
                        backgroundImage: widget.videoModel.channelImage == "" ||
                                widget.videoModel.channelImage == null
                            ? AssetImage("assets/no_img.png")
                            : CachedNetworkImageProvider(
                                widget.videoModel.channelImage),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 14, bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.videoModel.videoTitle,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(widget.videoModel.channelName)
                            ],
                          ),
                        ),
                      ),
                      // Spacer(),
                      // SubscribeWidget(
                      //   widget.videoModel.sub,
                      //   onClick: (status) async {
                      //     Response response = await Dio().post(
                      //         "http://${Resources.BASE_URL}/subscribe/add",
                      //         data: {
                      //           "userID": Resources.userID,
                      //           "ChannelID": widget.videoModel.channelID
                      //         });

                      //     setState(() {
                      //       widget.videoModel.sub = status;
                      //       widget.onSub();
                      //     });
                      //   },
                      // ),
                    ],
                  ),
                ),
              )
            ],
          ));
  }
}
