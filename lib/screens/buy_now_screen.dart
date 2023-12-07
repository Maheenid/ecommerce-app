import 'package:ecommerce_app/providers/order_provider.dart';
import 'package:ecommerce_app/services/add_order_service.dart';
import 'package:ecommerce_app/widgets/buy_now_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class BuyNowScreen extends StatelessWidget {
  const BuyNowScreen(
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
    final orderprovider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            'Checkout',
            style: TextStyle(
              color: Color.fromARGB(255, 22, 22, 22),
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: ListView(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Address',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.edit)
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Los Angeles',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Huntington Beach, CA 92646',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            const Text(
              'Items',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                border: Border.all(width: 0.6, color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
              child: BuyNowWidget(
                cartId: cartId,
                image: image,
                price: price,
                productId: productId,
                qty: qty,
                title: title,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'payment Method ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Image.asset(
                'assets/mastercard.png',
                width: 40,
              ),
              title: const Text('MasterCard'),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
            ),
            ListTile(
              leading: Image.asset(
                'assets/visa.png',
                width: 40,
              ),
              title: const Text('Visa'),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
            ),
            ListTile(
              leading: Image.asset(
                'assets/paypal.png',
                width: 30,
              ),
              title: const Text('Paypal'),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            Row(
              children: [
                const Spacer(
                  flex: 1,
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 22, 22, 22),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 100, vertical: 20),
                    ),
                    onPressed: () async {
                      orderprovider.addOrderToFirebase(
                        productId: productId,
                        productTitle: title,
                        productImage: image,
                        productPrice: price,
                        qty: qty!,
                        context: context,
                      );

                      final uid = const Uuid().v4();

                      AddOrder().addOrder(
                          uid: uid,
                          orderTitle: title,
                          orderImage: image,
                          orderPrice: price,
                          qty: qty);

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Your order has been completed successfully'),
                        ),
                      );
                    },
                    child: Text(
                      'pay - \$$price',
                      style: TextStyle(fontSize: 18, color: Colors.grey[400]),
                    ),
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
