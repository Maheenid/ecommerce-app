import 'package:ecommerce_app/firebase_options.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/providers/favorite_provider.dart';
import 'package:ecommerce_app/providers/order_provider.dart';
import 'package:ecommerce_app/providers/product_provider.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/providers/viewedrecently_provider.dart';
import 'package:ecommerce_app/screens/bottom_navigaion_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const EcommerceApp());
}

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (contex) {
          return ProductProvider();
        }),
        ChangeNotifierProvider(create: (contex) {
          return CartProvider();
        }),
        ChangeNotifierProvider(create: (contex) {
          return FavoriteProvider();
        }),
        ChangeNotifierProvider(create: (contex) {
          return ViewedRecentlyProvider();
        }),
        ChangeNotifierProvider(create: (contex) {
          return UserProvider();
        }),
        ChangeNotifierProvider(create: (contex) {
          return OrderProvider();
        }),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: false),
        home: const BottomNavigationScreen(),
      ),
    );
  }
}
