import 'package:spotify_clone/domain/entities/song/song.dart';

abstract class PlaylistState {}

// Loading state
class PlaylistLoading extends PlaylistState {}

// Loaded state
class PlaylistLoaded extends PlaylistState {
  final List<SongEntity> songs;
  PlaylistLoaded({required this.songs});
}

// Error state
class PlaylistFailure extends PlaylistState {
  final String errorMsg;
  PlaylistFailure({required this.errorMsg});
}
