import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_9shop/widgets/cart/counter.dart';

class CartCard extends StatelessWidget {
  final DocumentSnapshot? document;

  const CartCard({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  height: 120,
                  width: 120,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      ((document!.data() as Map<String, dynamic>)['hinhanh']),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            (document!.data() as Map<String, dynamic>)['TenSP'],
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        Text(
                          (document!.data()
                                  as Map<String, dynamic>)['DonViSP'] ??
                              '',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          NumberFormat('#,###,###').format(
                            int.parse((document!.data()
                                    as Map<String, dynamic>)['GiaSP']
                                .toString()),
                          ),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ]),
                )
              ],
            ),
            Positioned(
                right: 0.0,
                bottom: 0.0,
                child: CounterForCard(document: document)),
          ],
        ),
      ),
    );
  }
}
