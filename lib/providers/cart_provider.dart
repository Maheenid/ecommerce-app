import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/cart_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CartProvider extends ChangeNotifier {
  Map<String, CartModel> cartMap = {};

  final usersTdb = FirebaseFirestore.instance.collection('users');
  Future<void> addCartToFirebase({
    required productId,
    required productTitle,
    required productImage,
    required productPrice,
    required int qty,
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
    final cartId = const Uuid().v4();
    try {
      await usersTdb.doc(users.uid).update({
        'userCart': FieldValue.arrayUnion([
          {
            'productId': productId,
            'cartId': cartId,
            'productTitle': productTitle,
            'productImage': productImage,
            'productPrice': productPrice,
            'qty': qty,
          }
        ])
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
      return;
    }

    final usersDoc = await usersTdb.doc(users.uid).get();
    final leng = usersDoc.get('userCart').length;
    try {
      for (int index = 0; index < leng; index++) {
        cartMap.putIfAbsent(
          usersDoc.get('userCart')[index]['productId'],
          () => CartModel(
            productId: usersDoc.get('userCart')[index]['productId'],
            cartId: usersDoc.get('userCart')[index]['cartId'],
            quantity: usersDoc.get('userCart')[index]['qty'],
            productTitle: usersDoc.get('userCart')[index]['productTitle'],
            productPrice: usersDoc.get('userCart')[index]['productPrice'],
            productImage:
                usersDoc.get('userCart')[index]['productImage'].toString(),
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

  Future<void> removeCartItemFromFirebase({
    required productId,
    required cartId,
    required productTitle,
    required productImage,
    required productPrice,
    required qty,
    required BuildContext context,
  }) async {
    final users = FirebaseAuth.instance.currentUser;
    try {
      await usersTdb.doc(users?.uid).update({
        'userCart': FieldValue.arrayRemove([
          {
            'productId': productId,
            'cartId': cartId,
            'productTitle': productTitle,
            'productImage': productImage,
            'productPrice': productPrice,
            'qty': qty,
          }
        ]),
      });
      cartMap.remove(productId);
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

  void changeQuantity(
      {required String productId,
      required String title,
      required String image,
      required String price,
      required int qty}) {
    cartMap.update(
      productId,
      (value) => CartModel(
        cartId: value.cartId,
        productId: productId,
        quantity: qty,
        productTitle: title,
        productImage: image,
        productPrice: price,
      ),
    );
    notifyListeners();
  }

  bool isExist({required String productId}) {
    return cartMap.containsKey(productId);
  }

  double totalPrice() {
    double total = 0.0;
    cartMap.forEach((key, value) {
      total += double.parse(value.productPrice) * value.quantity;
    });
    return total;
  }

  void removeCart({required String productId}) {
    cartMap.remove(productId);
    notifyListeners();
  }
}
