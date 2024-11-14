import 'package:dartz/dartz.dart';
import 'package:spotify_clone/data/source/songs/song_firebase_service.dart';
import 'package:spotify_clone/domain/repository/song/song_repo.dart';
import 'package:spotify_clone/service_locator.dart';

class SongRepositoryImpl extends SongRepository {
  @override
  Future<Either> getNewsSongs() async {
    return await sl<SongFirebaseService>().getNewsSongs();
  }

  @override
  Future<Either> getPlaylist() async {
    return await sl<SongFirebaseService>().getPlaylist();
  }

  @override
  Future<Either> addOrRemoveFavorite(String songId) async {
    return await sl<SongFirebaseService>().addOrRemoveFavorite(songId);
  }

  @override
  Future<bool> isFavorite(String songId) async {
    return await sl<SongFirebaseService>().isFavorite(songId);
  }

  @override
  Future<Either> getFavoriteSongs() async {
    return await sl<SongFirebaseService>().getFavoriteSongs();
  }
}
