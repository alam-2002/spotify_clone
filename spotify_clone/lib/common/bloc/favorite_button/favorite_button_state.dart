abstract class FavoriteButtonState {}


// Initial
class FavoriteButtonInitial extends FavoriteButtonState {}

// Loaded
class FavoriteButtonUpdated extends FavoriteButtonState {
  final bool isFavorite;

  FavoriteButtonUpdated({required this.isFavorite});
}

// Error state
class FavoriteButtonFailure extends FavoriteButtonState {
  final String errorMsg;
  FavoriteButtonFailure({required this.errorMsg});
}
