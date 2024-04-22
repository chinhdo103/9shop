import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:project_9shop/models/category_model.dart';
import 'package:project_9shop/screen/main_screen.dart';
import 'package:project_9shop/widgets/home_productList.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  String? _selectedDanhMuc;
  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Danh mục sản phẩm',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      fontSize: 20),
                ),
                TextButton(
                    onPressed: () {
                      _selectedDanhMuc = null;
                    },
                    child: const Text(
                      'Xem tất cả',
                      style: TextStyle(fontSize: 12),
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: FirestoreListView<DanhMuc>(
                      scrollDirection: Axis.horizontal,
                      query: danhmucCollection,
                      itemBuilder: (context, snapshot) {
                        DanhMuc danhMuc = snapshot.data();
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ActionChip(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2)),
                            backgroundColor:
                                _selectedDanhMuc == danhMuc.tenDanhMuc
                                    ? Colors.blue.shade900
                                    : Colors.grey,
                            label: Text(
                              danhMuc.tenDanhMuc!,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: _selectedDanhMuc == danhMuc.tenDanhMuc
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedDanhMuc = danhMuc.tenDanhMuc;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                    child: IconButton(
                        onPressed: () {
                          //hiển thị tất cả danh mục
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const MainScreen(
                                index: 1,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(IconlyLight.arrowDown)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
