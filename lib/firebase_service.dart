import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  //tham chiếu đến tập dữ liệu homeBanner và gán vào biến homeBanner
  CollectionReference homeBanner =
      FirebaseFirestore.instance.collection('homeBanner');
  CollectionReference brandAd =
      FirebaseFirestore.instance.collection('brandAd');
}
