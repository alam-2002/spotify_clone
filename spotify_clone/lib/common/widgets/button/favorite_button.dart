import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/common/bloc/favorite_button/favorite_button_cubit.dart';
import 'package:spotify_clone/common/bloc/favorite_button/favorite_button_state.dart';
import 'package:spotify_clone/core/config/theme/app_color.dart';
import 'package:spotify_clone/domain/entities/song/song.dart';

class FavoriteButton extends StatelessWidget {
  final SongEntity songEntity;
  final void Function()? function;
  const FavoriteButton({
    super.key,
    required this.songEntity,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteButtonCubit() /*..favoriteButtonUpdated(songEntity.songId)*/,
      child: BlocBuilder<FavoriteButtonCubit, FavoriteButtonState>(
        builder: (context, state) {
          // print(state);

          // initial state
          if (state is FavoriteButtonInitial) {
            return IconButton(
              onPressed: () async {
                await context.read<FavoriteButtonCubit>().favoriteButtonUpdated(songEntity.songId);

                if(function != null){
                  function !();
                }

              },
              icon: Icon(
                songEntity.isFavorite ? Icons.favorite_sharp : Icons.favorite_outline_outlined,
                size: 25,
                color: songEntity.isFavorite ? AppColors.primary : AppColors.darkGrey,
              ),
            );
          }

          // Loaded state
          if (state is FavoriteButtonUpdated) {
            return IconButton(
              onPressed: () {
                context.read<FavoriteButtonCubit>().favoriteButtonUpdated(songEntity.songId);
              },
              icon: Icon(
                songEntity.isFavorite ? Icons.favorite : Icons.favorite_outline_outlined,
                size: 25,
                color: songEntity.isFavorite ? AppColors.primary : AppColors.darkGrey,
                // color: AppColors.primary,
              ),
            );
          }

          // Error state
          if (state is FavoriteButtonFailure) {
            return Center(child: Text(state.errorMsg));
          }

          // Default
          return Container();
        },
      ),
    );
  }
}
