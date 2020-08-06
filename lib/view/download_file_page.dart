import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:jewtube/model/downloaded_files.dart';
import 'package:jewtube/util/Resources.dart';
import 'package:jewtube/util/sqflite_helper.dart';
import 'package:jewtube/view/offline_vidoe_play.dart';
import 'package:jewtube/view/videoPlay.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class DownloadFilesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DownloadFilesPageState();
  }
}

class DownloadFilesPageState extends State<DownloadFilesPage> {
  File file;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            'Downloads',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              String filePath =
                  Resources.listOfDownloadedFiles[index].fileLocation;
              file = File(filePath);
              String filename = basenameWithoutExtension(file.path);
              getThumbnail(index);
              return GestureDetector(
                onTap: () {
                  navigateToOfflineVideoPlayPage(context, filePath);
                },
                child: Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Row(
                    children: [
                      FutureBuilder<Uint8List>(
                        future: getThumbnail(index),
                        builder: (BuildContext context,
                            AsyncSnapshot<Uint8List> snapshot) {
                          // When this builder is called, the Future is already resolved into snapshot.data
                          // So snapshot.data contains the not-yet-correctly formatted Image.
                          if (!snapshot.hasData) {
                            return Container(
                                width: 140,
                                height: 80,
                                child:
                                    Center(child: CircularProgressIndicator()));
                          }
                          return Image.memory(snapshot.data, fit: BoxFit.cover);
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          filename,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          shareFile(index);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.share, color: Colors.grey),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showAlertDialog(
                              context,
                              "Delete",
                              "Are you sure you want to delete this video",
                              index);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: Resources.listOfDownloadedFiles.length,
          )
        ],
      ),
    );
  }

  Future<Uint8List> getThumbnail(int index) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: Resources.listOfDownloadedFiles[index].fileLocation,
      imageFormat: ImageFormat.PNG,
      maxWidth:
          140, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
    );

    return uint8list;
  }

  showAlertDialog(context, title, message, fileIndex) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () async {
              final status = await Permission.storage.request();
              if (status.isGranted) {
                print("delete start");
                print("path: " +
                    Resources.listOfDownloadedFiles[fileIndex].fileLocation);

                // DatabaseHelper databaseHelper = DatabaseHelper();
                //   int result = await databaseHelper.deleteFile(
                //       id: Resources.listOfDownloadedFiles[fileIndex].id);

                //   if (result != 0) {
                //     setState(() {
                //       print("delete complete");
                //     });
                //   }

                file = File(
                    Resources.listOfDownloadedFiles[fileIndex].fileLocation);
                file.delete().whenComplete(() async {
                  DatabaseHelper databaseHelper = DatabaseHelper();
                  int result = await databaseHelper.deleteFile(
                      id: Resources.listOfDownloadedFiles[fileIndex].id);
                  print('result: ' + result.toString());
                  if (result != 0) {
                    updateDownloadedFilesList();
                  }
                });
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> updateDownloadedFilesList() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    await dbFuture.then((database) {
      Future<List<DownloadedFile>> filesListFuture =
          databaseHelper.getDownloadedFilesList();
      filesListFuture.then((downloadedFileList) {
        Resources.listOfDownloadedFiles = downloadedFileList;
        setState(() {});
      });
    });

    return;
  }

  Future<void> shareFile(index) async {
    await FlutterShare.shareFile(
        title: 'Share Video',
        text: 'Share with friends',
        filePath: Resources.listOfDownloadedFiles[index].fileLocation,
        chooserTitle: 'Share with friends');
  }

  navigateToOfflineVideoPlayPage(context, String videoPath) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => OfflineVideoPlayer(
                  oflineVideoPath: videoPath,
                )));
  }
}
