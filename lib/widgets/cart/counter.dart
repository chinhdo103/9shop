import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:project_9shop/services/cart_service.dart';

class CounterForCard extends StatefulWidget {
  final DocumentSnapshot? document;

  const CounterForCard({super.key, required this.document});

  @override
  State<CounterForCard> createState() => _CounterForCardState();
}

class _CounterForCardState extends State<CounterForCard> {
  User? user = FirebaseAuth.instance.currentUser;
  final CartServices _cart = CartServices();
  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  int _qty = 1;
  String? _docId;
  bool _exists = false;
  bool _updating = false;

  @override
  void initState() {
    getCartData();
    super.initState();
  }

  getCartData() {
    FirebaseFirestore.instance
        .collection('GioHang')
        .doc(user!.uid)
        .collection('SanPham')
        .where('MaSP',
            isEqualTo:
                (widget.document!.data() as Map<String, dynamic>)['MaSP'])
        .get()
        .then(
          (QuerySnapshot querySnapshot) => {
            if (querySnapshot.docs.isNotEmpty)
              {
                querySnapshot.docs.forEach((doc) {
                  if (doc['MaSP'] ==
                      (widget.document!.data()
                          as Map<String, dynamic>)['MaSP']) {
                    setState(() {
                      _qty = doc['SoLuong'];
                      _docId = doc.id;
                      _exists = true;
                    });
                  }
                }),
              }
            else
              {
                setState(() {
                  _exists = false;
                })
              }
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return _exists
        ? StreamBuilder(
            stream: getCartData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return Container(
                height: 28,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.pink),
                    borderRadius: BorderRadius.circular(4)),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _updating = true;
                        });
                        if (_qty == 1) {
                          _cart.removeFromCart(_docId).then((value) {
                            setState(() {
                              _updating = false;
                              _exists = false;
                            });
                            _cart.checkData();
                          });
                        }
                        if (_qty > 1) {
                          setState(() {
                            _qty = _qty - 1;
                          });
                          var total = _qty *
                              (widget.document!.data()
                                  as Map<String, dynamic>)['GiaSP'];
                          _cart
                              .updateCartQty(_docId, _qty, total)
                              .then((value) {
                            setState(() {
                              _updating = false;
                            });
                          });
                        }
                      },
                      child: Container(
                        child: Icon(
                          _qty == 1 ? Icons.delete_outline : Icons.remove,
                          color: Colors.pink,
                        ),
                      ),
                    ),
                    Container(
                      height: double.infinity,
                      width: 30,
                      color: Colors.pink,
                      child: Center(
                        child: FittedBox(
                            child: _updating
                                ? const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white)),
                                  )
                                : Text(_qty.toString(),
                                    style:
                                        const TextStyle(color: Colors.white))),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _updating = true;
                          _qty = _qty + 1;
                        });

                        // Update the cart quantity in Firestore
                        var total = _qty *
                            (widget.document!.data()
                                as Map<String, dynamic>)['GiaSP'];
                        _cart.updateCartQty(_docId, _qty, total).then((value) {
                          setState(() {
                            _updating = false;
                          });
                        });
                      },
                      child: Container(
                        child: const Icon(Icons.add, color: Colors.pink),
                      ),
                    ),
                  ],
                ),
              );
            })
        : StreamBuilder(
            stream: getCartData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return InkWell(
                onTap: () async {
                  EasyLoading.show(status: 'Đang thêm vào giỏ hàng...');
                  int? availableQuantity = (widget.document!.data()
                      as Map<String, dynamic>)['SoLuong'] as int?;
                  if (availableQuantity! >= _qty) {
                    // Quantity is sufficient, proceed to add the product to the cart
                    await _cart.addToCart(widget.document).then((value) {
                      setState(() {
                        _exists = true;
                      });
                      EasyLoading.showSuccess(
                          'Sản phẩm đã được thêm vào giỏ hàng');
                    });
                  } else if (availableQuantity == 0) {
                    EasyLoading.showError('Sản phẩm hiện đã hết hàng');
                    EasyLoading.dismiss();
                  } else {
                    // Quantity is not enough, show an error message
                    EasyLoading.showError('Không đủ số lượng sản phẩm');
                    EasyLoading.dismiss();
                  }
                },
                child: Container(
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: Text(
                        'Thêm',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              );
            });
  }
}
