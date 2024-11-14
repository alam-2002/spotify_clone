abstract class SongPlayerState {}

// Loading state
class SongPlayerLoading extends SongPlayerState {}

// Loaded state
class SongPlayerLoaded extends SongPlayerState {}

// Error state
class SongPlayerFailure extends SongPlayerState {
  final String errorMsg;
  SongPlayerFailure({required this.errorMsg});
}
