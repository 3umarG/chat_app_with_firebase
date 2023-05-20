import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../../data/api/api_services.dart';
import '../../data/models/chat_user.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  ChatUser? currentUser;

  Future<void> getTheCurrentUser() async {
    try {
      emit(ProfileInfoLoadingState());
      DocumentSnapshot<Map<String, dynamic>> snapshot = await ApiServices
          .firebaseStore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data()!;
        ChatUser currentUser = ChatUser.fromJson(userData);
        this.currentUser = currentUser;
        emit(ProfileInfoSuccessState());
      } else {
        emit(ProfileInfoErrorState());
      }
    } catch (e) {
      emit(ProfileInfoErrorState());
    }
  }


  Future<void> updateUserInfo(String name, String about) async {
    try {
      emit(UpdateProfileInfoLoadingState());
      ApiServices.firebaseStore.collection("users").doc(currentUser!.id).update(
        {
          'name': name,
          'about': about,
        },
      );
      emit(UpdateProfileInfoSuccessState());
    } catch (e) {
      emit(UpdateProfileInfoErrorState());
    }
  }

  String? image;

  Future<void> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        this.image = image.path;
        emit(PickImageState());

        /// TODO : upload the Image to the Firebase Storage
        File file = File(this.image!);
        final ref = ApiServices.firebaseStorage.ref().child(
            "profile_pictures/${currentUser!.id}.${file.path
                .split(".")
                .last}");

        // upload the file
        emit(LoadImageToFirebaseStoreLoadingState());
        await ref.putFile(file);

        // update the image in database of the user
        currentUser!.image = await ref.getDownloadURL();
        ApiServices.firebaseStore.collection("users")
            .doc(currentUser!.id)
            .update(
          {
            'image': currentUser!.image
          },
        );
        emit(LoadImageToFirebaseStoreSuccessState());
      }
    } catch (e) {
      emit(LoadImageToFirebaseStoreErrorState());
    }
  }


  /// TODO : to avoid the problem of all these listeners we can separate this method to ProfileCubit
  Future<void> signOut(BuildContext context) async {
    try {
      emit(SignOutLoadingState());
      await ApiServices.firebaseAuth.signOut();
      await GoogleSignIn().signOut();
      emit(SignOutSuccessState());
    } catch (e) {
      debugPrint(e.toString());
      emit(SignOutErrorState());
    }
  }

}
