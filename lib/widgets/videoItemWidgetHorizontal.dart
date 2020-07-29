import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jewtube/model/video.dart';
import 'package:jewtube/util/Resources.dart';
import 'package:jewtube/widgets/subscribe.dart';

class VideoItemWidgetHorizontal extends StatefulWidget {
  VideoItemWidgetHorizontal(this.videoModel, this.onClick, this.onSub);
  final VideoModel videoModel;
  Function onClick;
  Function onSub;
  @override
  _VideoItemWidgetHorizontalState createState() =>
      _VideoItemWidgetHorizontalState();
}

class _VideoItemWidgetHorizontalState extends State<VideoItemWidgetHorizontal> {
  bool _progress = true;

  @override
  void initState() {
    print((widget.videoModel.thumbNail));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        width: width,
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: widget.videoModel.thumbNail == null ||
                        widget.videoModel.thumbNail == ""
                    ? Image.asset(
                        'assets/no_img.png',
                        fit: BoxFit.cover,
                        height: height * 0.1,
                        width: width * 0.3,
                      )
                    : CachedNetworkImage(
                        fit: BoxFit.cover,
                        height: height * 0.1,
                        width: width * 0.3,
                        imageUrl: widget.videoModel.thumbNail,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                      )
                // : Image.network(
                //     widget.videoModel.thumbNail,
                //     fit: BoxFit.cover,
                //     height: height * 0.1,
                //     width: width * 0.3,
                //   ),
                ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // width: width*0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.videoModel.videoTitle,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(widget.videoModel.channelName)
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: SubscribeWidget(
                widget.videoModel.sub,
                onClick: (status) async {
                  Response response = await Dio().post(
                      "http://${Resources.BASE_URL}/subscribe/add",
                      data: {
                        "userID": Resources.userID,
                        "ChannelID": widget.videoModel.channelID
                      });

                  setState(() {
                    widget.videoModel.sub = status;
                    widget.onSub();
                  });
                },
              ),
            )
          ],
        ));
  }
}
