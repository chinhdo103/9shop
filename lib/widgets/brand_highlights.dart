// import 'package:dots_indicator/dots_indicator.dart';
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:project_9shop/services/firebase_service.dart';
import 'package:project_9shop/widgets/banner_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class BrandHighLights extends StatefulWidget {
  const BrandHighLights({super.key});

  @override
  State<BrandHighLights> createState() => _BrandHighLightsState();
}

class _BrandHighLightsState extends State<BrandHighLights> {
  // ignore:  prefer_final_fields
  double _scrollPosition = 0;
  final FirebaseService _service = FirebaseService();
  final List _brandAds = [];

  //chuyển silde 3s cho brand
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    getBrandAd();
    super.initState();
    startAutoPlay();
  }

  getBrandAd() {
    //acces document
    return _service.brandAd.get().then((QuerySnapshot querySnapshot) {
      // ignore: avoid_function_literals_in_foreach_calls
      querySnapshot.docs.forEach((doc) {
        //truy cập và lấy ra tất cả dữ liệu homebanner
        //thêm vào list
        setState(() {
          //add các image từ homeBanner firebase to list _bannerImage
          _brandAds.add(doc);
        });
      });
    });
  }

  void startAutoPlay() {
    Timer.periodic(const Duration(seconds: 60), (timer) {
      if (currentPage < _brandAds.length - 1) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      _pageController.animateToPage(currentPage,
          duration: const Duration(milliseconds: 20), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F9CD),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Sản Phẩm Nổi Bật',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: Colors.blue.shade900,
                    fontSize: 20),
              ),
            ),
          ),
          Container(
            height: 300,
            width: MediaQuery.of(context).size.width,
            color: const Color(0xFFF4F9CD),
            child: PageView.builder(
              controller: _pageController,
              itemCount: _brandAds.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    //tren cung`
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 4, 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                height: 150,
                                color: Colors.black,
                                child: YoutubePlayer(
                                  controller: YoutubePlayerController(
                                    initialVideoId: _brandAds[index]['youtube'],
                                    flags: const YoutubePlayerFlags(
                                      forceHD: true,
                                      captionLanguage: '',
                                      mute: true,
                                      loop: true,
                                      hideThumbnail: true,
                                      hideControls: true,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              //duoi - trai
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 4, 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Container(
                                      height: 100,
                                      color: Colors.red,
                                      child: CachedNetworkImage(
                                        imageUrl: _brandAds[index]['image1'],
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) =>
                                            GFShimmer(
                                          child: Container(
                                            height: 50,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              //duoi - phai
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 0, 4, 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Container(
                                      height: 100,
                                      color: Colors.red,
                                      child: CachedNetworkImage(
                                        imageUrl: _brandAds[index]['image2'],
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) =>
                                            GFShimmer(
                                          child: Container(
                                            height: 20,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    //phai - ngoai cung
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 8, 40),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            height: 260,
                            color: Colors.blue,
                            child: CachedNetworkImage(
                              imageUrl: _brandAds[index]['image3'],
                              fit: BoxFit.fill,
                              placeholder: (context, url) => GFShimmer(
                                child: Container(
                                  height: 50,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
              onPageChanged: (val) {
                setState(() {
                  currentPage = val; // Cập nhật trang hiện tại silde 5s
                  _scrollPosition = val.toDouble();
                });
              },
            ),
          ),
          _brandAds.isEmpty
              ? Container()
              : DotsIndicator(
                  position: _scrollPosition,
                  dotsCount: _brandAds.length,
                  decorator: DotsDecorator(
                    activeColor: Colors.blue.shade900,
                    color: Colors.black,
                    spacing: const EdgeInsets.all(2),
                    size: const Size.square(6),
                    activeSize: const Size(12, 6),
                    activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
