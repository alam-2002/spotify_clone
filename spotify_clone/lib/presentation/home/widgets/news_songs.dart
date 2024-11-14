import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/common/helper/extension/is_dark_mode.dart';
import 'package:spotify_clone/common/helper/navigation/app_navigation.dart';
import 'package:spotify_clone/core/config/constants/app_urls.dart';
import 'package:spotify_clone/core/config/theme/app_color.dart';
import 'package:spotify_clone/domain/entities/song/song.dart';
import 'package:spotify_clone/presentation/home/bloc/news_song_bloc/news_song_cubit.dart';
import 'package:spotify_clone/presentation/home/bloc/news_song_bloc/news_song_state.dart';
import 'package:spotify_clone/presentation/song_player/pages/song_player.dart';

class NewsSongs extends StatelessWidget {
  const NewsSongs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsSongCubit()..getNewsSongs(),
      child: SizedBox(
        height: 200,
        child: BlocBuilder<NewsSongCubit, NewsSongState>(
          builder: (context, state) {
            log('$state}');
            // Loading state
            if (state is NewsSongLoading) {
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            }

            // Loaded state
            if (state is NewsSongLoaded) {
              return _songs(state.songs);
            }

            // Error state
            if (state is NewsSongFailure) {
              return Center(child: Text(state.errorMsg));
            }

            // Default
            return Container();
          },
        ),
      ),
    );
  }

  Widget _songs(List<SongEntity> songs) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: songs.length,
      separatorBuilder: (context, state) => SizedBox(width: 14),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            AppNavigator.push(
              context,
              SongPlayerPage(songEntity: songs[index]),
            );
          },
          child: Container(
            padding: EdgeInsets.only(left: 10),
            width: 170,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(AppURLs.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 40,
                        width: 40,
                        transform: Matrix4.translationValues(10, 10, 0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.isDarkMode ? AppColors.darkGrey : Color(0xffE6E6E6),
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: context.isDarkMode ? Color(0xff959595) : Color(0xff555555),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  songs[index].title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
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
          ),
        );
      },
    );
  }
}
