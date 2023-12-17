import 'package:project_9shop/services/firebase_service.dart';

class DanhMucChinh {
  DanhMucChinh({this.danhmuc, this.danhMucChinh});

  DanhMucChinh.fromJson(Map<String, Object?> json)
      : this(
          danhmuc: json['danhmuc']! as String,
          danhMucChinh: json['DanhMucChinh']! as String,
        );

  final String? danhmuc;
  final String? danhMucChinh;

  Map<String, Object?> toJson() {
    return {
      'danhmuc': danhmuc,
      'DanhMucChinh': danhMucChinh,
    };
  }
}

FirebaseService _service = FirebaseService();
danhmucchinhCollection(selectedDm) {
  return _service.danhmucchinh
      .where('trangthai', isEqualTo: true)
      .where('danhmuc', isEqualTo: selectedDm)
      .withConverter<DanhMucChinh>(
          fromFirestore: (snapshot, _) =>
              DanhMucChinh.fromJson(snapshot.data()!),
          toFirestore: (movie, _) => movie.toJson());
}
