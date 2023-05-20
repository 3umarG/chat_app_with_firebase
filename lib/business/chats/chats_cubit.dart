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

  Stream<QuerySnapshot<Map<String, dynamic>>>? usersStream() {
    if (ApiServices.user != null) {
      return firestore
          .collection("users")
          .where('id', isNotEqualTo: ApiServices.user!.uid)
          .snapshots();
    } else {
      return null;
    }
  }

  List<ChatUser> getUsersFromSnapshot(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>? snapshot) {
    allUsers = List<ChatUser>.from(snapshot != null
        ? snapshot.data!.docs.map((e) => ChatUser.fromJson(e.data()))
        : []);
    return allUsers;
  }

  /// ******************** For Messages *********************

  List<Message> allMessages = [];

  /// ****************** Get all messages stream between me and another user
  /// Chats (collection) ===>
  ///        conversations between two users : conversation_id (doc) ===>
  ///              messages (collection) ===>
  ///                   message (doc) with time as a unique id .
  Stream<QuerySnapshot<Map<String, dynamic>>> messagesStream(
      ChatUser connectedUser) {
    return firestore
        .collection("chats/${_getConversationId(connectedUser.id!)}/messages/")
        .snapshots();
  }

  List<Message> getMessagesListFromSnapshot(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    allMessages = List<Message>.from(
        snapshot.data!.docs.map((e) => Message.fromJson(e.data())));
    return allMessages;
  }

  String _getConversationId(String id) =>
      ApiServices.user!.uid.hashCode <= id.hashCode
          ? "${ApiServices.user!.uid}_$id"
          : "${id}_${ApiServices.user!.uid}";

  /// Send Message Function
  Future<void> sendMessage(ChatUser connectedUser, String message) async {
    emit(MessageLoadingSendState());
    try {
      final timeForSend = DateTime.now().millisecondsSinceEpoch.toString();
      final Message sendMessageObject = Message(
        fromId: ApiServices.user!.uid,
        toId: connectedUser.id!,
        sentTime: timeForSend,
        readTime: '',
        message: message,
        type: MessageType.text,
      );
      final ref = firestore
          .collection(
              "chats/${_getConversationId(connectedUser.id!)}/messages/")
          .doc(timeForSend);
      await ref.set(sendMessageObject.toJson());
    } catch (e) {
      emit(MessageErrorSendState(e.toString()));
    }
  }

  /// Mark a received message as read
  Future<void> markMessageAsRead(Message message) async {
    final ref = firestore
        .collection("chats/${_getConversationId(message.fromId)}/messages/")
        .doc(message.sentTime);

    await ref.update(
      {
        "readTime": DateTime.now().millisecondsSinceEpoch.toString(),
      },
    );
  }
}
