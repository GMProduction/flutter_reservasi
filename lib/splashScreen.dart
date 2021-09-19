// ignore_for_file: file_names, prefer_const_constructors_in_immutables

import 'dart:async';

import 'package:flutter/material.dart';


import 'component/genColor.dart';
import 'component/genPreferrence.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  var opacity = 0.0;
  String buildNumber = "";

  @override
  void initState() {
    super.initState();

  }


  @override
  dispose() {
    super.dispose();
  }


  cekLogin() async {
  // await setPrefferenceToken('asd');
  //    await setPrefferenceToken('initoken');

     // await logout();


    var log = await getPrefferenceToken();

    print("lognya $log");
     var _duration = Duration(milliseconds: 2000);
     return Timer(_duration,  (){ log == "belumlogin"
         ? Navigator.pushReplacementNamed(context, "login")
         : Navigator.pushReplacementNamed(context, "base");});

//    return
//    if (log == null){
//      return Navigator.pushReplacementNamed(context, '/login');
//    }
  }

  startSplashScreen()  {
    print("checklogin");
    cekLogin();

    // var token = await getPrefferenceToken();
    // // var token = "asw";
    // if (token) {
    //   var duration = const Duration(milliseconds: 2000);
    //   return Timer(duration, () {
    //     Navigator.pushReplacementNamed(context, "loginPage");
    //   });
    // } else {
    //   var duration = const Duration(milliseconds: 2000);
    //   return Timer(duration, () {
    //     // Navigator.pushReplacementNamed(
    //     //     context, "welcome");
    //     Navigator.pushReplacementNamed(context, "base");
    //   });
    // }
  }

  startAnim(){
    Timer(Duration(milliseconds: 100),  (){ setState(() {
      opacity = 1.0;
    });});
  }

  bool loaded = false;
  @override
  Widget build(BuildContext context) {



    if(!loaded){
      startAnim();
      startSplashScreen();
      loaded = true;
    }

    return Scaffold(
      body: Container(
        color: GenColor.primaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                curve: Curves.easeIn,
                duration: Duration(milliseconds: 1000),
                opacity: opacity,
                child: Image.asset(
                  'assets/images/logovert.png',
                  width: .4,
                  fit: BoxFit.fitWidth,
                ),

              ),
              Text(buildNumber, style: TextStyle(color: Colors.white),)

            ],
          ),
        ),
      ),
    );
  }
}
