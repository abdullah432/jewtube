import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jewtube/model/downloaded_files.dart';

class Resources {
  // static FirebaseApp firebaseApp;
  static String userID = "";
  static bool isAdmin = false;
  static String BASE_URL = "52.37.1.179:4444";
  static final GlobalKey<ScaffoldState> scaffoldKey =GlobalKey<ScaffoldState> ();

  static final GlobalKey<NavigatorState> navigationKey =
      GlobalKey<NavigatorState>();

  //List of downloaded files
  static List<DownloadedFile> listOfDownloadedFiles = List();
  static String fileLocation;

}
