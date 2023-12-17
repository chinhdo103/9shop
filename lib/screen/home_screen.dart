import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:project_9shop/models/products_model.dart';
import 'package:project_9shop/provider/auth_provider.dart';
import 'package:project_9shop/provider/location_provider.dart';
import 'package:project_9shop/screen/map_screen.dart';
import 'package:project_9shop/screen/product_details_screen.dart';
import 'package:project_9shop/widgets/banner_widget.dart';
import 'package:project_9shop/widgets/brand_highlights.dart';
import 'package:project_9shop/widgets/cart/counter.dart';
import 'package:project_9shop/widgets/products/best_selling_product.dart';
import 'package:project_9shop/widgets/products/featured_product.dart';
import 'package:project_9shop/widgets/products/recently_added_product.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static List<Products> products = [];
  String? offer;
  String _location = '';
  bool _loading = false;
  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  getPrefs() async {
    FirebaseFirestore.instance
        .collection('SanPham')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          products.add(Products(
              danhmuc: doc['TenDanhMuc'],
              giaSP: doc['GiaSP'],
              hinhanh: doc['hinhanh'],
              tenSP: doc['TenSP'],
              danhmucchinh: doc['DanhMucChinh'],
              danhmucphu: doc['TenDanhMucPhu'],
              documnet: doc));
        });
      });
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? location = prefs.getString('sonha');
    setState(() {
      _location = location ?? 'Địa chỉ chưa được cập nhật';
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);

    return Scaffold(
        backgroundColor: Colors.blue.shade900,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: AppBar(
            backgroundColor: Colors.blue.shade900,
            elevation: 0,
            centerTitle: true,
            title: TextButton(
              onPressed: () {
                setState(() {
                  _loading = true;
                });
                locationData.getCurrentPostion().then((value) {
                  setState(() {
                    _loading = false;
                  });
                  if (value != null) {
                    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                        context,
                        screen: const MapScreen(),
                        settings: const RouteSettings(name: MapScreen.id),
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino);
                  } else {
                    setState(() {
                      _loading = false;
                    });
                    Text('Không cho phép truy cập');
                  }
                });
              },
              child: Flexible(
                child: Text(
                  _location,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: SearchPage<Products>(
                        onQueryUpdate: print,
                        items: products,
                        searchLabel: 'Tìm kiếm sản phẩm',
                        suggestion: const Center(
                          child: Text(
                              'Lọc sản phẩm theo tên,danh mục và giá tiền'),
                        ),
                        failure: const Center(
                          child: Text('Không có sản phẩm được tìm thấy :('),
                        ),
                        filter: (products) => [
                          products.danhmuc,
                          products.danhmucchinh,
                          products.danhmucphu,
                          products.hinhanh,
                          products.tenSP,
                          products.giaSP.toString()
                        ],
                        sort: (a, b) => a.compareTo(b),
                        builder: (products) => Container(
                          height: 180,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                  width: 1, color: (Colors.grey[300])!),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 8, left: 10, right: 10),
                            child: Row(
                              children: [
                                Material(
                                  elevation: 5,
                                  borderRadius: BorderRadius.circular(10),
                                  child: InkWell(
                                    onTap: () {
                                      PersistentNavBarNavigator
                                          .pushNewScreenWithRouteSettings(
                                              context,
                                              screen: ProductDetailsScreen(
                                                document: products.documnet,
                                              ),
                                              settings: const RouteSettings(
                                                  name:
                                                      ProductDetailsScreen.id),
                                              withNavBar: false,
                                              pageTransitionAnimation:
                                                  PageTransitionAnimation
                                                      .cupertino);
                                    },
                                    child: SizedBox(
                                      height: 140,
                                      width: 130,
                                      child: SizedBox(
                                        child: Hero(
                                          tag:
                                              'SanPham${(products.documnet.data() as Map<String, dynamic>)['TenSP'] ?? ''}',
                                          child: Image.network(
                                              (products.documnet.data() as Map<
                                                      String,
                                                      dynamic>)['hinhanh'] ??
                                                  ''),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8.0, top: 5),
                                  child: SizedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                (products.documnet.data()
                                                            as Map<String,
                                                                dynamic>)[
                                                        'TenDanhMucPhu'] ??
                                                    '',
                                                style: const TextStyle(
                                                    fontSize: 10),
                                              ),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              SizedBox(
                                                width: 200,
                                                // take up the remaining width
                                                child: Text(
                                                  (products.documnet.data()
                                                              as Map<String,
                                                                  dynamic>)[
                                                          'TenSP'] ??
                                                      '',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  maxLines: 2,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    160,
                                                padding: const EdgeInsets.only(
                                                    top: 10,
                                                    bottom: 10,
                                                    left: 6),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    color: Colors.grey[200]),
                                                child: const Text('1 Cái',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    NumberFormat('#,###,###')
                                                        .format(
                                                      (products.documnet.data()
                                                              as Map<String,
                                                                  dynamic>)[
                                                          'GiaSP'],
                                                    ),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red),
                                                  ),
                                                  const Text(' VNĐ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 10))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  160,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  CounterForCard(
                                                      document:
                                                          products.documnet),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(IconlyLight.search))
            ],
          ),
        ),
        //listview thực hiện việc scroll màn hình với nhóm các widgets
        body: ListView(
          shrinkWrap: true,
          children: const [
            SearchWidget(),
            SizedBox(height: 10),
            BannerWidget(),
            BrandHighLights(),
            // CategoryWidget(),
            RecentlyAddedProduct(),
            FeaturedProducts(),
            BestSellingProduct(),

            //một số sản phẩm sẽ hiển thị sau đây
          ],
        ));
  }
}

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SizedBox(
        //   height: 64,
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Column(
        //       children: [
        //         // ClipRRect(
        //         //   borderRadius: BorderRadius.circular(4),
        //         //   child: const TextField(
        //         //     decoration: InputDecoration(
        //         //         filled: true,
        //         //         fillColor: Colors.white,
        //         //         border: InputBorder.none,
        //         //         contentPadding: EdgeInsets.fromLTRB(8, 15, 8, 0),
        //         //         hintText: 'Tìm kiếm sản phẩm',
        //         //         hintStyle: TextStyle(color: Colors.grey),
        //         //         prefixIcon: Icon(
        //         //           Icons.search,
        //         //           size: 20,
        //         //           color: Colors.grey,
        //         //         )),
        //         //   ),
        //         // )
        //       ],
        //     ),
        //   ),
        // ),
        SizedBox(
          height: 20,
          width: MediaQuery.of(context).size.width,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Icon(
                    IconlyLight.infoSquare,
                    size: 12,
                    color: Colors.white,
                  ),
                  Text(
                    '100% Chính Hãng',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    IconlyLight.infoSquare,
                    size: 12,
                    color: Colors.white,
                  ),
                  Text(
                    'Hoàn Trả Trong 48H',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    IconlyLight.infoSquare,
                    size: 12,
                    color: Colors.white,
                  ),
                  Text(
                    'Giao Hàng Miễn Phí',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
