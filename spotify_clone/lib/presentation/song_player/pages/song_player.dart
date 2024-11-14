import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/common/widgets/appbar/app_bar.dart';
import 'package:spotify_clone/common/widgets/button/favorite_button.dart';
import 'package:spotify_clone/core/config/constants/app_urls.dart';
import 'package:spotify_clone/core/config/theme/app_color.dart';
import 'package:spotify_clone/domain/entities/song/song.dart';
import 'package:spotify_clone/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:spotify_clone/presentation/song_player/bloc/song_player_state.dart';

class SongPlayerPage extends StatelessWidget {
  final SongEntity songEntity;

  const SongPlayerPage({
    super.key,
    required this.songEntity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          'Now Playing',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        actions: [IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.more_vert_rounded,
          ),
        ),]
      ),
      body: BlocProvider(
        create: (context) => SongPlayerCubit()..loadSong(AppURLs.songUrl),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            children: [
              _songCover(context),
              SizedBox(height: 20),
              _songDetails(),
              SizedBox(height: 20),
              _songPlayer(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _songCover(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(AppURLs.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _songDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              songEntity.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 5),
            Text(
              songEntity.artist,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 17,
              ),
            ),
          ],
        ),
        FavoriteButton(songEntity: songEntity),
      ],
    );
  }

  Widget _songPlayer(BuildContext context) {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
      builder: (context, state) {
        // Loading state
        if (state is SongPlayerLoading) {
          return Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }

        // Loaded state
        if (state is SongPlayerLoaded) {
          return Column(
            children: [
              Slider(
                value: context.read<SongPlayerCubit>().songPosition.inSeconds.toDouble(),
                min: 0.0,
                max: context.read<SongPlayerCubit>().songDuration.inSeconds.toDouble(),
                onChanged: (value) {},
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatDuration(context.read<SongPlayerCubit>().songPosition),
                  ),
                  Text(
                    formatDuration(context.read<SongPlayerCubit>().songDuration),
                  ),
                ],
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: (){
                  context.read<SongPlayerCubit>().playOrPauseSong();
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: Icon(
                    context.read<SongPlayerCubit>().audioPlayer.playing ? Icons.pause : Icons.play_arrow,
                    size: 40,
                  ),
                ),
              ),
            ],
          );
        }

        // Error state
        if (state is SongPlayerFailure) {
          return Center(child: Text(state.errorMsg));
        }

        // Default
        return Container();
      },
    );
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
