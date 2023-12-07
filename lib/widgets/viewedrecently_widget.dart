import 'package:ecommerce_app/models/cart_model.dart';
import 'package:flutter/material.dart';

class ViewedRecentlyWidget extends StatelessWidget {
  const ViewedRecentlyWidget({super.key, required this.favoriteModel});
  final CartModel favoriteModel;
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Image.network(
            favoriteModel.productImage,
            width: 130,
            height: 110,
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  favoriteModel.productTitle,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '\$${favoriteModel.productPrice}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
