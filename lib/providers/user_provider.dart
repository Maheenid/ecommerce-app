import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel? userModel;

  User? user = FirebaseAuth.instance.currentUser;

  Future<UserModel?> fetchUserInfo(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    String uid = user.uid;
    try {
      final userDc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      userModel = UserModel(
        userId: userDc.get('userId'),
        userName: userDc.get('userName'),
        userEmail: userDc.get('userEmail'),
        userImage: userDc.get('userImage'),
        userCart: userDc.get('userCart'),
        userFavorite: userDc.get('userFavorite'),
      );
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
    return userModel;
  }
}
