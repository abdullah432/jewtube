import 'package:flutter/material.dart';
import 'package:jewtube/util/Resources.dart';
import 'package:jewtube/view/login/constants/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SubscribeWidget extends StatefulWidget {
  SubscribeWidget(this.status,
      {this.channelID, this.userID, @required this.onClick});
  final String userID;
  final String channelID;
  bool status;
  Function(bool status) onClick;
  @override
  _SubscribeWidgetState createState() => _SubscribeWidgetState();
}

class _SubscribeWidgetState extends State<SubscribeWidget> {
  Color clr = Colors.grey;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.status) {
      clr = Colors.red;
    } else {
      clr = Colors.grey;
    }
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: RaisedButton(
        onPressed: () {
          if (Resources.userID != "") {
            setState(() {
              widget.status = !widget.status;
              print(widget.status);
              widget.onClick(widget.status);
            });
          } else {
            Alert(
              closeFunction: () {},
              context:  Resources.scaffoldKey.currentContext,
              style: AlertStyle(
                animationType: AnimationType.fromTop,
                isCloseButton: true,
                isOverlayTapDismiss: false,
                descStyle: TextStyle(fontWeight: FontWeight.bold),
                animationDuration: Duration(milliseconds: 400),
                alertBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                  side: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                titleStyle: TextStyle(
                  color: Colors.red,
                ),
              ),
              type: AlertType.info,
              title: "LOGIN",
              desc: "You need to login to enable these features.",
              buttons: [
                DialogButton(
                  child: Text(
                    "LOGIN",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.pop( Resources.scaffoldKey.currentContext);
                    Navigator.pushNamed( Resources.scaffoldKey.currentContext, SIGN_IN);
                  },
                  color: Color.fromRGBO(0, 179, 134, 1.0),
                  radius: BorderRadius.circular(0.0),
                ),
              ],
            ).show();
          }
        },
        child: Text(
          "SUBSCRIBE",
          style: TextStyle(color: clr),
        ),
        color: Colors.transparent,
        shape: RoundedRectangleBorder(side: BorderSide(color: clr, width: 1)),
      ),
    );
  }
}
