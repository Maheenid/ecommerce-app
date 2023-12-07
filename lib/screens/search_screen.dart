import 'package:ecommerce_app/models/product_model.dart';
import 'package:ecommerce_app/providers/product_provider.dart';
import 'package:ecommerce_app/widgets/home/most_popular_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.categoryName});
  final String categoryName;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _textController = TextEditingController();
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  List<ProductModel> searchList = [];
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    List<ProductModel> categoryList =
        productProvider.gitCategoryList(category: widget.categoryName);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Search',
          style: TextStyle(
            color: Color.fromARGB(255, 22, 22, 22),
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _textController.clear();
                    });
                  },
                  child: const Icon(Icons.clear),
                ),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onSubmitted: (value) {
                setState(() {
                  searchList = productProvider.gitSearchList(
                      searchText: _textController.text,
                      listModel: categoryList);
                });
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          if (_textController.text.isNotEmpty && searchList.isEmpty) ...[
            const Center(
              child: Text("No item found"),
            ),
          ],
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: _textController.text.isNotEmpty
                  ? searchList.length
                  : categoryList.length,
              itemBuilder: (context, index) => MostPopularWidget(
                productModel: _textController.text.isNotEmpty
                    ? searchList[index]
                    : categoryList[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
