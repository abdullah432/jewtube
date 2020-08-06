import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:bmnav/bmnav.dart' as bmnav;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jewtube/model/channel.dart';
import 'package:jewtube/util/Resources.dart';
import 'package:jewtube/util/main_content.dart';
import 'package:jewtube/view/add_video.dart';
import 'package:jewtube/view/channelVideoList.dart';
import 'package:jewtube/view/login/constants/constants.dart';
import 'package:jewtube/view/subVideoList.dart';
import 'package:jewtube/view/videoList.dart';
import 'package:path/path.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSearchViewClicked = false;
  int _navIndex = 0;
  Color clr = Colors.grey;
  List<Channel> _channelList = List();
  bool _progress = true;
  File file;
  String chnlName = "";
  bool _progressAddChannel = false;
  @override
  void initState() {
    getAllChannels();
    super.initState();
  }

  void getAllChannels() async {
    Response response = await Dio().get("http://${Resources.BASE_URL}/channel");
    print(response.data);
    setState(() {
      _channelList.clear();
      response.data.forEach((channel) {
        _channelList.add(Channel(
            channelID: channel['_id'],
            channelName: channel['title'],
            imgUrl: channel['img']));
      });
      _progress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _progress
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            resizeToAvoidBottomPadding: false,
            key: Resources.scaffoldKey,
            drawer: Resources.isAdmin
                ? Drawer(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: CircleAvatar(
                              backgroundImage: AssetImage("assets/account.png"),
                              radius: 70,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(
                              "ADMIN NAME",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Divider(
                            thickness: 5,
                            color: clr,
                          ),
                          ListTile(
                            title: Text("Show All Videos"),
                            onTap: () {
                              Resources.scaffoldKey.currentState
                                  .openEndDrawer();
                              Resources.navigationKey.currentState
                                  .pushNamed('/admin_all_videos');
                            },
                          ),
                          Divider(
                            thickness: 5,
                            color: clr,
                          ),
                          _channelList.length > 0
                              ? Container()
                              : Container(
                                  child: Center(
                                    child: Text("No Channel To View"),
                                  ),
                                ),
                          for (var channel in _channelList)
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: channel.imgUrl == ""
                                    ? AssetImage("assets/no_img.png")
                                    : CachedNetworkImageProvider(
                                        channel.imgUrl),
                              ),
                              title: Text(channel.channelName),
                              onTap: () {
                                print(channel.channelName);
                                Resources.scaffoldKey.currentState
                                    .openEndDrawer();
                                Resources.navigationKey.currentState.pushNamed(
                                    '/channel_page',
                                    arguments: channel.channelID);
                              },
                            ),
                          Divider(
                            thickness: 2,
                            color: clr,
                          ),
                          ListTile(
                            onTap: () {
                              Alert(
                                  context: context,
                                  title: "ADD A CHANNEL",
                                  content: _progressAddChannel
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter setState) {
                                          return Column(
                                            children: <Widget>[
                                              Center(
                                                child: GestureDetector(
                                                  child: CircleAvatar(
                                                    radius: 50,
                                                    backgroundImage: file ==
                                                            null
                                                        ? AssetImage(
                                                            "assets/addImg.png")
                                                        : MemoryImage(file
                                                            .readAsBytesSync()),
                                                  ),
                                                  onTap: () {
                                                    FilePicker.getFile(
                                                            type:
                                                                FileType.IMAGE)
                                                        .then((value_file) {
                                                      setState(() {
                                                        file = value_file;
                                                        print("PATH   : " +
                                                            file.path);
                                                      });
                                                    });

                                                    //
                                                  },
                                                ),
                                              ),
                                              TextField(
                                                onChanged: (value) {
                                                  chnlName = value;
                                                },
                                                decoration: InputDecoration(
                                                  icon: Icon(
                                                      Icons.account_circle),
                                                  labelText: 'Channel Name',
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                  buttons: [
                                    DialogButton(
                                      onPressed: () async {
                                        if (file != null) {
                                          setState(() {
                                            _progressAddChannel = true;
                                          });
                                          Dio dio = new Dio();
                                          var filename = (basename(file.path));
                                          var response = await dio.post(
                                              "http://${Resources.BASE_URL}/channel/add",
                                              data: {
                                                "file": file.readAsBytesSync(),
                                                "name": filename,
                                                "title": chnlName,
                                              });
                                          print(response.data);
                                          getAllChannels();
                                          setState(() {
                                            _progressAddChannel = false;
                                          });
                                        } else {
                                          print("FILE NULL");
                                          Fluttertoast.showToast(
                                              msg: "No File Selected",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIos: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        }
                                      },
                                      child: Text(
                                        "ADD",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                    DialogButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        "CANCEL",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    )
                                  ]).show();
                            },
                            leading: Icon(FontAwesomeIcons.plusCircle),
                            title: Text("ADD A NEW CHANNEL"),
                          )
                        ]),
                  )
                : null,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.red,
              title: isSearchViewClicked
                  ? TextField(
                      style: TextStyle(color: Colors.white),
                      onSubmitted: (value) {
                        isSearchViewClicked = false;
                        print(value);
                        Resources.navigationKey.currentState
                            .pushReplacementNamed('/',
                                arguments: {'issearch': true, 'txt': value});
                        // setState(() {
                        //   queryText = value;
                        // });
                      },
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.white70),
                        icon: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              isSearchViewClicked = false;
                            });
                          },
                        ),
                      ),
                      autofocus: true,
                      cursorColor: Colors.black,
                    )
                  : Row(
                      children: <Widget>[
                        Image.asset(
                          "assets/logo_new.png",
                          width: 35,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "JewTube",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
              leading: Resources.isAdmin
                  ? IconButton(
                      icon: Icon(FontAwesomeIcons.bars),
                      onPressed: () {
                        Resources.scaffoldKey.currentState.openDrawer();
                      })
                  : null,
              actions: <Widget>[
                IconButton(
                  icon: isSearchViewClicked
                      ? Icon(
                          FontAwesomeIcons.times,
                          color: Colors.white,
                        )
                      : Icon(
                          FontAwesomeIcons.search,
                          color: Colors.white,
                        ),
                  onPressed: () {
                    //show search bar
                    setState(() {
                      if (isSearchViewClicked) {
                        isSearchViewClicked = false;
                      } else {
                        isSearchViewClicked = true;
                      }
                    });
                  },
                ),
                // IconButton(icon: Icon(FontAwesomeIcons.userCircle), onPressed: () {}),
                Resources.userID == ""
                    ? IconButton(
                        icon: Icon(FontAwesomeIcons.userAlt),
                        onPressed: () async {
                          Navigator.of(context).pushReplacementNamed(SIGN_IN);
                        })
                    : IconButton(
                        icon: Icon(FontAwesomeIcons.signOutAlt),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs?.clear();
                          Navigator.of(context).pushReplacementNamed(SIGN_IN);
                        })
              ],
            ),
            body: MainContent(),
            bottomNavigationBar: bmnav.BottomNav(
              // color: ThemeData.dark().primaryColor,
              iconStyle: bmnav.IconStyle(onSelectColor: Colors.red),
              index: _navIndex,
              onTap: (i) {
                print(i);
                setState(() {
                  _navIndex = i;

                  switch (i) {
                    case 0:
                      // _bodyWidget = VideoListScreen();
                      Resources.navigationKey.currentState.pushReplacementNamed(
                          '/',
                          arguments: {'issearch': false, 'txt': ""});
                      return;
                    case 2:
                      Resources.navigationKey.currentState
                          .pushReplacementNamed('/sub_page');
                      // _bodyWidget = SubedVideoList();
                      return;
                    case 3:
                      Resources.navigationKey.currentState
                          .pushReplacementNamed('/download_page');
                      return;
                    default:
                      // _bodyWidget = VideoListScreen();
                      Resources.navigationKey.currentState.pushReplacementNamed(
                          '/',
                          arguments: {'issearch': false, 'txt': ""});
                  }
                });
              },
              items: [
                bmnav.BottomNavItem(icon: Icons.home, label: 'Home'),
                // bmnav.BottomNavItem(Icons.whatshot),
                bmnav.BottomNavItem(icon: Icons.category, label: 'Categories'),
                bmnav.BottomNavItem(icon: Icons.subscriptions, label: 'Subscriptions'),
                bmnav.BottomNavItem(icon: Icons.file_download, label: 'Downloads')
              ],
            ),
            floatingActionButton: Resources.isAdmin
                ? FloatingActionButton(
                  backgroundColor: Colors.red,
                    onPressed: () {
                      Alert(
                        style: AlertStyle(isCloseButton: false),
                        context: Resources.scaffoldKey.currentContext,
                        title: "SELECT CHANNEL",
                        content: Column(children: <Widget>[
                          for (var channel in _channelList)
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(channel.imgUrl),
                              ),
                              title: Text(channel.channelName),
                              onTap: () {
                                Navigator.pop(context);
                                // Resources.navigationKey.currentState.pushNamed(
                                //     '/add_video',
                                //     arguments: channel.channelID);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) =>
                                            AddVideoScreen(channel.channelID)));
                              },
                            ),
                        ]),
                        buttons: List(),
                      ).show();
                    },
                    tooltip: 'ADD VIDEO',
                    child: Icon(Icons.add),
                  )
                : null,
          );
  }
}
