import 'package:cloud_firestore/cloud_firestore.dart';

class AddOrder {
  addOrder({
    required uid,
    required orderTitle,
    required orderImage,
    required orderPrice,
    required qty,
  }) async {
    await FirebaseFirestore.instance.collection("allOrders").doc(uid).set({
      'orderId': uid,
      'orderTitle': orderTitle,
      'orderImage': orderImage,
      'orderPrice': orderPrice,
      'qty': qty,
    });
  }
}
