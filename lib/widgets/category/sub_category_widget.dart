import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:project_9shop/models/sub_category_model.dart';
import 'package:project_9shop/provider/store_provider.dart';
import 'package:project_9shop/screen/product_list_screen.dart';
import 'package:project_9shop/widgets/products/product_list.dart';
import 'package:provider/provider.dart';

class SubCategoryWidget extends StatelessWidget {
  final String? selectedDmp;
  const SubCategoryWidget({this.selectedDmp, super.key});

  @override
  Widget build(BuildContext context) {
    var _storeProvider = Provider.of<StoreProvider>(context);
    return SizedBox(
        // height: 200,
        child: FirestoreQueryBuilder<DanhMucPhu>(
      query: danhmucphuCollection(selectedSubcat: selectedDmp),
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('error ${snapshot.error}');
        }

        return GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: snapshot.docs.isEmpty ? 1 / 1 : 1 / 1.1,
          ),
          itemCount: snapshot.docs.length,
          itemBuilder: (context, index) {
            // if we reached the end of the currently obtained items, we try to
            // obtain more items

            DanhMucPhu danhmucphu = snapshot.docs[index].data();
            return InkWell(
              onTap: () {
                _storeProvider.selectedCategory(danhmucphu.tenDanhMucPhu);
                PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    screen: ProductListScreen(),
                    settings: RouteSettings(name: ProductListScreen.id),
                    pageTransitionAnimation: PageTransitionAnimation.cupertino);
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: CachedNetworkImage(
                        imageUrl: danhmucphu.hinhanh!,
                        placeholder: (context, _) {
                          return Container(
                              height: 60,
                              width: 60,
                              color: Colors.grey.shade600);
                        },
                      ),
                    ),
                  ),
                  Text(
                    danhmucphu.tenDanhMucPhu!,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        );
      },
    ));
  }
}
