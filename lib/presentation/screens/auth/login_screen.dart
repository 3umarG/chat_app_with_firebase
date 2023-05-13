import 'package:chat_app/business/auth/auth_cubit.dart';
import 'package:chat_app/core/constants/routes.dart';
import 'package:chat_app/core/helper/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/media_query.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            top: mediaQuery(context).height * 0.15,
            right: _isAnimate
                ? mediaQuery(context).width * 0.25
                : -mediaQuery(context).width * 0.5,
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
            child: BlocListener<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthGoogleSignInFirebaseErrorState) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      duration: const Duration(seconds: 3),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is AuthGoogleSignInNoInternetState) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("No Internet , try again !!!"),
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is AuthGoogleSignInSuccessState) {
                  Navigator.pop(context);
                  debugPrint("User : ${state.user.email}");
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.homeScreenRoute);
                } else {
                  Dialogs.showLoadingDialog(context);
                }
              },
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent.withOpacity(0.6),
                    elevation: 2,
                    shape: const StadiumBorder()),
                onPressed: () {
                  context.read<AuthCubit>().handleGoogleSignIn();
                },
                icon: Image.asset(
                  "assets/images/google.png",
                  height: mediaQuery(context).height * .04,
                ),
                label: RichText(
                  text: const TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(text: "Sign In with "),
                        TextSpan(
                          text: "Google",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ]),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
