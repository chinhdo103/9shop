import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:project_9shop/provider/cart_provider.dart';
import 'package:project_9shop/screen/cart_screen.dart';
import 'package:provider/provider.dart';

class CartNotification extends StatefulWidget {
  const CartNotification({super.key});

  @override
  State<CartNotification> createState() => _CartNotificationState();
}

class _CartNotificationState extends State<CartNotification> {
  DocumentSnapshot? document;
  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _CartProvider = Provider.of<CartProvider>(context);
    _CartProvider.getCartTotal();

    return Visibility(
      visible: _CartProvider.carQty > 0 ? true : false,
      child: Container(
        height: 45,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.blue.shade900,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12), topLeft: Radius.circular(12))),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${_CartProvider.carQty}${_CartProvider.carQty == 1 ? 'Sản Phẩm' : 'Sản Phẩm'}',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          '  |  ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          NumberFormat('#,###,###')
                              .format(_CartProvider.subTotal),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Text(
                      '  - 9Shop',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                      context,
                      withNavBar: false,
                      screen: CartScreen(
                        document: document,
                      ),
                      settings: const RouteSettings(name: CartScreen.id),
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino);
                },
                child: const SizedBox(
                  child: Row(
                    children: [
                      Text(
                        'Xem giỏ hàng',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
