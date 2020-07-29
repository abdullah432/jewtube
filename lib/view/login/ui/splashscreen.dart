import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jewtube/util/Resources.dart';
import 'package:jewtube/view/login/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;

  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    var uid = prefs.getString('uid') ?? "";
    print(status && uid != "");
    if (status) {
      setState(() {
        Resources.isAdmin = uid == "admin" ? true : false;
        Resources.userID = uid;
      });
      Navigator.of(context).pushReplacementNamed(HOME);
    } else {
    
      setState(() {
        Resources.isAdmin = false;
        Resources.userID = "";
      });
      Navigator.of(context).pushReplacementNamed(HOME);
    }
  }

  @override
  void initState() {
    super.initState();
    // animationController = new AnimationController(
    //     vsync: this, duration: new Duration(seconds: 1));
    // animation =
    //     new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    // animation.addListener(() => this.setState(() {}));
    // animationController.forward();

    // setState(() {
    //   _visible = !_visible;
    // });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Padding(
              //     padding: EdgeInsets.only(bottom: 30.0),
              //     child: new Image.asset(
              //       'assets/powered_by.png',
              //       height: 25.0,
              //       fit: BoxFit.scaleDown,
              //     ))
            ],
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/logo_new.png',
                width:250,
                height: 250,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
