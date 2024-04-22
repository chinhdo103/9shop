import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:project_9shop/provider/cart_provider.dart';
import 'package:project_9shop/provider/coupon_provider.dart';
import 'package:project_9shop/provider/location_provider.dart';
// ignore: library_prefixes
import 'package:project_9shop/provider/auth_provider.dart' as authPRVD;
import 'package:project_9shop/screen/map_screen.dart';
import 'package:project_9shop/screen/profile_screen.dart';
import 'package:project_9shop/screen/success_cod.dart';
import 'package:project_9shop/screen/success_screen.dart';
import 'package:project_9shop/services/cart_service.dart';
import 'package:project_9shop/services/firebase_service.dart';
import 'package:project_9shop/services/order_services.dart';
// ignore: library_prefixes, depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:project_9shop/widgets/cart/cart_list.dart';
import 'package:project_9shop/widgets/cart/cod_toggle.dart';
import 'package:project_9shop/widgets/cart/coupon_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  static const String id = 'cart-screen';
  final DocumentSnapshot? document;
  const CartScreen({Key? key, required this.document}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DocumentSnapshot? doc;
  String _location = '';
  final FirebaseService _userServices = FirebaseService();
  final OrderServices _orderServices = OrderServices();
  final CartServices _cartServices = CartServices();
  User? user = FirebaseAuth.instance.currentUser;
  var textStyle = const TextStyle(color: Colors.grey);
  double discount = 0;
  double vat = 0;
  double _tongdon = 0;
  int deliveryFee = 50000;
  bool _loading = false;

  final bool _checkingUser = false;

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? location = prefs.getString('diachi');
    setState(() {
      _location = location ?? 'Địa chỉ chưa được cập nhật';
    });
  }

  Map<String, dynamic>? paymentIntent;

  Future<Map<String, dynamic>> createPaymentIntent(double amount) async {
    try {
      Map<String, dynamic> body = {
        "amount": amount.toInt().toString(),
        "currency": "VND",
      };
      http.Response response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            "Authorization":
                "Bearer sk_test_51OOBpeJHlO4ZZ6TK9ERtH0VLAbke6QalGwURRBp8ZWz8QDboKFQub57NhKt5fKBKOe8Lo4cSP4Wx9BgmP8C0cBkQ00jmrO1Yfp",
            "Content-type": "application/x-www-form-urlencoded",
          });
      return json.decode(response.body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    var _cartProvider = Provider.of<CartProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);
    var userDetails = Provider.of<authPRVD.AuthProvider>(context);
    // ignore: no_leading_underscores_for_local_identifiers
    var _coupon = Provider.of<CouponProvider>(context);
    userDetails.getUserDetails().then((value) {
      double subTotal = _cartProvider.subTotal;
      double discountRate = _coupon.discountRate / 100;
      setState(() {
        vat = subTotal * 0.08;
        _tongdon = _cartProvider.subTotal + deliveryFee + vat;
        discount = _tongdon * discountRate;
      });
    });
    // ignore: no_leading_underscores_for_local_identifiers
    var _payable = (_cartProvider.subTotal + deliveryFee + vat) - discount;
    // ignore: no_leading_underscores_for_local_identifiers
    var _discounted = discount;
    var userDetailsData = userDetails.snapshot?.data() as Map<String, dynamic>?;
    displayPaymentSheet() async {
      try {
        // Display the PaymentSheet
        await Stripe.instance.presentPaymentSheet();
        _saveOrder(_cartProvider, _payable, _coupon, userDetailsData);
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SuccessScreen()),
          (route) => false,
        );
      } catch (e) {
        throw Exception(e.toString());
      }
    }

    void makePayment() async {
      try {
        paymentIntent = await createPaymentIntent(_payable);
        var gpay = const PaymentSheetGooglePay(
            merchantCountryCode: "US", currencyCode: "US", testEnv: true);

        // Initialize the PaymentSheet before displaying it
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent!["client_secret"],
            style: ThemeMode.dark,
            merchantDisplayName: "9Shop",
            googlePay: gpay,
          ),
        );

        // Display the PaymentSheet
        await displayPaymentSheet();
      } catch (e) {
        throw Exception(e.toString());
      }
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[200],
        bottomSheet: Container(
          height: 140,
          color: Colors.blueGrey[900],
          child: Column(
            children: [
              Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Giao hàng tới địa chỉ: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _loading = true;
                                });
                                locationData.getCurrentPostion().then((value) {
                                  setState(() {
                                    _loading = false;
                                  });
                                  // ignore: unnecessary_null_comparison
                                  if (value != null) {
                                    PersistentNavBarNavigator
                                        .pushNewScreenWithRouteSettings(context,
                                            screen: const MapScreen(),
                                            withNavBar: false,
                                            settings: const RouteSettings(
                                                name: MapScreen.id),
                                            pageTransitionAnimation:
                                                PageTransitionAnimation
                                                    .cupertino);
                                  } else {
                                    const Text('Không cho phép truy cập');
                                  }
                                });
                              },
                              child: _loading
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      'Thay đổi',
                                      style: TextStyle(color: Colors.red),
                                    ),
                            )
                          ],
                        ),
                        Text(
                          userDetailsData?['Ho'] != null
                              ? '${userDetailsData?['Ho']} ${userDetailsData?['Ten']} : $_location'
                              : _location,
                          maxLines: 3,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  )),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            NumberFormat('#,###,###').format(_payable),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'Giá sau thuế',
                            style: TextStyle(color: Colors.green, fontSize: 10),
                          )
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          EasyLoading.show(status: 'Xin vui lòng đợi...');
                          _userServices.getUserById(user!.uid).then((value) {
                            if ((value.data() as Map<String, dynamic>)['Ho'] ==
                                null) {
                              EasyLoading.dismiss();
                              EasyLoading.showToast(
                                  'Bạn phải cập nhật thông tin và vị trí trước khi đặt đơn hàng');
                              PersistentNavBarNavigator
                                  .pushNewScreenWithRouteSettings(context,
                                      screen: const ProfileScreen(),
                                      settings: const RouteSettings(
                                          name: ProfileScreen.id),
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.cupertino);
                            } else {
                              EasyLoading.dismiss();

                              //check loại payment
                              if (_cartProvider.cod == false) {
                                //trả qua thẻ
                                makePayment();
                              } else {
                                //thanh toán khi nhận hàng
                                setState(() {
                                  _coupon.discountRate = 0;
                                });
                                _saveOrder(_cartProvider, _payable, _coupon,
                                    userDetailsData);
                              }
                            }
                          });
                        },
                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Colors.redAccent)),
                        child: _checkingUser
                            ? const CircularProgressIndicator()
                            : Text(
                                _cartProvider.cod == false
                                    ? 'Thanh Toán'
                                    : 'Đặt hàng',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, boolinnerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: Colors.blue.shade900,
                elevation: 0.0,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Giỏ Hàng',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(
                      child: Row(
                        children: [
                          Text(
                            '${_cartProvider.carQty} ${_cartProvider.carQty > 1 ? 'Sản Phẩm, ' : 'Sản Phẩm, '} ',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                          const Text(
                            'Tổng giá đơn hàng : ',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          Text(
                            NumberFormat('#,###,###').format(_payable),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ];
          },
          body: _cartProvider.carQty > 0
              ? SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      children: [
                        const CodToggleSwitch(),
                        if (doc != null)
                          Column(
                            children: [
                              ListTile(
                                tileColor: Colors.white,
                                leading: SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.network((doc!.data()
                                        as Map<String, dynamic>)['hinhanh']),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(
                          height: 5,
                        ),
                        CartList(
                          document: widget.document,
                        ),
                        const CouponWidget(),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 4, left: 4, top: 4, bottom: 100),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Thông tin hoá đơn',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Giá trị giỏ hàng',
                                          style: textStyle,
                                        ),
                                        Text(
                                          NumberFormat('#,###,###')
                                              .format(_cartProvider.subTotal),
                                          style: textStyle,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'VAT',
                                          style: textStyle,
                                        ),
                                        Text(
                                          NumberFormat('#,###,###').format(vat),
                                          style: textStyle,
                                        ),
                                      ],
                                    ),
                                    if (discount > 0)
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    if (discount > 0)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Giảm giá',
                                            style: textStyle,
                                          ),
                                          Text(
                                            NumberFormat('#,###,###')
                                                .format(discount),
                                            style: textStyle,
                                          ),
                                        ],
                                      ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Phí vận chuyển',
                                          style: textStyle,
                                        ),
                                        Text(
                                          NumberFormat('#,###,###')
                                              .format(deliveryFee),
                                          style: textStyle,
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Tổng tiền ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          NumberFormat('#,###,###')
                                              .format(_payable),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(.3)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Text(
                                              'Tổng tiền được giảm',
                                              style: TextStyle(
                                                  color: Colors.blue.shade900),
                                            )),
                                            Text(
                                              NumberFormat('#,###,###')
                                                  .format(_discounted),
                                              style: TextStyle(
                                                  color: Colors.blue.shade900),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const Center(
                  child: Text('Giỏ hàng trống, tiếp tục mua sản phẩm'),
                ),
        ));
  }

  _saveOrder(
      CartProvider cartProvider, payable, coupon, userDetailsData) async {
    String trangThaiDH = cartProvider.cod ? 'Chờ xác nhận' : 'Đã thanh toán';
    if (coupon.document != null) {
      DocumentSnapshot couponData = await FirebaseFirestore.instance
          .collection('MaGiamGia')
          .doc(coupon.document.id)
          .get();

      // Check if the coupon has already been used by the current user
      if (couponData.exists &&
          couponData['nguoidung_id'] != null &&
          couponData['nguoidung_id'] == user!.uid) {
        // The coupon has already been used by the current user
        // Show a message or handle it as per your requirements
        EasyLoading.showError('Bạn đã sử dụng mã giảm giá này');
        return;
      }
    }
    // Create a batch for the transaction
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Save order details
    // ignore: unused_local_variable
    DocumentReference orderReference = await _orderServices.saveOrder({
      'SanPham': cartProvider.cartList,
      'id': user!.uid,
      'tennguoidung': userDetailsData?['Ho'] != null
          ? '${userDetailsData?['Ho']} ${userDetailsData?['Ten']}'
          : 'Tên người dùng không khả dụng',
      'phivanchuyen': deliveryFee,
      'tongdon': payable,
      'giamgia': discount.toStringAsFixed(0),
      'cod': cartProvider.cod,
      'vat': vat,
      'magiamgia': coupon.document == null
          ? null
          : (coupon.document?.data() as Map<String, dynamic>?)?['tengiamgia'],
      'timestamp': DateTime.now().toString(),
      'trangthaidh': trangThaiDH,
    });
    if (coupon.document != null) {
      DocumentReference couponReference = FirebaseFirestore.instance
          .collection('MaGiamGia')
          .doc(coupon.document?.id);

      batch.update(couponReference, {
        'nguoidung_id': user!.uid,
      });
    }
    for (var item in cartProvider.cartList) {
      DocumentReference productReference =
          FirebaseFirestore.instance.collection('SanPham').doc(item['MaSP']);

      batch.update(productReference, {
        'SoLuong': FieldValue.increment(-item['SoLuong']),
      });
    }

    // Commit the batch write
    await batch.commit().then((_) {
      _cartServices.deleteCart().then((value) {
        _cartServices.checkData().then((value) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SuccessScreenCod()),
            (route) => false,
          );
        });
      });
    }).catchError((error) {
      // ignore: avoid_print
      print("Error updating product quantities: $error");
      // Handle error if necessary
    });
  }
}
