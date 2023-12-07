import 'package:flutter/material.dart';

class BuyNowWidget extends StatelessWidget {
  const BuyNowWidget(
      {super.key,
      required this.image,
      required this.title,
      required this.price,
      required this.qty,
      required this.productId,
      required this.cartId});
  final String? image;
  final String? title;
  final String? price;
  final int? qty;
  final String? productId;
  final String? cartId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Column(
        children: [
          Row(
            children: [
              Image.network(
                image!,
                width: 130,
                height: 120,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title!,
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
                      '\$$price',
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
        ],
      ),
    );
  }
}
