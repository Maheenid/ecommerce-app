import 'package:cloud_firestore/cloud_firestore.dart';

class UploadUserInformation {
  uploadData({
    required user,
    required userName,
    required userImage,
    required userEmail,
    required userCart,
    required userFavorite,
    required userOrder,
  }) async {
    await FirebaseFirestore.instance.collection("users").doc(user).set({
      'userId': user,
      'userName': userName,
      'userImage': userImage,
      'userEmail': userEmail,
      'userCart': userCart,
      'userFavorite': userFavorite,
      'userOrder': userOrder,
    });
  }
}
