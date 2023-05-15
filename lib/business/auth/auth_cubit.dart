import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat_app/data/api/api_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import '../../data/models/chat_user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  late User user;

  ChatUser? currentUser;

  Future<void> getTheCurrentUser() async {
    try {
      emit(AuthProfileInfoLoadingState());
      DocumentSnapshot<Map<String, dynamic>> snapshot = await ApiServices
          .firebaseStore
          .collection("users")
          .doc(ApiServices.user.uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data()!;
        ChatUser currentUser = ChatUser.fromJson(userData);
        this.currentUser = currentUser;
        emit(AuthProfileInfoSuccessState());
      } else {
        emit(AuthProfileInfoErrorState());
      }
    } catch (e) {
      emit(AuthProfileInfoErrorState());
    }
  }

  Future<void> signOut() async {
    try {
      emit(AuthSignOutLoadingState());
      await ApiServices.firebaseAuth.signOut();
      await GoogleSignIn().signOut();
      emit(AuthSignOutSuccessState());
    } catch (e) {
      debugPrint(e.toString());
      emit(AuthSignOutErrorState());
    }
  }

  Future<void> handleGoogleSignIn() async {
    try {
      debugPrint("Try to Login");
      emit(AuthGoogleSignInLoadingState());
      final userCred = await _signInWithGoogle();
      user = userCred.user!;
      debugPrint("Success");
      await _createUserToFireStore();
      emit(AuthGoogleSignInSuccessState(user));
    } on SocketException {
      emit(AuthGoogleSignInNoInternetState());
    } on FirebaseException catch (e) {
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

  Future<bool> _isUserExistsOnFireStore() async {
    return (await ApiServices.firebaseStore
            .collection('users')
            .doc(user.uid)
            .get())
        .exists;
  }

  Future<void> _createUserToFireStore() async {
    if (!await _isUserExistsOnFireStore()) {
      ChatUser newUser = ChatUser(
        id: user.uid,
        name: user.displayName,
        image: user.photoURL,
        about: "I'm a New User , Hy !!",
        createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
        isOnline: false,
        lastActive: DateTime.now().millisecondsSinceEpoch.toString(),
        email: user.email,
        pushToken: '',
      );
      ApiServices.firebaseStore
          .collection("users")
          .doc(user.uid)
          .set(newUser.toJson());
      debugPrint(
          "User : ${newUser.email} add Successfully to the FireStore !!!");
    }
  }
}
