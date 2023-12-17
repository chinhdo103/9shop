import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';
import 'package:project_9shop/provider/order_provider.dart';
import 'package:project_9shop/services/order_services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

class MyOrdersScreen extends StatefulWidget {
  static const String id = 'MyOrdersScreen';
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int tag = 1;
  List<String> options = [
    'Tất cả đơn hàng',
    'Chờ xác nhận',
    'Đã từ chối',
    'Đã hủy đơn',
    'Đã xác nhận',
    'Đang lấy hàng',
    'Đang vận chuyển',
    'Đã giao hàng',
  ];
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('vi_VN', null); // Initialize the locale data

    OrderServices _orderServices = OrderServices();
    var _orderProvider = Provider.of<OrderProvider>(context);
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'Đơn hàng của tôi',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(IconlyLight.search))
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: ChipsChoice<int>.single(
              choiceStyle: const C2ChipStyle(
                  borderRadius: BorderRadius.all(Radius.circular(3))),
              value: tag,
              onChanged: (val) {
                if (val == 0) {
                  setState(() {
                    _orderProvider.status = null;
                  });
                }
                setState(() {
                  tag = val;
                  _orderProvider.status = (options[val]);
                });
              },
              choiceItems: C2Choice.listFrom<int, String>(
                source: options,
                value: (i, v) => i,
                label: (i, v) => v,
              ),
            ),
          ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: _orderServices.orders
                  .where('id', isEqualTo: user!.uid)
                  .where('trangthaidh',
                      isEqualTo: tag > 0 ? _orderProvider.status : null)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.size == 0) {
                  return Center(
                    child: Center(
                      child: Text(
                        tag > 0
                            ? 'Không có đơn hàng ${options[tag]}'
                            : 'Bạn chưa có đơn hàng, Hãy đặt đơn hàng đầu tiên nhé !!!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      return Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            ListTile(
                              horizontalTitleGap: 0,
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 14,
                                child: Icon(
                                  CupertinoIcons.square_list,
                                  size: 18,
                                  color: (document.data() as Map<String,
                                              dynamic>)['trangthaidh'] ==
                                          'Đã từ chối'
                                      ? Colors.red
                                      : (document.data() as Map<String,
                                                  dynamic>)['trangthaidh'] ==
                                              'Đã xác nhận'
                                          ? Colors.blueGrey[400]
                                          : Colors.orange,
                                ),
                              ),
                              title: Text(
                                (document.data()
                                    as Map<String, dynamic>)['trangthaidh'],
                                style: TextStyle(
                                    fontSize: 12,
                                    color: (document.data() as Map<String,
                                                dynamic>)['trangthaidh'] ==
                                            'Đã từ chối'
                                        ? Colors.red
                                        : (document.data() as Map<String,
                                                    dynamic>)['trangthaidh'] ==
                                                'Đã xác nhận'
                                            ? Colors.blueGrey[400]
                                            : Colors.orange,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Vào ${DateFormat('dd MMMM y', 'vi').format(DateTime.parse((document.data() as Map<String, dynamic>)['timestamp']))}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Phương thức thanh toán',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      (document.data() as Map<String, dynamic>)[
                                                  'cod'] ==
                                              true
                                          ? 'Thanh toán khi nhận hàng'
                                          : 'Thanh toán qua thẻ',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      )),
                                  Text(
                                    'Tổng đơn : ${NumberFormat('#,###,###').format((document.data() as Map<String, dynamic>)['tongdon'])}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            ExpansionTile(
                              title: const Text(
                                'Chi tiết đơn hàng',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),
                              subtitle: const Text(
                                'Xem chi tiết đơn hàng',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                              ),
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Image.network((document.data()
                                                as Map<String, dynamic>)[
                                            'SanPham'][index]['hinhanh']),
                                      ),
                                      title: Text(
                                          (document.data() as Map<String,
                                                  dynamic>)['SanPham'][index]
                                              ['TenSP'],
                                          style: const TextStyle(fontSize: 12)),
                                      subtitle: Text(
                                          '${(document.data() as Map<String, dynamic>)['SanPham'][index]['SoLuong']} x ${NumberFormat('#,###,###').format((document.data() as Map<String, dynamic>)['SanPham'][index]['GiaSP'])} = ${NumberFormat('#,###,###').format((document.data() as Map<String, dynamic>)['SanPham'][index]['TongGia'])}',
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12)),
                                    );
                                  },
                                  itemCount: (document.data()
                                          as Map<String, dynamic>)['SanPham']
                                      .length,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 8, bottom: 8),
                                  child: Card(
                                    elevation: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          if (int.parse((document.data() as Map<
                                                  String,
                                                  dynamic>)['giamgia']) >
                                              0)
                                            Container(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Giảm giá : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        NumberFormat(
                                                                '#,###,###')
                                                            .format(
                                                          int.parse((document
                                                                          .data()
                                                                      as Map<
                                                                          String,
                                                                          dynamic>)[
                                                                  'giamgia'] ??
                                                              '0'),
                                                        ),
                                                        style: const TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Mã giảm giá : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        (document.data() as Map<
                                                                String,
                                                                dynamic>)[
                                                            'magiamgia'],
                                                        style: const TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                'Phí vận chuyển : ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                NumberFormat('#,###,###')
                                                    .format(
                                                  (document.data() as Map<
                                                              String, dynamic>)[
                                                          'phivanchuyen'] ??
                                                      '0',
                                                ),
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const Divider(
                              height: 3,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
