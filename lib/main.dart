import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:jewtube/util/utils.dart';
import 'package:jewtube/view/home.dart';
import 'package:jewtube/view/login/constants/constants.dart';
import 'package:jewtube/view/login/ui/signin.dart';
import 'package:jewtube/view/login/ui/signup.dart';
import 'package:jewtube/view/login/ui/splashscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: false // optional: set false to disable printing logs to console
      );
  //start loading list of downloaded files
  //function is written in 'package:jewtube/util/utils.dart'
  loadDownloadedFilesList();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      // theme: ThemeData.dark(),
      title: 'JewTube',
      // home: SafeArea(
      //   child: AddVideoScreen("channel"),
      // ),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        SPLASH_SCREEN: (BuildContext context) => SplashScreen(),
        SIGN_IN: (BuildContext context) => SignInPage(),
        SIGN_UP: (BuildContext context) => SignUpScreen(),
        HOME: (BuildContext context) => HomeScreen(),
      },
      initialRoute: SPLASH_SCREEN,
    );
  }
}
