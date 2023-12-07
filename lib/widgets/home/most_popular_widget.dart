import 'package:ecommerce_app/models/product_model.dart';
import 'package:ecommerce_app/providers/viewedrecently_provider.dart';
import 'package:ecommerce_app/screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MostPopularWidget extends StatelessWidget {
  const MostPopularWidget({super.key, this.productModel});
  final ProductModel? productModel;
  @override
  Widget build(BuildContext context) {
    final viewedRecentlyProvider = Provider.of<ViewedRecentlyProvider>(context);

    if (productModel == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: CircularProgressIndicator(),
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        viewedRecentlyProvider.addToViewedRecentlyProvider(
            productId: productModel!.productId,
            title: productModel!.productTitle,
            image: productModel!.productImage,
            price: productModel!.productPrice);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => ProductDetailsScreen(productModel: productModel),
          ),
        );
      },
      child: Column(
        children: [
          Image.network(
            productModel!.productImage,
            width: 150,
            height: 140,
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 5, top: 5),
            child: SizedBox(
              width: 130,
              child: Text(
                productModel!.productTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  fontSize: 15,
                ),
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
          Text(
            '\$${productModel!.productPrice}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
