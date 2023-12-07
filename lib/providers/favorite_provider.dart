import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/favorite_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  Map<String, FavoriteModel> favoriteMap = {};

  final usersTdb = FirebaseFirestore.instance.collection('users');
  Future<void> addFavorteToFirebase({
    required productId,
    required productTitle,
    required productImage,
    required productPrice,
    required BuildContext context,
  }) async {
    final users = FirebaseAuth.instance.currentUser;
    if (users == null) {
      showDialog(
        context: context,
        builder: (ctx) => const AlertDialog(
          title: Text('you must login'),
        ),
      );

      return;
    }
    if (favoriteMap.containsKey(productId)) {
      await usersTdb.doc(users.uid).update({
        'userFavorite': FieldValue.arrayRemove([
          {
            'productId': productId,
            'productTitle': productTitle,
            'productImage': productImage,
            'productPrice': productPrice,
          }
        ]),
      });

      favoriteMap.remove(productId);
      notifyListeners();

      return;
    }

    try {
      await usersTdb.doc(users.uid).update({
        'userFavorite': FieldValue.arrayUnion(
          [
            {
              'productId': productId,
              'productTitle': productTitle,
              'productImage': productImage,
              'productPrice': productPrice,
            }
          ],
        ),
      });
      if (context.mounted) {
        await fetchDataFromFirebase(context: context);
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  Future<void> fetchDataFromFirebase({required BuildContext context}) async {
    final users = FirebaseAuth.instance.currentUser;
    if (users == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('you must login'),
        ),
      );
    }

    final usersDoc = await usersTdb.doc(users?.uid).get();
    final leng = usersDoc.get('userFavorite').length;
    try {
      for (int index = 0; index < leng; index++) {
        favoriteMap.putIfAbsent(
          usersDoc.get('userFavorite')[index]['productId'],
          () => FavoriteModel(
            productId: usersDoc.get('userFavorite')[index]['productId'],
            productTitle: usersDoc.get('userFavorite')[index]['productTitle'],
            productPrice: usersDoc.get('userFavorite')[index]['productPrice'],
            productImage:
                usersDoc.get('userFavorite')[index]['productImage'].toString(),
          ),
        );
      }
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
    notifyListeners();
  }

  Future<void> removeFavoriteItemFromFirebase({
    required productId,
    required productTitle,
    required productImage,
    required productPrice,
    required BuildContext context,
  }) async {
    final users = FirebaseAuth.instance.currentUser;
    try {
      await usersTdb.doc(users?.uid).update({
        'userFavorite': FieldValue.arrayRemove([
          {
            'productId': productId,
            'productTitle': productTitle,
            'productImage': productImage,
            'productPrice': productPrice,
          }
        ]),
      });
      favoriteMap.remove(productId);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('item has been removed'),
        ),
      );
    }
  }

  void addToFavorite({
    required String productId,
    required String title,
    required String image,
    required String price,
  }) {
    favoriteMap.putIfAbsent(
      productId,
      () => FavoriteModel(
        productTitle: title,
        productImage: image,
        productPrice: price,
        productId: productId,
      ),
    );
    notifyListeners();
  }

  bool isExist({required String productId}) {
    return favoriteMap.containsKey(productId);
  }

  void clearFavorite() {
    favoriteMap.clear();
    notifyListeners();
  }

  void removeFavorite({required String productId}) {
    favoriteMap.remove(productId);
    notifyListeners();
  }
}
