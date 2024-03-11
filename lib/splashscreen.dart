import 'package:fakestore/keep/localstorage.dart';
import 'package:fakestore/ui/authentication/loginscreen.dart';
import 'package:fakestore/ui/helper/helper.dart';
import 'package:fakestore/ui/homescreen.dart';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _fetchdata();
    super.initState();
  }

  Future<void> _fetchdata() async {
    bool isLoggedIn = await LocalStorage.getIsloggedIn();

    if (isLoggedIn == true) {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Helper.pushReplacement(context, const HomeScreen());
      }
    } else {
      if (mounted) {
        Helper.pushReplacement(context, const LoginScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/academylogo.jpg"),
            fit: BoxFit.contain,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.only(
            bottom: 100,
          ),
          child: const Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    color: Color(0xff68d389),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
