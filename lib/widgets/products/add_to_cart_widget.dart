import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:project_9shop/services/cart_service.dart';
import 'package:project_9shop/widgets/cart/counter_widget.dart';

class AddToCartWidget extends StatefulWidget {
  final DocumentSnapshot document;

  const AddToCartWidget({super.key, required this.document});

  @override
  State<AddToCartWidget> createState() => _AddToCartWidgetState();
}

class _AddToCartWidgetState extends State<AddToCartWidget> {
  CartServices _cart = CartServices();
  User? user = FirebaseAuth.instance.currentUser;
  bool _loading = true;
  bool _exits = false;
  int _qty = 1;
  String? _docId;

  @override
  void initState() {
    getCardData(); //khi mở trang chi tiết sản phẩm. đầu tiên sẽ check sản phẩm
    super.initState();
  }

  getCardData() async {
    final snapshot = await _cart.cart
        .doc(user!.uid)
        .collection('SanPham')
        .get(); //phải add cart trước
    if (snapshot.docs.length == 0) {
      //sản phẩm không được add vào giỏ hàng
      setState(
        () {
          _loading = false;
        },
      );
    } else {
      setState(
        () {
          _loading = false;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //tiếp theo nếu sản phẩm tồn tại trong giỏ hàng, cần lấy số lượng chi tiết
    FirebaseFirestore.instance
        .collection('GioHang')
        .doc(user!.uid)
        .collection('SanPham')
        .where('MaSP',
            isEqualTo: (widget.document.data() as Map<String, dynamic>)['MaSP'])
        .get()
        .then((QuerySnapshot querySnapshot) => {
              // ignore: avoid_function_literals_in_foreach_calls
              querySnapshot.docs.forEach((doc) {
                if (doc['MaSP'] ==
                    (widget.document.data() as Map<String, dynamic>)['MaSP']) {
                  setState(() {
                    _exits = true;
                    _qty = doc['SoLuong'];
                    _docId = doc.id;
                  });
                }
              })
            });
    return _loading
        ? SizedBox(
            height: 56,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            ),
          )
        : _exits
            ? CounterWidget(
                document: widget.document,
                qty: _qty,
                docId: _docId,
              )
            : InkWell(
                onTap: () async {
                  EasyLoading.show(status: 'Đang thêm vào giỏ hàng...');
                  int? availableQuantity = (widget.document.data()
                      as Map<String, dynamic>)['SoLuong'] as int?;

                  if (availableQuantity! >= _qty) {
                    // Quantity is sufficient, proceed to add the product to the cart
                    await _cart.addToCart(widget.document).then((value) {
                      setState(() {
                        _exits = true;
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
                  height: 56,
                  color: Colors.red[400],
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shopping_basket_outlined,
                              color: Colors.white),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Thêm vào giỏ hàng',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
  }
}
