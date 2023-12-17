import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_9shop/provider/store_provider.dart';
import 'package:project_9shop/services/product_service.dart';
import 'package:project_9shop/widgets/products/product_card_widget.dart';
import 'package:provider/provider.dart';

class ProductListWidget extends StatelessWidget {
  static const String id = 'product-list-screen';
  const ProductListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ProductServices _services = ProductServices();
    var _storeProvider = Provider.of<StoreProvider>(context);

    return StreamBuilder<QuerySnapshot>(
      //.where('tên cột',isEqualTo:'tên giá trị') = để lọc các giá trị theo  , thêm limittolast(10) giới hạn sp tối đa 10
      stream: _services.products
          .where('trangthai', isEqualTo: true)
          .where('TenDanhMucPhu',
              isEqualTo: _storeProvider.selectedProductCategory)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: const CircularProgressIndicator(),
          );
        }
        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: const Text(
              'Không có sản phẩm nào',
              textAlign: TextAlign.center,
            ),
          );
        }

        return Column(
          children: [
            // Container(
            //   height: 50,
            //   color: Colors.grey,
            //   child: ListView(
            //     padding: EdgeInsets.zero,
            //     scrollDirection: Axis.horizontal,
            //     // children: [Chip(label: Text('Sub Category'))],
            //   ),
            // ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.grey[400],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      '${snapshot.data!.docs.length} Sản Phẩm',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return ProductCard(document: document);
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
