import 'package:ecommerce_app/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ViewedRecentlyProvider extends ChangeNotifier {
  Map<String, CartModel> viewedrecentlyMap = {};

  void addToViewedRecentlyProvider({
    required String productId,
    required String title,
    required String image,
    required String price,
  }) {
    viewedrecentlyMap.putIfAbsent(
      productId,
      () => CartModel(
        productTitle: title,
        productImage: image,
        productPrice: price,
        cartId: const Uuid().v4(),
        productId: productId,
        quantity: 1,
      ),
    );
    notifyListeners();
  }

  void clearviewedrecently() {
    viewedrecentlyMap.clear();
    notifyListeners();
  }

  void removeviewedrecently({required String productId}) {
    viewedrecentlyMap.remove(productId);
    notifyListeners();
  }
}
