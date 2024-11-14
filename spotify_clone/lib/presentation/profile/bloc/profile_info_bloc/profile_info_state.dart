import 'package:spotify_clone/domain/entities/auth/user.dart';

abstract class ProfileInfoState {}

// Loading state
class ProfileInfoLoading extends ProfileInfoState {}

// Loaded state
class ProfileInfoLoaded extends ProfileInfoState {
  final UserEntity userEntity;

  ProfileInfoLoaded({required this.userEntity});
}

// Error state
class ProfileInfoFailure extends ProfileInfoState {
  final String errorMsg;
  ProfileInfoFailure({required this.errorMsg});
}
