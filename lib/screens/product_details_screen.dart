import 'package:ecommerce_app/models/product_model.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/providers/favorite_provider.dart';
import 'package:ecommerce_app/screens/buy_now_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, this.productModel});
  final ProductModel? productModel;
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: true);
    if (productModel == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Details',
          style: TextStyle(
            color: Color.fromARGB(255, 22, 22, 22),
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              favoriteProvider.addFavorteToFirebase(
                  productId: productModel!.productId,
                  productTitle: productModel!.productTitle,
                  productImage: productModel!.productImage,
                  productPrice: productModel!.productPrice,
                  context: context);
            },
            icon: Icon(
              favoriteProvider.isExist(productId: productModel!.productId)
                  ? Icons.favorite
                  : IconlyLight.heart,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Image.network(
                    productModel!.productImage,
                    height: 300,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    productModel!.productTitle,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.clip,
                    maxLines: 3,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    '\$${productModel!.productPrice}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        productModel!.productCategory,
                        style: const TextStyle(
                            fontSize: 18, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Text(
                    productModel!.productDescription,
                    style: const TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black38, width: 1.5),
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (cartProvider.isExist(
                          productId: productModel!.productId)) {
                        return;
                      }
                      cartProvider.addCartToFirebase(
                          productId: productModel!.productId,
                          productPrice: productModel!.productPrice,
                          productTitle: productModel!.productTitle,
                          productImage: productModel!.productImage,
                          qty: 1,
                          context: context);
                    },
                    icon: Icon(
                        cartProvider.isExist(productId: productModel!.productId)
                            ? Icons.check
                            : IconlyLight.bag2),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 22, 22, 22),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 90, vertical: 20)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => BuyNowScreen(
                          cartId: const Uuid().v4(),
                          image: productModel!.productImage,
                          price: productModel!.productPrice,
                          productId: productModel!.productId,
                          qty: 1,
                          title: productModel!.productTitle,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Buy Now',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
