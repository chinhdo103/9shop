import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_9shop/services/product_service.dart';
import 'package:project_9shop/widgets/products/product_card_widget.dart';

class RecentlyAddedProduct extends StatelessWidget {
  const RecentlyAddedProduct({super.key});

  @override
  Widget build(BuildContext context) {
    ProductServices _services = ProductServices();
    return StreamBuilder<QuerySnapshot>(
      //.where('tên cột',isEqualTo:'tên giá trị') = để lọc các giá trị theo - xem 39
      //.where('tên cột',isEqualTo:'tên giá trị') = để lọc các giá trị theo  , thêm limittolast(10) giới hạn sp tối đa 10
      stream: _services.products
          .where('trangthai', isEqualTo: true)
          .orderBy('ngaytao',
              descending: true) // Sort by ngàythem in descending order
          .limit(10)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        if (snapshot.data!.docs.isEmpty) {
          return Container();
        }

        return Column(
          children: [
            Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(4),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 236, 215, 118),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: Text(
                    'Sản Phẩm Mới',
                    style: TextStyle(
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 2,
                          color: Colors.black,
                        )
                      ],
                      color: Color(0xFFF4F9CD),
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
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
