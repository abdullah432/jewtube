import 'package:jewtube/util/Resources.dart';
import 'package:jewtube/util/nested_route.dart';
import 'package:flutter/material.dart';
import 'package:jewtube/view/add_video.dart';
import 'package:jewtube/view/admin_all_videos.dart';
import 'package:jewtube/view/channelVideoList.dart';
import 'package:jewtube/view/subVideoList.dart';
import 'package:jewtube/view/videoList.dart';
import 'package:jewtube/view/videoPlay.dart';

class MainContent extends StatefulWidget {
  @override
  _MainContentState createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  @override
  Widget build(BuildContext context) {
    return NestedNavigator(
      navigationKey: Resources.navigationKey,
      initialRoute: '/',
      routes: {
        // '/': (context) => HomeScreen(widget.drawerKey),
        '/': (context) => VideoListScreen(),
        '/sub_page': (context) => SubedVideoList(),
        // '/add_video': (context) => AddVideoScreen(),
        '/player': (context) => VideoPlayerScreen(),
        '/channel_page': (context) => ChannelVideoList(),
        '/admin_all_videos': (context) => AdminAllVideos(),
      },
    );
  }
}

//  Resources.navigationKey.currentState.pushReplacementNamed('/post_list')
