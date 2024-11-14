part of 'favorite_song_cubit.dart';

@immutable
sealed class FavoriteSongState {}

// loading state
final class FavoriteSongLoading extends FavoriteSongState {}

// loaded state
final class FavoriteSongLoaded extends FavoriteSongState {
  final List<SongEntity> favoriteSongs;

  FavoriteSongLoaded({required this.favoriteSongs});
}

// error state
final class FavoriteSongFailure extends FavoriteSongState {
  final String errorMsg;

  FavoriteSongFailure({required this.errorMsg});
}
