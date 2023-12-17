import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_9shop/provider/coupon_provider.dart';
import 'package:provider/provider.dart';

class CouponAllScreen extends StatefulWidget {
  static const String id = 'coupon-all-screen';

  const CouponAllScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CouponAllScreenState createState() => _CouponAllScreenState();
}

class _CouponAllScreenState extends State<CouponAllScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<CouponProvider>(context, listen: false).getAllCoupons();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    var _couponProvider = Provider.of<CouponProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Các mã giảm giá của cửa hàng'),
      ),
      body: _couponProvider.availableCoupons.isEmpty
          ? const Center(
              child: Text('Không có coupon nào có sẵn.'),
            )
          : ListView.builder(
              itemCount: _couponProvider.availableCoupons.length,
              itemBuilder: (context, index) {
                var couponDetails = _couponProvider.availableCoupons[index];
                DateTime expirationDate =
                    (couponDetails['ngayhethan'] as Timestamp).toDate();
                bool isExpired = _couponProvider.isCouponExpired(couponDetails);

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DottedBorder(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: isExpired
                                    ? Colors.grey
                                    : Colors.greenAccent.withOpacity(.4),
                              ),
                              height: 130,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      couponDetails['tengiamgia'] ??
                                          'Default Text or Empty String',
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey[800],
                                  ),
                                  Text(
                                    'Phiếu giảm giá ${couponDetails['%giamgia']}%',
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    couponDetails['motagiamgia'] ??
                                        'Default Text or Empty String',
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Hết hạn vào ${DateFormat('dd MMMM y', 'vi').format(expirationDate)}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  isExpired
                                      ? const Text(
                                          'Mã giảm giá đã hết hạn',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
