part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

abstract class AuthGoogleSignInState extends AuthState{}
class AuthGoogleSignInLoadingState extends AuthGoogleSignInState {}

class AuthGoogleSignInFirebaseErrorState extends AuthGoogleSignInState {
  final String message;

  AuthGoogleSignInFirebaseErrorState(this.message);
}

class AuthGoogleSignInNoInternetState extends AuthGoogleSignInState{}
class AuthGoogleSignInSuccessState extends AuthGoogleSignInState {
  final User user;

  AuthGoogleSignInSuccessState(this.user);
}

abstract class AuthSignOutState extends AuthState{}
class AuthSignOutLoadingState extends AuthSignOutState{}
class AuthSignOutErrorState extends AuthSignOutState{}
class AuthSignOutSuccessState extends AuthSignOutState{}


abstract class AuthProfileInfoState extends AuthState{}

class AuthProfileInfoLoadingState extends AuthProfileInfoState{}
class AuthProfileInfoSuccessState extends AuthProfileInfoState{}
class AuthProfileInfoErrorState extends AuthProfileInfoState{}

class AuthProfileUpdateInfoLoadingState extends AuthProfileInfoState{}
class AuthProfileUpdateInfoSuccessState extends AuthProfileInfoState{}
class AuthProfileUpdateInfoErrorState extends AuthProfileInfoState{}

class AuthPickImageState extends AuthProfileInfoState {}
class AuthUploadImageToStorageLoadingState extends AuthProfileInfoState{}
class AuthUploadImageToStorageSuccessState extends AuthProfileInfoState{}
class AuthUploadImageToStorageErrorState extends AuthProfileInfoState{
  final String message;

  AuthUploadImageToStorageErrorState(this.message);
}
