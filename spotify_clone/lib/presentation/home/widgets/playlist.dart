import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/common/helper/extension/is_dark_mode.dart';
import 'package:spotify_clone/common/helper/navigation/app_navigation.dart';
import 'package:spotify_clone/common/widgets/button/favorite_button.dart';
import 'package:spotify_clone/core/config/theme/app_color.dart';
import 'package:spotify_clone/domain/entities/song/song.dart';
import 'package:spotify_clone/presentation/home/bloc/playlist_bloc/playlist_cubit.dart';
import 'package:spotify_clone/presentation/home/bloc/playlist_bloc/playlist_state.dart';
import 'package:spotify_clone/presentation/song_player/pages/song_player.dart';

class Playlist extends StatelessWidget {
  const Playlist({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlaylistCubit()..getPlaylist(),
      child: BlocBuilder<PlaylistCubit, PlaylistState>(
        builder: (context, state) {
          log('$state}');
          // Loading state
          if (state is PlaylistLoading) {
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }

          // Loaded state
          if (state is PlaylistLoaded) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Playlist',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'See More',
                        style: TextStyle(color: Color(0xffC6C6C6), fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  _songs(state.songs),
                ],
              ),
            );
          }

          // Error state
          if (state is PlaylistFailure) {
            return Center(child: Text(state.errorMsg));
          }

          // Default
          return Container();
        },
      ),
    );
  }

  Widget _songs(List<SongEntity> songs) {
    return ListView.separated(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: songs.length,
      separatorBuilder: (context, state) => SizedBox(height: 15),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            AppNavigator.push(
              context,
              SongPlayerPage(songEntity: songs[index]),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.isDarkMode ? AppColors.darkGrey : Color(0xffE6E6E6),
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: context.isDarkMode ? Color(0xff959595) : Color(0xff555555),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        songs[index].title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        songs[index].artist,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    songs[index].duration.toString().replaceAll('.', ':'),
                  ),
                  SizedBox(width: 20),
                  FavoriteButton(songEntity: songs[index]),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
