import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:project_9shop/screen/product_details_screen.dart';
import 'package:project_9shop/widgets/cart/counter.dart';

class ProductCard extends StatelessWidget {
  final DocumentSnapshot document;

  const ProductCard({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: (Colors.grey[300])!),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
        child: Row(
          children: [
            Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                      context,
                      screen: ProductDetailsScreen(
                        document: document,
                      ),
                      settings:
                          const RouteSettings(name: ProductDetailsScreen.id),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino);
                },
                child: SizedBox(
                  height: 140,
                  width: 130,
                  child: SizedBox(
                    child: Hero(
                      tag:
                          'SanPham${(document.data() as Map<String, dynamic>)['TenSP'] ?? ''}',
                      child: Image.network((document.data()
                              as Map<String, dynamic>)['hinhanh'] ??
                          ''),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 5),
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (document.data()
                                    as Map<String, dynamic>)['TenDanhMucPhu'] ??
                                '',
                            style: const TextStyle(fontSize: 10),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          SizedBox(
                            width: 200,
                            // take up the remaining width
                            child: Text(
                              (document.data()
                                      as Map<String, dynamic>)['TenSP'] ??
                                  '',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 2,
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 160,
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.grey[200]),
                            child: Text(
                                (document.data()
                                        as Map<String, dynamic>)['DonViSP'] ??
                                    '',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              Text(
                                NumberFormat('#,###,###').format(
                                  (document.data()
                                      as Map<String, dynamic>)['GiaSP'],
                                ),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                              const Text(' VNĐ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 160,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CounterForCard(document: document),
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
    );
  }
}
