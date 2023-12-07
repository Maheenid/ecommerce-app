import 'package:ecommerce_app/models/cart_model.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatefulWidget {
  const CartItemWidget({
    super.key,
    required this.cartModel,
  });
  final CartModel? cartModel;

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  int _itemNumber = 1;
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    if (widget.cartModel == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Column(
        children: [
          Row(
            children: [
              Image.network(
                widget.cartModel!.productImage,
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
                      widget.cartModel!.productTitle,
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
                      '\$${widget.cartModel!.productPrice}',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        IconButton(
                          padding: const EdgeInsets.only(right: 10),
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            if (_itemNumber == 1) {
                              return;
                            } else if (_itemNumber < 1) {
                              return;
                            } else {
                              _itemNumber--;
                              cartProvider.changeQuantity(
                                  productId: widget.cartModel!.productId,
                                  title: widget.cartModel!.productTitle,
                                  image: widget.cartModel!.productImage,
                                  price: widget.cartModel!.productPrice,
                                  qty: _itemNumber);
                            }
                          },
                          icon: Icon(
                            color: Colors.grey.shade700,
                            Icons.remove,
                            size: 15,
                          ),
                        ),
                        Text(
                          '${widget.cartModel!.quantity}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        IconButton(
                          padding: const EdgeInsets.only(left: 20),
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            _itemNumber++;
                            cartProvider.changeQuantity(
                                productId: widget.cartModel!.productId,
                                title: widget.cartModel!.productTitle,
                                image: widget.cartModel!.productImage,
                                price: widget.cartModel!.productPrice,
                                qty: _itemNumber);
                          },
                          icon: Icon(
                            color: Colors.grey.shade700,
                            Icons.add,
                            size: 15,
                          ),
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        IconButton(
                          padding: const EdgeInsets.only(right: 20),
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            cartProvider.removeCartItemFromFirebase(
                                productId: widget.cartModel!.productId,
                                cartId: widget.cartModel!.cartId,
                                productTitle: widget.cartModel!.productTitle,
                                productImage: widget.cartModel!.productImage,
                                productPrice: widget.cartModel!.productPrice,
                                qty: widget.cartModel!.quantity,
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
