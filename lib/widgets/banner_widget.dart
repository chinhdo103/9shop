import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:project_9shop/services/firebase_service.dart';
import 'package:getwidget/getwidget.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final FirebaseService _service = FirebaseService();
  double scrollPosition = 0;
  final List _bannerImage = [];

  //chuyển silde 3s cho home banner
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    getBanner();
    super.initState();
    startAutoPlay();
  }

  getBanner() {
    //acces document
    return _service.homeBanner.get().then((QuerySnapshot querySnapshot) {
      // ignore: avoid_function_literals_in_foreach_calls
      querySnapshot.docs.forEach((doc) {
        //truy cập và lấy ra tất cả dữ liệu homebanner
        //thêm vào list
        setState(() {
          //add các image từ homeBanner firebase to list _bannerImage
          _bannerImage.add(doc['image']);
        });
      });
    });
  }

  //hàm chuyển silde trong pageview
  void startAutoPlay() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (currentPage < _bannerImage.length - 1) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      // Sử dụng PageController để chuyển đổi trang tự động
      _pageController.animateToPage(currentPage,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              color: Colors.grey.shade200,
              height: 140,
              width: MediaQuery.of(context).size.width,
              child: PageView.builder(
                controller: _pageController, // Sử dụng PageController
                itemCount: _bannerImage.length,
                //index là phần tử hình ảnh trong list
                itemBuilder: (BuildContext context, int index) {
                  return CachedNetworkImage(
                    imageUrl: _bannerImage[index],
                    fit: BoxFit.fill,
                    placeholder: (context, url) => GFShimmer(
                      showShimmerEffect: true,
                      mainColor: Colors.grey.shade500,
                      secondaryColor: Colors.grey.shade300,
                      child: Container(
                        color: Colors.grey.shade300,
                        height: 140,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  );
                },
                onPageChanged: (val) {
                  setState(() {
                    scrollPosition = val.toDouble();
                    currentPage = val; // Cập nhật trang hiện tại silde 5s
                  });
                },
              ),
            ),
          ),
        ),
        //không hiện dots nếu list trống
        _bannerImage.isEmpty
            ? Container()
            : Positioned(
                bottom: 10.0,
                child: DotsIndicatorWidget(
                  scrollPosition: scrollPosition,
                  itemList: _bannerImage,
                ),
              )
      ],
    );
  }
}

class DotsIndicatorWidget extends StatelessWidget {
  const DotsIndicatorWidget({
    super.key,
    required this.scrollPosition,
    required this.itemList,
  });

  final double scrollPosition;
  final List itemList;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: DotsIndicator(
            position: scrollPosition,
            dotsCount: itemList.length,
            decorator: DotsDecorator(
              activeColor: const Color(0xFFF4F9CD),
              spacing: const EdgeInsets.all(2),
              size: const Size.square(6),
              activeSize: const Size(12, 6),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
