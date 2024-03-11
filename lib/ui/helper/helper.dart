import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  // DONOT DELETE 👇
  // border: Border.all(color: Color(0xffF05353)),
  static height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static shrink() {
    return const SizedBox.shrink();
  }

  static pop(BuildContext context) {
    return Navigator.pop(context);
  }

  static width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static allowHeight(double height) {
    return SizedBox(height: height);
  }

  static allowWidth(double width) {
    return SizedBox(width: width);
  }

  static showLoading(BuildContext context, [msg]) {
    return showDialog(
        barrierColor: Colors.white70,
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: LoadingAnimationWidget.threeArchedCircle(
                      color: Colors.black,
                      size: 42,
                    ),
                  ),
                  msg != null
                      ? Helper.allowHeight(10.0)
                      : const SizedBox.shrink(),
                  msg != null
                      ? Text(
                          msg,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          );
        });
  }

  static text(
      String text, size, Color? color, FontWeight? fontWeight, double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Text(text,
          style: TextStyle(
            color: color,
            fontWeight: fontWeight ?? FontWeight.bold,
            fontSize: double.parse(
              size.toString(),
            ),
          )),
    );
  }

  static textformfileld(
      String? label,
      TextEditingController textcontroller,
      bool? keyboartext,
      bool? validation,
      BuildContext context,
      String? keyboardtype,
      int? maxline) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        // height: 58,
        height: 55,
        // width: 320,
        width: MediaQuery.of(context).size.width / 1.110,
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: maxline,
          // validator: (value) {
          //   if (value!.isEmpty) {
          //     if (validation == false) {
          //       return null;
          //     } else {
          //       return "this field is required";
          //     }
          //   }
          //   return null;
          // },
          showCursor: true,
          cursorColor: Colors.black,
          autocorrect: true,
          controller: textcontroller,
          // obscureText: !show,
          textInputAction: TextInputAction.done,
          keyboardType:
              keyboartext == true ? TextInputType.text : TextInputType.number,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black)),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.black54, // Change the color to your preference
                width: 2.0,
              ),
            ),
            fillColor: Colors.grey[50],
            labelText: label,
          ),
        ),
      ),
    );
  }

  static textformfiled(hinttext, TextEditingController textcontroller,
      String keyboardtype, bool validation, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        height: 55,
        // width: 320,
        width: MediaQuery.of(context).size.width / 1.110,
        child: TextFormField(
          inputFormatters: [
            keyboardtype == "text"
                ? LengthLimitingTextInputFormatter(1000)
                : LengthLimitingTextInputFormatter(10),
          ],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value!.isEmpty) {
              if (validation == false) {
                return null;
              } else {
                return "this field is required";
              }
            }
            return null;
          },
          showCursor: true,
          cursorColor: Colors.black,
          autocorrect: true,
          controller: textcontroller,
          textInputAction: TextInputAction.done,
          keyboardType: keyboardtype == "text"
              ? TextInputType.text
              : TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            fillColor: Colors.grey[50],
            labelText: hinttext,
            // labelStyle: AppStyles.buttonloginText,
          ),
        ),
      ),
    );
  }

  void coreSnackbar(GlobalKey<ScaffoldState>? scaffoldKey, String? content,
      {IconData? icon, Color? color}) {
    var snackBar = SnackBar(
      backgroundColor: Colors.white,
      content: Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon!,
            color: color!,
          ),
          const SizedBox(
            width: 15,
          ),
          Flexible(
            child: Text(
              content!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(scaffoldKey!.currentContext!).showSnackBar(snackBar);
  }

  static RegExp exp =
      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  static RegExp phoexp = RegExp(r"^[0-9]{10}$");
  static String formatEmail(String newText) {
    // Regular expression to check for valid email
    RegExp exp = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (exp.hasMatch(newText)) {
      return newText;
    }
    return "";
  }

  static showToast({required msg}) {
    Fluttertoast.cancel(); // for immediate stopping
    return Fluttertoast.showToast(msg: msg);
  }

  static locaStorageInst() async {
    return SharedPreferences.getInstance();
  }

  static push(BuildContext context, dynamic route) {
    return Navigator.push(
        context, MaterialPageRoute(builder: ((context) => route)));
  }

  static pushReplacement(BuildContext context, dynamic route) {
    return Navigator.pushReplacement(
        context, MaterialPageRoute(builder: ((context) => route)));
  }

  static pushReplacementRemove(BuildContext context, String namedRoute) {
    return Navigator.of(context)
        .pushNamedAndRemoveUntil(namedRoute, (Route<dynamic> route) => false);
  }

  static emailRegexp() {
    return RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  }

  static pushReplacementWithDelay(BuildContext context, dynamic route,
      [delay]) {
    return Future.delayed(Duration(seconds: delay ?? 3), () async {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: ((context) => route)));
    });
  }

  static alert(BuildContext context) {
    showDialog(
        barrierColor: Colors.white70,
        context: context,
        builder: ((context) => AlertDialog(
              actions: <Widget>[
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
              content: Column(
                children: [
                  Image.asset(
                    "assets/images/greentick.jpg",
                  ),
                  Helper.allowHeight(40),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Congrats",
                        style: TextStyle(
                          fontSize: 36,
                          color: Color(0xffF05353),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Helper.allowHeight(20),
                      const Text(
                        "Your order has been placed successully!!",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Helper.allowHeight(30),
                      const Text(
                        "Thank You!!!... ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )));
  }

  // static getVersion() async {
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   Initializer.version = '${packageInfo.version}+${packageInfo.buildNumber}';
  // }
}
