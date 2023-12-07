import 'package:ecommerce_app/models/order_model.dart';
import 'package:ecommerce_app/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderWidget extends StatelessWidget {
  const OrderWidget({super.key, required this.ordermodel});
  final OrderModel ordermodel;
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Column(
        children: [
          Row(
            children: [
              Image.network(
                ordermodel.productImage,
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
                      ordermodel.productTitle,
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
                      '\$${ordermodel.productPrice}',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Qty',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          ordermodel.qty.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        
                        const Spacer(
                          flex: 1,
                        ),
                        IconButton(
                          padding: const EdgeInsets.only(right: 20),
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            orderProvider.deletOrderFromFirebase(
                                productId: ordermodel.productId,
                                cartId: ordermodel.cartId,
                                productTitle: ordermodel.productTitle,
                                productImage: ordermodel.productImage,
                                productPrice: ordermodel.productPrice,
                                qty: ordermodel.qty,
                                context: context);
                          },
                          icon: const Icon(
                            Icons.delete_outline_outlined,
                            size: 20,
                          ),
                        ),
                      ],
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
