import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify_clone/data/models/song/song.dart';
import 'package:spotify_clone/domain/entities/song/song.dart';
import 'package:spotify_clone/domain/usecases/songs/is_favorite.dart';
import 'package:spotify_clone/service_locator.dart';

abstract class SongFirebaseService {
  Future<Either> getNewsSongs();
  Future<Either> getPlaylist();
  Future<Either> addOrRemoveFavorite(String songId);
  Future<bool> isFavorite(String songId);
  Future<Either> getFavoriteSongs();
}

class SongFirebaseServiceImpl extends SongFirebaseService {
  @override
  Future<Either> getNewsSongs() async {
    try {
      List<SongEntity> songs = [];
      var data = await FirebaseFirestore.instance.collection('songs').orderBy('releaseDate', descending: true).limit(3).get();

      for (var element in data.docs) {
        var songModel = SongModel.fromJson(element.data());
        var isFavorite = await sl<IsFavoriteSongUseCase>().call(params: element.reference.id);
        songModel.isFavorite = isFavorite;
        songModel.songId = element.reference.id;
        songs.add(songModel.toEntity());
      }
      return Right(songs);
    } catch (e) {
      return Left('An Error Occurred - $e');
    }
  }

  @override
  Future<Either> getPlaylist() async {
    try {
      List<SongEntity> songs = [];
      var data = await FirebaseFirestore.instance.collection('songs').orderBy('releaseDate', descending: true).get();

      for (var element in data.docs) {
        var songModel = SongModel.fromJson(element.data());
        var isFavorite = await sl<IsFavoriteSongUseCase>().call(params: element.reference.id);
        songModel.isFavorite = isFavorite;
        songModel.songId = element.reference.id;
        songs.add(songModel.toEntity());
      }
      return Right(songs);
    } catch (e) {
      log('getPlaylist Error - ${e.toString()}');
      return Left('An Error Occurred - $e');
    }
  }

  @override
  Future<Either> addOrRemoveFavorite(String songId) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      late bool isFavorite;
      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      QuerySnapshot favoriteSongs =
          await firebaseFirestore.collection('Users').doc(uId).collection('Favorites').where('songId', isEqualTo: songId).get();

      if (favoriteSongs.docs.isNotEmpty) {
        await favoriteSongs.docs.first.reference.delete();
        isFavorite = false;
      } else {
        await firebaseFirestore.collection('Users').doc(uId).collection('Favorites').add({
          'songId': songId,
          'addedData': Timestamp.now(),
        });
        isFavorite = true;
      }
      return Right(isFavorite);
    } catch (e) {
      return Left('Error in addOrRemoveFavorite - ${e.toString()}');
    }
  }

  @override
  Future<bool> isFavorite(String songId) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      QuerySnapshot favoriteSongs =
          await firebaseFirestore.collection('Users').doc(uId).collection('Favorites').where('songId', isEqualTo: songId).get();

      if (favoriteSongs.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either> getFavoriteSongs() async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      var user = firebaseAuth.currentUser;
      String uId = user!.uid;
      List<SongEntity> favoriteSongs = [];

      QuerySnapshot favoriteSnapshot = await firebaseFirestore.collection('Users').doc(uId).collection('Favorites').get();
      
      for (var elements in favoriteSnapshot.docs) {
        String songId = elements['songId'];
        var song = await firebaseFirestore.collection('songs').doc(songId).get();
        SongModel songModel = SongModel.fromJson(song.data()!);
        songModel.isFavorite = true;
        songModel.songId = songId;
        favoriteSongs.add(songModel.toEntity());
      }

      return Right(favoriteSongs);
      
    } catch (e) {
      log('getPlaylist Error - ${e.toString()}');
      return Left('Error - ${e.toString()}');
    }
  }
}
