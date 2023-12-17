import 'package:flutter/material.dart';
import 'package:project_9shop/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:slide_switcher/slide_switcher.dart';

class CodToggleSwitch extends StatelessWidget {
  const CodToggleSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    var _cart = Provider.of<CartProvider>(context);
    return Container(
      child: SlideSwitcher(
        onSelect: (index) {
          _cart.getPaymentMethod(index);
        },
        containerHeight: 40,
        containerWight: 350,
        children: const [
          Text('TT thẻ'),
          Text('TT nhận hàng'),
        ],
      ),
    );
  }
}
// _cart.getPaymentMethod(index);