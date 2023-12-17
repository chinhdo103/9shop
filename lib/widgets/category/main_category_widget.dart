import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_9shop/models/main_category_model.dart';
import 'package:project_9shop/widgets/category/sub_category_widget.dart';

class MainCategoryWidget extends StatefulWidget {
  final String? selectedDm;
  const MainCategoryWidget({this.selectedDm, super.key});

  @override
  State<MainCategoryWidget> createState() => _MainCategoryWidgetState();
}

class _MainCategoryWidgetState extends State<MainCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FirestoreListView<DanhMucChinh>(
        query: danhmucchinhCollection(widget.selectedDm),
        itemBuilder: (context, snapshot) {
          DanhMucChinh danhmucchinh = snapshot.data();
          return ExpansionTile(
            title: Text(danhmucchinh.danhMucChinh!),
            children: [
              SubCategoryWidget(
                selectedDmp: danhmucchinh.danhMucChinh,
              )
            ],
          );
        },
      ),
    );
  }
}
