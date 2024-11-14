import 'package:get_it/get_it.dart';
import 'package:spotify_clone/data/repository/auth/auth_repo_impl.dart';
import 'package:spotify_clone/data/repository/songs/song_repo_impl.dart';
import 'package:spotify_clone/data/source/auth/auth_firebase_service.dart';
import 'package:spotify_clone/data/source/songs/song_firebase_service.dart';
import 'package:spotify_clone/domain/repository/auth/auth_repository.dart';
import 'package:spotify_clone/domain/repository/song/song_repo.dart';
import 'package:spotify_clone/domain/usecases/auth/get_user.dart';
import 'package:spotify_clone/domain/usecases/auth/signin.dart';
import 'package:spotify_clone/domain/usecases/auth/signup.dart';
import 'package:spotify_clone/domain/usecases/songs/add_or_remove_favorite.dart';
import 'package:spotify_clone/domain/usecases/songs/get_favorite_songs.dart';
import 'package:spotify_clone/domain/usecases/songs/get_news_song.dart';
import 'package:spotify_clone/domain/usecases/songs/get_playlist.dart';
import 'package:spotify_clone/domain/usecases/songs/is_favorite.dart';


final sl = GetIt.instance;

Future<void> initializeDependencies() async {

  // -- REPOSITORY --
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<SongRepository>(SongRepositoryImpl());

  // -- SERVICE --
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  sl.registerSingleton<SongFirebaseService>(SongFirebaseServiceImpl());

  // -- USE_CASES --
  sl.registerSingleton<SignupUseCase>(SignupUseCase());
  sl.registerSingleton<SigninUseCase>(SigninUseCase());
  sl.registerSingleton<GetNewsSongUseCase>(GetNewsSongUseCase());
  sl.registerSingleton<GetPlaylistUseCase>(GetPlaylistUseCase());
  sl.registerSingleton<AddOrRemoveFavoriteSongUseCase>(AddOrRemoveFavoriteSongUseCase());
  sl.registerSingleton<IsFavoriteSongUseCase>(IsFavoriteSongUseCase());
  sl.registerSingleton<GetUserUseCase>(GetUserUseCase());
  sl.registerSingleton<GetFavoriteSongsUseCase>(GetFavoriteSongsUseCase());

}
