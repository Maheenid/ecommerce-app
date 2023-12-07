class UserModel {
  final String userId, userName, userImage, userEmail;
  final List userCart, userFavorite;
  UserModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userImage,
    required this.userCart,
    required this.userFavorite,
  });
}
