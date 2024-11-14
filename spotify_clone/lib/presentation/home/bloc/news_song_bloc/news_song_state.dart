import 'package:spotify_clone/domain/entities/song/song.dart';

abstract class NewsSongState {}

// Loading state
class NewsSongLoading extends NewsSongState {}

// Loaded state
class NewsSongLoaded extends NewsSongState {
  final List<SongEntity> songs;
  NewsSongLoaded({required this.songs});
}

// Error state
class NewsSongFailure extends NewsSongState {
  final String errorMsg;
  NewsSongFailure({required this.errorMsg});
}
