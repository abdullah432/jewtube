import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:jewtube/util/Resources.dart';
import 'package:jewtube/util/utils.dart';
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
  //category parameters
  List<String> listOfcategories = [
    'Daily Dose',
    'Torah Classes',
    'Music',
    'Movies'
  ];
  String selectedCategory;

  void uploadVideo(BuildContext context) async {
    if (file == null) {
      showToast(message: "No Video Selected");
    } else if (_txtTitle.text == null || _txtTitle.text == "") {
      showToast(message: "Please enter a title");
    } else if (selectedCategory == null) {
      showToast(message: "Please select category");
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
          "category": selectedCategory,
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

          showToast(message: "Upload Completed");
          // Navigator.of(context).pushReplacementNamed(HOME);
        } else {
          showToast(message: "Upload Error");
        }
      } else {
        showToast(message: "No Video Selected");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var sysWidth = MediaQuery.of(context).size.width;
    var sysHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("ADD VIDEO"),
          backgroundColor: Colors.red,
        ),
        resizeToAvoidBottomPadding: false,
        body: _isUploading
            ? Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Text("UPLOADING... Please wait it can take some time"),
                    SizedBox(height: 20),
                    CircularProgressIndicator(),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        enabled: _titleEditEnable,
                        controller: _txtTitle,
                        decoration: InputDecoration(labelText: "TITLE"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: Text('Please choose a category'),
                          value: selectedCategory,
                          items: listOfcategories.map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              File fl = await FilePicker.getFile(
                                  type: FileType.VIDEO);
                              final uint8list =
                                  await VideoThumbnail.thumbnailData(
                                video: fl.path,
                                imageFormat: ImageFormat.JPEG,
                                maxWidth:
                                    150, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
                                quality: 50,
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
