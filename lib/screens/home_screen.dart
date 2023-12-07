import 'package:ecommerce_app/data/category_list.dart';
import 'package:ecommerce_app/models/category_model.dart';
import 'package:ecommerce_app/providers/product_provider.dart';
import 'package:ecommerce_app/screens/search_screen.dart';
import 'package:ecommerce_app/widgets/category/category_text_widget.dart';
import 'package:ecommerce_app/widgets/home/card_swiper_widget.dart';
import 'package:ecommerce_app/widgets/home/flash_sale_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<CategoryModel> data = categoryList;
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'Karaj',
              style: TextStyle(
                color: Color.fromARGB(255, 22, 22, 22),
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              'Find anything what you want',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 10),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const SearchScreen(categoryName: ''),
                ),
              );
            },
            icon: const Icon(
              IconlyLight.search,
              color: Colors.black,
              size: 25,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const CardSwiperWidget(),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                itemBuilder: (context, index) => CategoryTextWidget(
                  name: data[index].title,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 25, left: 10),
              child: Text(
                'Flash Sale',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: productProvider.products.length,
                itemBuilder: (context, index) => FlashSaleWidget(
                  productModel: productProvider.products[index],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Most Popular',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: productProvider.products.length,
                itemBuilder: (context, index) => FlashSaleWidget(
                  productModel: productProvider.products[index],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
