import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../data/api/api_services.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  ChatsCubit() : super(ChatsInitial());

  final FirebaseFirestore firestore = ApiServices.firebaseStore;
  final currentUser = ApiServices.user;

  Stream<QuerySnapshot<Map<String , dynamic>>> usersStream() {
    return firestore
        .collection("users")
        .where('id',isNotEqualTo: currentUser.uid)
        .snapshots();
  }


}
