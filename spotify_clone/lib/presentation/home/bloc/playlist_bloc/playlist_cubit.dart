import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/domain/usecases/songs/get_playlist.dart';
import 'package:spotify_clone/presentation/home/bloc/playlist_bloc/playlist_state.dart';
import 'package:spotify_clone/service_locator.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  PlaylistCubit() : super(PlaylistLoading());

  Future<void> getPlaylist() async {
    var returnedData = await sl<GetPlaylistUseCase>().call();

    returnedData.fold(
      (error) {
        emit(PlaylistFailure(errorMsg: error));
      },
      (data) {
        emit(PlaylistLoaded(songs: data));
      },
    );
  }
}
