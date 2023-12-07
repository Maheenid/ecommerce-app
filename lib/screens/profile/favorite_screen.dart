import 'package:ecommerce_app/providers/favorite_provider.dart';
import 'package:ecommerce_app/widgets/favorite_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    if (favoriteProvider.favoriteMap.isEmpty) {
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
            'Favorite',
            style: TextStyle(
              color: Color.fromARGB(255, 22, 22, 22),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        body: const Center(
          child: Text('No favorite found'),
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
          'Favorite',
          style: TextStyle(
            color: Color.fromARGB(255, 22, 22, 22),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ListView.builder(
          itemCount: favoriteProvider.favoriteMap.length,
          itemBuilder: (ctx, index) => FavoriteItemWidget(
            favoriteModel: favoriteProvider.favoriteMap.values.toList()[index],
          ),
        ),
      ),
    );
  }
}
