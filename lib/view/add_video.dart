import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jewtube/util/Resources.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'login/constants/constants.dart';

class AddVideoScreen extends StatefulWidget {
  AddVideoScreen(
    this.channelID,
  );
  final String channelID;
  @override
  _AddVideoScreenState createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> {
  double _progressValue = 0;
  bool _isUploading = false;
  bool _titleEditEnable = true;
  TextEditingController _txtTitle = TextEditingController();
  var _prevImg;
  Uint8List _fileData;
  bool init = false;
  // Alert _alert;
  @override
  void initState() {
    // _alert =
    super.initState();
  }

  File file;

  void uploadVideo(BuildContext context) async {
    if (file == null) {
      Fluttertoast.showToast(
          msg: "No Video Selected",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      if (_txtTitle.text == null || _txtTitle.text == "") {
        Fluttertoast.showToast(
            msg: "Please enter a title",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        var uuid = Uuid().v4();
        if (file != null) {
          Dio dio = new Dio();
          var filename = "jewtube-_-_-$uuid-_-_-" + (basename(file.path));
          setState(() {
            _titleEditEnable = false;
            _isUploading = true;
          });
          var response = await dio
              .post("http://${Resources.BASE_URL}/video/addVideo", data: {
            "file": file.readAsBytesSync(),
            "name": filename,
            "title": _txtTitle.text,
            "videoID": uuid,
            "channel": widget.channelID
          });
          print(response.data);
          setState(() {
            _isUploading = false;
          });
          if (response != null &&
              response.data != null &&
              response.data['status'] == 200) {
            await Dio().post("http://${Resources.BASE_URL}/adminvideo", data: {
              "title": _txtTitle.text,
              "videoID": uuid,
            });

            Fluttertoast.showToast(
                msg: "Upload Completed",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.grey,
                timeInSecForIos: 1,
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.of(context).pushReplacementNamed(HOME);
          } else {
            Fluttertoast.showToast(
                msg: "Upload Error",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else {
          Fluttertoast.showToast(
              msg: "No Video Selected",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // String channel = ModalRoute.of(context).settings.arguments;
    // if (!init) {
    //   init = true;
    //   setState(() {
    //     channelID = channel;
    //   });
    // }

    var sysWidth = MediaQuery.of(context).size.width;
    var sysHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("ADD VIDEO"),
        ),
        resizeToAvoidBottomPadding: false,
        body: _isUploading
            ? Center(
                child: Column(
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Text(
                        "UPLOADING... Please wait till uploading complete...!"),
                    Text("49% completed. Please wait..."),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      enabled: _titleEditEnable,
                      controller: _txtTitle,
                      decoration: InputDecoration(labelText: "TITLE"),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            File fl =
                                await FilePicker.getFile(type: FileType.VIDEO);
                            final uint8list =
                                await VideoThumbnail.thumbnailData(
                              video: fl.path,
                              imageFormat: ImageFormat.JPEG,
                              maxWidth:
                                  128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
                              quality: 25,
                            );
                            setState(() {
                              _fileData = uint8list;
                              file = fl;
                            });
                          },
                          child: _fileData == null
                              ? Image.asset(
                                  "assets/addVideo.png",
                                  width: sysWidth * 0.8,
                                  fit: BoxFit.cover,
                                )
                              : Image.memory(_fileData),
                        ),
                      ),
                    ),
                    Container(
                      child: RaisedButton(
                          child: Text("SUBMIT"),
                          onPressed: () {
                            uploadVideo(context);
                          }),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class _AnimatedLiquidLinearProgressIndicator extends StatefulWidget {
  _AnimatedLiquidLinearProgressIndicator(this.value);
  double value;
  @override
  State<StatefulWidget> createState() =>
      _AnimatedLiquidLinearProgressIndicatorState();
}

class _AnimatedLiquidLinearProgressIndicatorState
    extends State<_AnimatedLiquidLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.65,
        height: 75.0,
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: LiquidLinearProgressIndicator(
          value: widget.value,
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation(Colors.blue),
          borderRadius: 12.0,
          center: Text(
            "${(widget.value * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              color: Colors.lightBlueAccent,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
