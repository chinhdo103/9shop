import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:project_9shop/services/cart_service.dart';

class CartProvider with ChangeNotifier {
  CartServices _cart = CartServices();
  double subTotal = 0.0;
  int carQty = 0;
  bool cod = false;
  List cartList = [];
  QuerySnapshot? snapshot;
  Future<double?> getCartTotal() async {
    var cartTotal = 0.0;
    List _newList = [];
    QuerySnapshot snapshot =
        await _cart.cart.doc(_cart.user!.uid).collection('SanPham').get();
    if (snapshot == null) {
      return null;
    }
    snapshot.docs.forEach((doc) {
      if (!_newList.contains(doc.data())) {
        _newList.add(doc.data());
        cartList = _newList;
        notifyListeners();
      }
      cartTotal = cartTotal + (doc.data() as Map<String, dynamic>)['TongGia'];
    });

    subTotal = cartTotal;
    carQty = snapshot.size;
    snapshot = snapshot;
    notifyListeners();

    return cartTotal;
  }

  getPaymentMethod(index) {
    if (index == 0) {
      cod = false;
      notifyListeners();
    } else {
      cod = true;
      notifyListeners();
    }
  }
}
