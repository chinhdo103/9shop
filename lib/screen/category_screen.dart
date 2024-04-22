import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:project_9shop/models/category_model.dart';
import 'package:project_9shop/widgets/category/main_category_widget.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String _title = 'Danh Mục Sản Phẩm';
  String? selectedDanhMuc;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          selectedDanhMuc == null ? _title : selectedDanhMuc!,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black54),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(IconlyLight.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(IconlyLight.buy),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: Row(children: [
        Container(
          width: 80,
          color: Colors.grey.shade300,
          child: FirestoreListView<DanhMuc>(
            query: danhmucCollection,
            itemBuilder: (context, snapshot) {
              DanhMuc danhmuc = snapshot.data();
              return InkWell(
                onTap: () {
                  setState(() {
                    _title = danhmuc.tenDanhMuc!;
                    selectedDanhMuc = danhmuc.tenDanhMuc;
                  });
                },
                child: Container(
                  height: 90,
                  color: selectedDanhMuc == danhmuc.tenDanhMuc
                      ? Colors.white
                      : Colors.grey.shade300,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 30,
                            child: CachedNetworkImage(
                              imageUrl: danhmuc.hinhanh!,
                              color: selectedDanhMuc == danhmuc.tenDanhMuc
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            danhmuc.tenDanhMuc!,
                            style: TextStyle(
                              fontSize: 9,
                              color: selectedDanhMuc == danhmuc.tenDanhMuc
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        MainCategoryWidget(
          selectedDm: selectedDanhMuc,
        ),
      ]),
    );
  }
}
