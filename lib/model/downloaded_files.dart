import 'package:meta/meta.dart';

class DownloadedFile {
  int id;
  String mp4Url;
  String fileLocation;
  String downloadTime;

  DownloadedFile({@required this.fileLocation, @required this.mp4Url, @required this.downloadTime});
  //SQLFlite only get and return value in form of map

  //Convert DownloadedFiles object to Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['url'] = mp4Url;
    map['location'] = fileLocation;
    map['time'] = downloadTime;

    return map;
  }

  //Convert Map object to DownloadedFile object
  DownloadedFile.fromMapObject(Map<String, dynamic> map) {
    id = map['id'];
    fileLocation = map['location'];
    downloadTime = map['time'];
    mp4Url = map['url'];
  }

  @override
  String toString() {
    return 'id: $id   fileLocation: $fileLocation   filePath: $mp4Url   time: $downloadTime';
  }
}
