import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../data/api/api_services.dart';
import '../../data/models/chat_user.dart';
import '../../data/models/message_model.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  ChatsCubit() : super(ChatsInitial());


  /// *************** General Usage ******************
  final FirebaseFirestore firestore = ApiServices.firebaseStore;
  final currentUser = ApiServices.user;
  
  
  /// *************** For Users Chats *******************
  List<ChatUser> allUsers = [];
  List<ChatUser> searchedList = [];

  void enableSearch() {
    emit(HomeScreenUiEnableSearchState());
  }

  void disableSearch() {
    emit(HomeScreenUiDisableSearchState());
  }

  void searchUser(String searchQuery) {
    searchedList = allUsers
        .where((user) =>
            user.name!.toLowerCase().contains(searchQuery) ||
            user.email!.toLowerCase().contains(searchQuery))
        .toList();
    emit(HomeScreenUiTypingSearchState());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> usersStream() {
    return firestore
        .collection("users")
        .where('id', isNotEqualTo: currentUser.uid)
        .snapshots();
  }

  List<ChatUser> getUsersFromSnapshot(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    allUsers = List<ChatUser>.from(
        snapshot.data!.docs.map((e) => ChatUser.fromJson(e.data())));
    return allUsers;
  }
  
  
  /// ******************** For Messages *********************

  List<Message> allMessages = [];
  Stream<QuerySnapshot<Map<String , dynamic>>> messagesStream() {
    return firestore.collection("messages").snapshots();
  }

  List<Message> getMessagesListFromSnapshot(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    allMessages = List<Message>.from(
        snapshot.data!.docs.map((e) => Message.fromJson(e.data())));
    return allMessages;
  }
  
}
