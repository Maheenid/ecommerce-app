import 'package:ecommerce_app/models/category_model.dart';
import 'package:ecommerce_app/data/category_list.dart';
import 'package:ecommerce_app/widgets/category/category_item_widget.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Category',
          style: TextStyle(
            color: Color.fromARGB(255, 22, 22, 22),
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (ctx, index) => CategoryItemWidget(
            id: data[index].id,
            title: data[index].title,
            image: data[index].image),
      ),
    );
  }
}

List<CategoryModel> data = categoryList;
