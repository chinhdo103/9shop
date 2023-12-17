import 'package:cloud_firestore/cloud_firestore.dart';

class TaiKhoanModel {
  static const SDT = 'sdt';
  static const ID = 'id';

  String? _sdt;
  String? _id;

  //getterr
  String? get sdt => _sdt;
  String? get id => _id;

  TaiKhoanModel.fromSnapshot(DocumentSnapshot snapshot) {
    // Use null-aware operators to check for null before accessing data and fields
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    _sdt = data?[SDT] as String?;
    _id = data?[ID] as String?;
  }
}
