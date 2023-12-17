import 'package:project_9shop/services/firebase_service.dart';

class DanhMucPhu {
  DanhMucPhu({this.danhMucChinh, this.tenDanhMucPhu, this.hinhanh});

  DanhMucPhu.fromJson(Map<String, Object?> json)
      : this(
          danhMucChinh: json['DanhMucChinh']! as String,
          tenDanhMucPhu: json['TenDanhMucPhu']! as String,
          hinhanh: json['hinhanh']! as String,
        );

  final String? danhMucChinh;
  final String? tenDanhMucPhu;
  final String? hinhanh;

  Map<String, Object?> toJson() {
    return {
      'DanhMucChinh': danhMucChinh,
      'TenDanhMucPhu': tenDanhMucPhu,
      'hinhanh': hinhanh,
    };
  }
}

FirebaseService _service = FirebaseService();
danhmucphuCollection({selectedSubcat}) {
  return _service.danhmucphu
      .where('trangthai', isEqualTo: true)
      .where('DanhMucChinh', isEqualTo: selectedSubcat)
      .withConverter<DanhMucPhu>(
        fromFirestore: (snapshot, _) => DanhMucPhu.fromJson(snapshot.data()!),
        toFirestore: (movie, _) => movie.toJson(),
      );
}
