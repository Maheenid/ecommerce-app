import 'package:ecommerce_app/providers/order_provider.dart';
import 'package:ecommerce_app/widgets/order_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  fetchOrderFromFirebase() async {
    final fetchOrder = Provider.of<OrderProvider>(context, listen: false);
    await fetchOrder.fetchDataFromFirebase(context: context);
  }

  @override
  void initState() {
    super.initState();
    fetchOrderFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    if (orderProvider.ordertMap.values.isEmpty) {
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
            'All Orders',
            style: TextStyle(
              color: Color.fromARGB(255, 22, 22, 22),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        body: const Center(
          child: Text('No order has been added yet'),
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
          'All Orders',
          style: TextStyle(
            color: Color.fromARGB(255, 22, 22, 22),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: orderProvider.ordertMap.length,
        itemBuilder: (context, index) => OrderWidget(
          ordermodel: orderProvider.ordertMap.values.toList()[index],
        ),
      ),
    );
  }
}
