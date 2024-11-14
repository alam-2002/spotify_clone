import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/domain/entities/song/song.dart';
import 'package:spotify_clone/domain/usecases/songs/get_favorite_songs.dart';
import 'package:spotify_clone/service_locator.dart';
part 'favorite_song_state.dart';

class FavoriteSongCubit extends Cubit<FavoriteSongState> {
  FavoriteSongCubit() : super(FavoriteSongLoading());

  List<SongEntity> favoriteSong = [];
  Future<void> getFavoriteSong() async {
    var result = await sl<GetFavoriteSongsUseCase>().call();

    result.fold(
      (error) {
        emit(FavoriteSongFailure(errorMsg: error));
      },
      (data) {
        favoriteSong = data;
        emit(FavoriteSongLoaded(favoriteSongs: favoriteSong));
      },
    );
  }

  void removeSong(int index) {
    favoriteSong.removeAt(index);
    emit(FavoriteSongLoaded(favoriteSongs: favoriteSong));
  }
}
