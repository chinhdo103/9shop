// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:project_9shop/services/cart_service.dart';
import 'package:project_9shop/widgets/products/add_to_cart_widget.dart';

class CounterWidget extends StatefulWidget {
  final DocumentSnapshot document;
  final String? docId;
  final int qty;

  const CounterWidget({
    Key? key,
    required this.document,
    this.docId,
    required this.qty,
  }) : super(key: key);

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  CartServices _cart = CartServices();
  int? _qty;
  bool _updating = false;
  bool _exits = true;

  @override
  Widget build(BuildContext context) {
    setState(() {
      _qty = widget.qty;
    });
    return _exits
        ? Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            height: 56,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: FittedBox(
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _updating = true;
                          });
                          if (_qty == 1) {
                            _cart.removeFromCart(widget.docId).then((value) {
                              setState(() {
                                _updating = false;
                                _exits = false;
                              });
                              _cart.checkData();
                            });
                          }
                          if (_qty! > 1) {
                            setState(() {
                              _qty = _qty! - 1;
                            });
                            var total = _qty! *
                                (widget.document.data()
                                    as Map<String, dynamic>)['GiaSP'];
                            _cart
                                .updateCartQty(widget.docId, _qty, total)
                                .then((value) {
                              setState(() {
                                _updating = false;
                              });
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: _qty == 1
                                ? const Icon(Icons.delete_outline,
                                    color: Colors.red)
                                : const Icon(Icons.remove, color: Colors.red),
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 8, bottom: 8),
                            child: _updating
                                ? SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor),
                                    ),
                                  )
                                : Text(
                                    _qty.toString(),
                                    style: const TextStyle(color: Colors.red),
                                  )),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _updating = true;
                            _qty = _qty! + 1;
                          });

                          var availableQuantity = (widget.document.data()
                              as Map<String, dynamic>)['SoLuong'];

                          if (_qty! > availableQuantity) {
                            // Quantity exceeds available quantity, show an error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Sản phẩm không còn đủ hàng'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            setState(() {
                              _updating = false;
                              _qty =
                                  availableQuantity; // Reset to the available quantity
                            });
                          } else {
                            // Update the cart quantity in Firestore
                            var total = _qty! *
                                (widget.document.data()
                                    as Map<String, dynamic>)['GiaSP'];
                            _cart
                                .updateCartQty(widget.docId, _qty, total)
                                .then((value) {
                              setState(() {
                                _updating = false;
                              });
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.add,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : AddToCartWidget(document: widget.document);
  }
}
