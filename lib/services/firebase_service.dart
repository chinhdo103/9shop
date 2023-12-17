import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project_9shop/models/taikhoan_model.dart';

class FirebaseService {
  //tham chiếu đến tập dữ liệu homeBanner và gán vào biến homeBanner
  CollectionReference homeBanner =
      FirebaseFirestore.instance.collection('homeBanner');
  CollectionReference brandAd =
      FirebaseFirestore.instance.collection('brandAd');
  CollectionReference danhmuc =
      FirebaseFirestore.instance.collection('DanhMuc');
  CollectionReference danhmucchinh =
      FirebaseFirestore.instance.collection('DanhMucChinh');
  CollectionReference danhmucphu =
      FirebaseFirestore.instance.collection('DanhMucPhu');
  CollectionReference sanpham =
      FirebaseFirestore.instance.collection('sanpham');
  CollectionReference taikhoannguoidung =
      FirebaseFirestore.instance.collection('TaiKhoanNguoiDung');

  String formatedNumber(number) {
    var f = NumberFormat('#,###,###');
    String formatedNumber = f.format(number);

    return formatedNumber;
  }

  //them nguoi dung
  Future<void> createUserData(Map<String, dynamic> values) async {
    String id = values['id'];
    await taikhoannguoidung.doc(id).set(values);
  }

  //cap nhat du lieu nguoi dung
  Future<void> updateUserData(Map<String, dynamic> values) async {
    String id = values['id'];
    await taikhoannguoidung.doc(id).update(values);
  }

  //lay du lieu nguoi dung theo id
  Future<DocumentSnapshot> getUserById(String id) async {
    var result = await taikhoannguoidung.doc(id).get();
    return result;
  }
}
