import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:project_9shop/widgets/products/bottom_sheet_container.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const String id = 'product-details-screen';
  final DocumentSnapshot document;

  const ProductDetailsScreen({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.search))
        ],
      ),
      bottomSheet: BottomSheetContainner(document: document),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(.3),
                    border: Border.all(color: Theme.of(context).primaryColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8, bottom: 2, top: 2),
                    child: Text((document.data()
                            as Map<String, dynamic>)['TenDanhMucPhu'] ??
                        ''),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              (document.data() as Map<String, dynamic>)['TenSP'] ?? '',
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('1 Cái', style: TextStyle(fontSize: 20)),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              child: Row(
                children: [
                  Text(
                    NumberFormat('#,###,###').format(
                      (document.data() as Map<String, dynamic>)['GiaSP'],
                    ),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 18),
                  ),
                  const Text(' VNĐ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Hero(
                tag:
                    'SanPham${(document.data() as Map<String, dynamic>)['TenSP'] ?? ''}',
                child: Image.network(
                    (document.data() as Map<String, dynamic>)['hinhanh'] ?? ''),
              ),
            ),
            Divider(
              color: Colors.grey[300],
              thickness: 6,
            ),
            const SizedBox(
              child: Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8),
                child: Text(
                  'Mô tả Sản Phẩm',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Divider(
              color: Colors.grey[400],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 8, left: 10, right: 10),
              child: ExpandableText(
                (document.data() as Map<String, dynamic>)['MotaSP'] ?? '',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
                expandText: 'Xem thêm',
                collapseText: 'Thu gọn',
                maxLines: 4,
              ),
            ),
            Divider(
              color: Colors.grey[400],
            ),
            const SizedBox(
              child: Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8),
                child: Text(
                  'Thông tin sản phẩm khác',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Divider(
              color: Colors.grey[400],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mã SP : ${(document.data() as Map<String, dynamic>)['MaSP'] ?? ''}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Nhóm danh mục : ${(document.data() as Map<String, dynamic>)['TenDanhMuc'] ?? ''} || ${(document.data() as Map<String, dynamic>)['DanhMucChinh'] ?? ''} || ${(document.data() as Map<String, dynamic>)['TenDanhMucPhu'] ?? ''}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const Text(
                    'Sản phẩm chính hãng của 9Shop',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 60,
            )
          ],
        ),
      ),
    );
  }

  Future<void> saveForLater() {
    CollectionReference _favourite =
        FirebaseFirestore.instance.collection('yeuthich');
    User? user = FirebaseAuth.instance.currentUser;
    return _favourite.add({
      'SanPham': document.data(),
      'id': user!.uid,
    });
  }
}
