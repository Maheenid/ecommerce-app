class OrderModel {
  String cartId, productId, productTitle, productPrice, productImage;
  int qty;

  OrderModel({
    required this.cartId,
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.productImage,
    required this.qty,
  });
}
