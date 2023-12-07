import 'package:ecommerce_app/models/user_model.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/providers/favorite_provider.dart';
import 'package:ecommerce_app/providers/order_provider.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/screens/auth/login_screen.dart';
import 'package:ecommerce_app/screens/bottom_navigaion_screen.dart';
import 'package:ecommerce_app/screens/profile/favorite_screen.dart';
import 'package:ecommerce_app/screens/profile/location_scren.dart';
import 'package:ecommerce_app/screens/profile/order_screen.dart';
import 'package:ecommerce_app/screens/profile/viewed_recently_screen.dart';
import 'package:ecommerce_app/widgets/custom_listtile_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  bool isloading = false;
  final firebase = FirebaseAuth.instance;
  Future fetchUserInfo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (context.mounted) {
      try {
        setState(() {
          isloading = true;
        });
        userModel = await userProvider.fetchUserInfo(context);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
            ),
          );
        }
      } finally {
        setState(() {
          isloading = false;
        });
      }
    }
  }

  @override
  void initState() {
    fetchUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    OrderProvider orderProvider =
        Provider.of<OrderProvider>(context, listen: false);
    FavoriteProvider favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);
    if (isloading && userModel == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color.fromARGB(255, 22, 22, 22),
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: Column(
        children: [
          const Spacer(
            flex: 1,
          ),
          Center(
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: user == null
                      ? const AssetImage(
                          'assets/noperson.jpg',
                        )
                      : NetworkImage(userModel!.userImage) as ImageProvider,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            user == null ? 'username' : userModel!.userName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            user == null ? 'example@gmail.com' : userModel!.userEmail,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const Spacer(
            flex: 1,
          ),
          CustomListTileWidget(
            title: 'All Orders',
            icon: IconlyLight.bag,
            ontap: () {
              if (user != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const OrderScreen(),
                  ),
                );
              } else if (user == null) {
                showDialog(
                  context: context,
                  builder: (ctx) => const AlertDialog(
                    title: Text('You must login'),
                  ),
                );
              }
            },
          ),
          CustomListTileWidget(
            title: 'Favorite',
            icon: Icons.favorite,
            ontap: () {
              if (user != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const FavoriteScreen(),
                  ),
                );
              } else if (user == null) {
                showDialog(
                  context: context,
                  builder: (ctx) => const AlertDialog(
                    title: Text('You must login'),
                  ),
                );
              }
            },
          ),
          CustomListTileWidget(
            title: 'Viewed recently',
            icon: Icons.timelapse,
            ontap: () {
              if (user != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const ViewedRecentlyScreen(),
                  ),
                );
              } else if (user == null) {
                showDialog(
                  context: context,
                  builder: (ctx) => const AlertDialog(
                    title: Text('You must login'),
                  ),
                );
              }
            },
          ),
          CustomListTileWidget(
            title: 'Location',
            icon: Icons.location_on,
            ontap: () {
              if (user != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const LocationScreen(),
                  ),
                );
              } else if (user == null) {
                showDialog(
                  context: context,
                  builder: (ctx) => const AlertDialog(
                    title: Text('You must login'),
                  ),
                );
              }
            },
          ),
          CustomListTileWidget(
            title: user == null ? 'Login' : 'Logout',
            icon: user == null ? IconlyLight.logout : IconlyLight.login,
            ontap: () {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: Text(user == null
                          ? 'Do you want to login?'
                          : 'Do you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'No',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            if (user == null) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (ctx) => const LoginScreen(),
                                ),
                              );
                            } else if (user != null) {
                              await firebase.signOut();
                              cartProvider.cartMap.clear();
                              favoriteProvider.favoriteMap.clear();
                              orderProvider.ordertMap.clear();
                              if (context.mounted) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (ctx) =>
                                        const BottomNavigationScreen(),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text(
                            'Yes',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    );
                  });
            },
          ),
          const Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }
}
