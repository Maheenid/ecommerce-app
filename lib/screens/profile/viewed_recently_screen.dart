import 'package:ecommerce_app/providers/viewedrecently_provider.dart';
import 'package:ecommerce_app/widgets/viewedrecently_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class ViewedRecentlyScreen extends StatelessWidget {
  const ViewedRecentlyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewedrecentlyProvider = Provider.of<ViewedRecentlyProvider>(context);
    if (viewedrecentlyProvider.viewedrecentlyMap.isEmpty) {
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
            'Viewed Recently',
            style: TextStyle(
              color: Color.fromARGB(255, 22, 22, 22),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        body: const Center(
          child: Text('No Viewed Recently found'),
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
          'Viewed Recently',
          style: TextStyle(
            color: Color.fromARGB(255, 22, 22, 22),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              viewedrecentlyProvider.clearviewedrecently();
            },
            icon: const Icon(
              IconlyLight.delete,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ListView.builder(
          itemCount: viewedrecentlyProvider.viewedrecentlyMap.length,
          itemBuilder: (ctx, index) => ViewedRecentlyWidget(
            favoriteModel:
                viewedrecentlyProvider.viewedrecentlyMap.values.toList()[index],
          ),
        ),
      ),
    );
  }
}
