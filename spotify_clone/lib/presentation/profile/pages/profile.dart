import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/common/helper/extension/is_dark_mode.dart';
import 'package:spotify_clone/common/helper/navigation/app_navigation.dart';
import 'package:spotify_clone/common/widgets/appbar/app_bar.dart';
import 'package:spotify_clone/common/widgets/button/favorite_button.dart';
import 'package:spotify_clone/core/config/constants/app_urls.dart';
import 'package:spotify_clone/presentation/profile/bloc/favorite_song_bloc/favorite_song_cubit.dart';
import 'package:spotify_clone/presentation/profile/bloc/profile_info_bloc/profile_info_cubit.dart';
import 'package:spotify_clone/presentation/profile/bloc/profile_info_bloc/profile_info_state.dart';
import 'package:spotify_clone/presentation/song_player/pages/song_player.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: context.isDarkMode ? Color(0xff2C2B2B) : Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _profileInfo(context),
            SizedBox(height: 20),
            _favoriteSongs(),
          ],
        ),
      ),
    );
  }

  Widget _profileInfo(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileInfoCubit()..getUser(),
      child: Container(
        height: MediaQuery.of(context).size.height / 3.5,
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.isDarkMode ? Color(0xff2C2B2B) : Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
        child: BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
          builder: (context, state) {
            // loading state
            if (state is ProfileInfoLoading) {
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            }

            // loaded state
            if (state is ProfileInfoLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(state.userEntity.imageURL!),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(state.userEntity.email!),
                  SizedBox(height: 15),
                  Text(
                    state.userEntity.fullName!,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            }

            // error state
            if (state is ProfileInfoFailure) {
              return Center(child: Text(state.errorMsg));
            }

            // default
            return Container();
          },
        ),
      ),
    );
  }

  Widget _favoriteSongs() {
    return BlocProvider(
      create: (context) => FavoriteSongCubit()..getFavoriteSong(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('FAVORITE SONGS'),
            SizedBox(height: 20),
            BlocBuilder<FavoriteSongCubit, FavoriteSongState>(
              builder: (context, state) {
                // Loading state
                if (state is FavoriteSongLoading) {
                  return Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
                }

                // Loaded state
                if (state is FavoriteSongLoaded) {
                  return ListView.separated(
                    itemCount: state.favoriteSongs.length,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          AppNavigator.push(context, SongPlayerPage(songEntity: state.favoriteSongs[index]));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(AppURLs.imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.favoriteSongs[index].title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      state.favoriteSongs[index].artist,
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
                                  state.favoriteSongs[index].duration.toString().replaceAll('.', ':'),
                                ),
                                SizedBox(width: 20),
                                FavoriteButton(
                                  key: UniqueKey(),
                                  songEntity: state.favoriteSongs[index],
                                  function: () {
                                    context.read<FavoriteSongCubit>().removeSong(index);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }

                // Error state
                if (state is FavoriteSongFailure) {
                  return Center(child: Text(state.errorMsg));
                }

                // Default
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
