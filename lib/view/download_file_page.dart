import 'package:flutter/cupertino.dart';

class DownloadFilesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DownloadFilesPageState();
  }

}

class DownloadFilesPageState extends State<DownloadFilesPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Downloads', style: TextStyle(fontWeight: FontWeight.bold),)
    ],);
  }

}