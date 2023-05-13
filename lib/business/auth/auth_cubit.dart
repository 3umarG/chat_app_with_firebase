import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> handleGoogleSignIn() async {
    try {
      debugPrint("Try to Login");
      emit(AuthGoogleSignInLoadingState());
      final user = await _signInWithGoogle();
      debugPrint("Success");
      emit(AuthGoogleSignInSuccessState(user.user!));
    }on SocketException {
      emit(AuthGoogleSignInNoInternetState());
    }on FirebaseException catch(e){
      emit(AuthGoogleSignInFirebaseErrorState(e.code));
    }
  }

  Future<UserCredential> _signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
