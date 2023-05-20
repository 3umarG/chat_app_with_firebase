part of 'chats_cubit.dart';

@immutable
abstract class ChatsState {}

class ChatsInitial extends ChatsState {}

abstract class HomeScreenUiState extends ChatsState{}
class HomeScreenUiEnableSearchState extends HomeScreenUiState{}
class HomeScreenUiTypingSearchState extends HomeScreenUiState{}
class HomeScreenUiDisableSearchState extends HomeScreenUiState{}

abstract class MessagingState extends ChatsState{}
class MessageLoadingSendState extends MessagingState{}
class MessageSuccessSendState extends MessagingState{}
class MessageErrorSendState extends MessagingState{
  final String message;

  MessageErrorSendState(this.message);
}
