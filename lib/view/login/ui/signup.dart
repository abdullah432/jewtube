import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jewtube/view/login/ui/widgets/responsive_ui.dart';
import 'package:jewtube/view/login/constants/constants.dart';
import 'package:jewtube/view/login/ui/widgets/custom_shape.dart';
import 'package:jewtube/view/login/ui/widgets/customappbar.dart';
import 'package:jewtube/view/login/ui/widgets/textformfield.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  // String _userEmail;

  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Material(
      child: Scaffold(
        body: Container(
          height: _height,
          width: _width,
          margin: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Opacity(opacity: 0.88, child: CustomAppBar()),
                // clipShape(),
                form(),
                acceptTermsTextRow(),
                SizedBox(
                  height: _height / 35,
                ),
                button(context),
                infoTextRow(),
                // socialIconsRow(),
                //signInTextRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            emailTextFormField(),
            SizedBox(height: _height / 60.0),
            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      textEditingController: _emailController,
      keyboardType: TextInputType.emailAddress,
      icon: Icons.email,
      hint: "Email ID",
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      textEditingController: _passwordController,
      keyboardType: TextInputType.text,
      obscureText: true,
      icon: Icons.lock,
      hint: "Password",
    );
  }

  Widget acceptTermsTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 100.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
              activeColor: Colors.orange[200],
              value: checkBoxValue,
              onChanged: (bool newValue) {
                setState(() {
                  checkBoxValue = newValue;
                });
              }),
          Text(
            "I accept all terms and conditions",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 12 : (_medium ? 11 : 10)),
          ),
        ],
      ),
    );
  }

  Widget button(context) {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () async {
        if (checkBoxValue &&
            _emailController != "" &&
            _passwordController != "") {
          final FirebaseAuth _auth = FirebaseAuth.instance;
          final FirebaseUser user = (await _auth
                  .createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          )
                  .catchError((onError) {
            print(onError.message);
            Fluttertoast.showToast(
                msg: onError.message,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,timeInSecForIos: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0);
          }))
              .user;

          print("DDDDDDDDDDDDDDDDDDDDDDDDDDDD   : " + user.toString());
          if (user != null) {
            Fluttertoast.showToast(
                msg: "Signup Success",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.grey,timeInSecForIos: 1,
                textColor: Colors.white,
                fontSize: 16.0);

            Navigator.of(context).pushReplacementNamed(SIGN_IN);
          } else {
            Fluttertoast.showToast(
                msg: "Error in Signup",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.grey,timeInSecForIos: 1,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else {
          Fluttertoast.showToast(
              msg: "Please fill All fields to continue",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.grey,timeInSecForIos: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        }

        // Navigator.pop(context);
        // print("Routing to your account");
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
//        height: _height / 20,
        width: _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[Colors.orange[200], Colors.pinkAccent],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'SIGN UP',
          style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10)),
        ),
      ),
    );
  }

  Widget infoTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Or create using social media",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 12 : (_medium ? 11 : 10)),
          ),
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Already have an account?",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop(SIGN_IN);
              print("Routing to Sign up screen");
            },
            child: Text(
              "Sign in",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.orange[200],
                  fontSize: 19),
            ),
          )
        ],
      ),
    );
  }
}

class socialIconsRow extends StatefulWidget {
  @override
  _socialIconsRowState createState() => _socialIconsRowState();
}

class _socialIconsRowState extends State<socialIconsRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 80.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage("assets/googlelogo_new.png"),
          ),
          SizedBox(
            width: 20,
          ),
          CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage("assets/fblogo.jpg"),
          ),
          SizedBox(
            width: 20,
          ),
          CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage("assets/twitterlogo.jpg"),
          ),
        ],
      ),
    );
  }
}
