import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveForLater extends StatefulWidget {
  final DocumentSnapshot document;

  const SaveForLater({Key? key, required this.document}) : super(key: key);

  @override
  _SaveForLaterState createState() => _SaveForLaterState();
}

class _SaveForLaterState extends State<SaveForLater> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    loadFavoriteStatus();
  }

  Future<void> loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool(widget.document['MaSP'].toString()) ?? false;
    });
  }

  Future<void> saveForLater() async {
    CollectionReference _favorite =
        FirebaseFirestore.instance.collection('yeuthich');
    User? user = FirebaseAuth.instance.currentUser;

    // Kiểm tra xem sản phẩm đã được lưu trong danh sách yêu thích chưa
    var query = await _favorite
        .where('id', isEqualTo: user!.uid)
        .where('SanPham.MaSP', isEqualTo: widget.document['MaSP'])
        .get();

    if (query.docs.isEmpty) {
      // Nếu sản phẩm chưa có trong danh sách yêu thích, thêm vào
      await _favorite.add({
        'SanPham': widget.document.data(),
        'id': user.uid,
      });

      // Lưu trạng thái đã yêu thích xuống SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(widget.document['MaSP'].toString(), true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isFavorite) {
          // Nếu sản phẩm đã có trong danh sách yêu thích, xử lý ở đây
          EasyLoading.showToast('Đã yêu thích');
        } else {
          // Nếu sản phẩm chưa có trong danh sách yêu thích, lưu vào
          EasyLoading.show(status: 'Đang lưu...');
          saveForLater().then((value) {
            EasyLoading.showSuccess('Lưu thành công');
            setState(() {
              isFavorite = true;
            });
          });
        }
      },
      child: Container(
        height: 56,
        color: Colors.grey[800],
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(CupertinoIcons.bookmark,
                    color: isFavorite ? Colors.yellow : Colors.white),
                SizedBox(
                  width: 10,
                ),
                Text(
                  isFavorite ? 'Đã yêu thích' : 'Lưu sản phẩm',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
