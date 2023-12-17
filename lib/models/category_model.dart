import 'package:project_9shop/services/firebase_service.dart';

class DanhMuc {
  DanhMuc({this.tenDanhMuc, this.hinhanh});

  DanhMuc.fromJson(Map<String, Object?> json)
      : this(
          tenDanhMuc: json['TenDanhMuc']! as String,
          hinhanh: json['hinhanh']! as String,
        );

  final String? tenDanhMuc;
  final String? hinhanh;

  Map<String, Object?> toJson() {
    return {
      'TenDanhMuc': tenDanhMuc,
      'hinhanh': hinhanh,
    };
  }
}

FirebaseService _service = FirebaseService();
final danhmucCollection =
    _service.danhmuc.where('trangthai', isEqualTo: true).withConverter<DanhMuc>(
          fromFirestore: (snapshot, _) => DanhMuc.fromJson(snapshot.data()!),
          toFirestore: (movie, _) => movie.toJson(),
        );
