part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthGoogleSignInLoadingState extends AuthState {}

class AuthGoogleSignInFirebaseErrorState extends AuthState {
  final String message;

  AuthGoogleSignInFirebaseErrorState(this.message);
}

class AuthGoogleSignInNoInternetState extends AuthState{}
class AuthGoogleSignInSuccessState extends AuthState {
  final User user;

  AuthGoogleSignInSuccessState(this.user);
}


class AuthSignOutLoadingState extends AuthState{}
class AuthSignOutErrorState extends AuthState{}
class AuthSignOutSuccessState extends AuthState{}


abstract class AuthProfileInfoState extends AuthState{}

class AuthProfileInfoLoadingState extends AuthProfileInfoState{}
class AuthProfileInfoSuccessState extends AuthProfileInfoState{}
class AuthProfileInfoErrorState extends AuthProfileInfoState{}

class AuthProfileUpdateInfoLoadingState extends AuthProfileInfoState{}
class AuthProfileUpdateInfoSuccessState extends AuthProfileInfoState{}
class AuthProfileUpdateInfoErrorState extends AuthProfileInfoState{}
