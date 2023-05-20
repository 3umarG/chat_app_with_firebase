part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileInfoSuccessState extends ProfileState{}
class ProfileInfoErrorState extends ProfileState{}
class ProfileInfoLoadingState extends ProfileState{}

class UpdateProfileInfoLoadingState extends ProfileState{}
class UpdateProfileInfoSuccessState extends ProfileState{}
class UpdateProfileInfoErrorState extends ProfileState{}


class PickImageState extends ProfileState{}

class LoadImageToFirebaseStoreSuccessState extends ProfileState{}
class LoadImageToFirebaseStoreErrorState extends ProfileState{}
class LoadImageToFirebaseStoreLoadingState extends ProfileState{}


class SignOutLoadingState extends ProfileState{}
class SignOutSuccessState extends ProfileState{}
class SignOutErrorState extends ProfileState{}