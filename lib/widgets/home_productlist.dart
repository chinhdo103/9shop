// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:project_9shop/models/product_model.dart';
// import 'package:project_9shop/screen/product_details_screen.dart';

// class HomeProductList extends StatelessWidget {
//   final String? danhMuc;

//   const HomeProductList({this.danhMuc, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.grey.shade200,
//       child: FirestoreQueryBuilder<SanPham>(
//         query: productQuery(tenDanhMuc: danhMuc),
//         builder: (context, snapshot, _) {
//           return GridView.builder(
//             physics: const ScrollPhysics(),
//             shrinkWrap: true,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 4,
//               childAspectRatio: 1 / 1.4,
//             ),
//             itemCount: snapshot.docs.length,
//             itemBuilder: (context, index) {
//               // if we reached the end of the currently obtained items, we try to
//               // obtain more items
//               if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
//                 // Tell FirestoreQueryBuilder to try to obtain more items.
//                 // It is safe to call this function from within the build method.
//                 snapshot.fetchMore();
//               }
//               var productIndex = snapshot.docs[index];
//               SanPham sanPham = productIndex.data();
//               String masp = productIndex.id;

//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.push<void>(
//                       context,
//                       MaterialPageRoute<void>(
//                         builder: (BuildContext context) => ProductDetailsScreen(
//                           masp: masp,
//                           sanpham: sanPham,
//                         ),
//                       ),
//                     );
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     height: 80,
//                     width: 80,
//                     child: Column(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(4),
//                           child: SizedBox(
//                             height: 60,
//                             width: 80,
//                             child: CachedNetworkImage(
//                                 imageUrl: sanPham.hinhAnh!.isNotEmpty
//                                     ? sanPham.hinhAnh![0]
//                                     : '',
//                                 fit: BoxFit.cover),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Text(
//                           sanPham.tenSP!,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(fontSize: 10),
//                           maxLines: 2,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
