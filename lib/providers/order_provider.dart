import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class OrderProvider extends ChangeNotifier {
  final Map ordertMap = {};

  final usersTdb = FirebaseFirestore.instance.collection('users');

  Future<void> addOrderToFirebase({
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
    final orderId = const Uuid().v4();
    try {
      await usersTdb.doc(users.uid).update({
        'userOrder': FieldValue.arrayUnion([
          {
            'productId': productId,
            'cartId': orderId,
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
    final leng = usersDoc.get('userOrder').length;
    try {
      for (int index = 0; index < leng; index++) {
        await ordertMap.putIfAbsent(
          usersDoc.get('userOrder')[index]['cartId'],
          () => OrderModel(
            productId: usersDoc.get('userOrder')[index]['productId'],
            cartId: usersDoc.get('userOrder')[index]['cartId'],
            qty: usersDoc.get('userOrder')[index]['qty'],
            productTitle: usersDoc.get('userOrder')[index]['productTitle'],
            productPrice: usersDoc.get('userOrder')[index]['productPrice'],
            productImage:
                usersDoc.get('userOrder')[index]['productImage'].toString(),
          ),
        );
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
    notifyListeners();
  }

  Future<void> deletOrderFromFirebase({
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
        'userOrder': FieldValue.arrayRemove([
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

      ordertMap.remove(cartId);
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
}
