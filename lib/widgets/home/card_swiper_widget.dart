import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class CardSwiperWidget extends StatelessWidget {
  const CardSwiperWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List bannerImages = [
      'assets/banner2.jpg',
      'assets/banner1.jpg',
    ];
    return SizedBox(
      height: 170,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Swiper(
            autoplay: true,
            itemBuilder: (BuildContext context, int index) {
              return Image.asset(
                bannerImages[index],
                fit: BoxFit.fill,
              );
            },
            itemCount: bannerImages.length,
            pagination: const SwiperPagination(),
          ),
        ),
      ),
    );
  }
}
