import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:project_9shop/provider/coupon_provider.dart';
import 'package:provider/provider.dart';

class CouponWidget extends StatefulWidget {
  const CouponWidget({super.key});

  @override
  State<CouponWidget> createState() => _CouponWidgetState();
}

class _CouponWidgetState extends State<CouponWidget> {
  Color color = Colors.grey;
  bool _enable = false;
  var _couponText = TextEditingController();
  bool _visibile = false;

  @override
  Widget build(BuildContext context) {
    var _coupon = Provider.of<CouponProvider>(context);

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Row(
              children: [
                Expanded(
                    child: SizedBox(
                  height: 38,
                  child: TextField(
                    controller: _couponText,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[300],
                      hintText: 'Nhập mã giảm giá ',
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                    onChanged: (String value) {
                      if (value.length < 3) {
                        setState(() {
                          color = Colors.grey;
                          _enable = false;
                        });
                        if (value.isNotEmpty) {
                          color = Theme.of(context).primaryColor;
                          _enable = true;
                        }
                      }
                    },
                  ),
                )),
                AbsorbPointer(
                  absorbing: _enable ? false : true,
                  child: OutlinedButton(
                    style: const ButtonStyle(
                        side: MaterialStatePropertyAll<BorderSide>(
                            BorderSide(color: Colors.orange))),
                    onPressed: () {
                      EasyLoading.show(status: 'Đang xác nhận mã giảm giá...');
                      _coupon.getCouponDetails(_couponText.text).then((value) {
                        if (_coupon.document == null) {
                          setState(() {
                            _coupon.discountRate = 0;
                            _visibile = false;
                          });
                          EasyLoading.dismiss();
                          showDialog(_couponText.text, 'không tồn tại');
                          return;
                        }
                        if (_coupon.expired == false) {
                          setState(() {
                            _visibile = true;
                          });
                          EasyLoading.dismiss();
                          showDialog(_couponText.text,
                              'Đã áp dụng mã giảm giá thành công');
                          return;
                        }
                        if (_coupon.expired == true) {
                          setState(() {
                            _coupon.discountRate = 0;
                            _visibile = false;
                          });
                          EasyLoading.dismiss();

                          showDialog(_couponText.text, 'đã hết hạn sử dụng');
                        }
                      });
                    },
                    child: const Text(
                      'Áp Dụng',
                      style: TextStyle(
                          color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: _visibile,
            child: _coupon.document == null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DottedBorder(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.greenAccent.withOpacity(.4)),
                              width: MediaQuery.of(context).size.width - 80,
                              height: 90,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text((_coupon.document?.data()
                                                as Map<String, dynamic>?)?[
                                            'tengiamgia'] ??
                                        'Default Text or Empty String'),
                                  ),
                                  Divider(
                                    color: Colors.grey[800],
                                  ),
                                  Text(
                                      'Phiếu giảm giá ${(_coupon.document?.data() as Map<String, dynamic>?)?['%giamgia']}%'),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text((_coupon.document?.data() as Map<String,
                                          dynamic>?)?['motagiamgia'] ??
                                      'Default Text or Empty String'),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                                right: -5.0,
                                top: -10,
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _coupon.discountRate = 0;
                                        _visibile = false;
                                        _couponText.clear();
                                      });
                                    },
                                    icon: const Icon(Icons.clear)))
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  showDialog(code, vadility) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('ÁP DỤNG MÃ GIẢM GIÁ'),
            content: Text(
                'Mã giảm giá $code $vadility, vui lòng kiểm tra mã nhập hoặc nhập mã khác'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Đồng ý',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          );
        });
  }
}
