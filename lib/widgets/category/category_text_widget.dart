import 'package:ecommerce_app/screens/search_screen.dart';
import 'package:flutter/material.dart';

class CategoryTextWidget extends StatelessWidget {
  const CategoryTextWidget({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchScreen(categoryName: name),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          name,
          style: const TextStyle(
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
