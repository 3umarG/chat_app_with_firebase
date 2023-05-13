import 'package:chat_app/core/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/media_query.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)
          .then((value) {
        SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

        if (FirebaseAuth.instance.currentUser == null) {
          Navigator.pushReplacementNamed(context, AppRoutes.loginScreenRoute);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.homeScreenRoute);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: mediaQuery(context).height * 0.15,
            right: mediaQuery(context).width * 0.25,
            width: mediaQuery(context).width * 0.5,
            child: Image.asset(
              "assets/images/chat.png",
            ),
          ),
          Positioned(
            bottom: mediaQuery(context).height * 0.15,
            height: mediaQuery(context).height * .06,
            width: mediaQuery(context).width * .9,
            left: mediaQuery(context).width * 0.05,
            child: Text(
              "Chat App",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.greenAccent.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
