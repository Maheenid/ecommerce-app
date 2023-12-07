import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/providers/product_provider.dart';
import 'package:ecommerce_app/screens/cart_screen.dart';
import 'package:ecommerce_app/screens/category_screen.dart';
import 'package:ecommerce_app/screens/home_screen.dart';
import 'package:ecommerce_app/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int currentIndex = 0;
  List<Widget> widgetsList = const [
    HomeScreen(),
    CategoryScreen(),
    CartScreen(),
    ProfileScreen(),
  ];
  Future<void> fecthData() async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    Future.wait({productProvider.fetchData()});
    Future.wait({cartProvider.fetchDataFromFirebase(context: context)});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fecthData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetsList[currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromARGB(255, 22, 22, 22),
          ),
          padding: const EdgeInsets.only(left: 10, right: 10),
          width: 200,
          height: 90,
          child: GNav(
            selectedIndex: currentIndex,
            onTabChange: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            padding: const EdgeInsets.all(15),
            gap: 8,
            tabs: const [
              GButton(
                text: 'Home',
                icon: IconlyLight.home,
              ),
              GButton(
                text: 'Category',
                icon: IconlyLight.category,
              ),
              GButton(
                text: 'Cart',
                icon: IconlyLight.bag2,
              ),
              GButton(
                text: 'Profile',
                icon: IconlyLight.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
