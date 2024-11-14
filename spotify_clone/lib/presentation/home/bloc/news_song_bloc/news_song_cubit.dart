import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/domain/usecases/songs/get_news_song.dart';
import 'package:spotify_clone/presentation/home/bloc/news_song_bloc/news_song_state.dart';
import 'package:spotify_clone/service_locator.dart';

class NewsSongCubit extends Cubit<NewsSongState> {
  NewsSongCubit() : super(NewsSongLoading());

  Future<void> getNewsSongs() async {
    var returnedData = await sl<GetNewsSongUseCase>().call();

    returnedData.fold(
      (error) {
        emit(NewsSongFailure(errorMsg: error));
      },
      (data) {
        emit(NewsSongLoaded(songs: data));
      },
    );
  }
}
