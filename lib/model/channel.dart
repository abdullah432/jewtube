import 'package:flutter/cupertino.dart';

class Channel {
  Channel(
      {@required this.channelID,
      @required this.channelName,
      @required this.imgUrl});
  final String channelID;
  final String channelName;
  final String imgUrl;
}
