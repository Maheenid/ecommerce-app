import 'package:ecommerce_app/models/favorite_model.dart';
import 'package:ecommerce_app/providers/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class FavoriteItemWidget extends StatelessWidget {
  const FavoriteItemWidget({super.key, required this.favoriteModel});
  final FavoriteModel favoriteModel;
  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Image.network(
              favoriteModel.productImage,
              width: 130,
              height: 110,
              fit: BoxFit.cover,
            ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      padding: const EdgeInsets.only(right: 15),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        favoriteProvider.removeFavoriteItemFromFirebase(
                            productId: favoriteModel.productId,
                            productTitle: favoriteModel.productTitle,
                            productImage: favoriteModel.productImage,
                            productPrice: favoriteModel.productPrice,
                            context: context);
                      },
                      icon: Icon(
                        favoriteProvider.isExist(
                                productId: favoriteModel.productId)
                            ? Icons.favorite
                            : IconlyLight.heart,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
