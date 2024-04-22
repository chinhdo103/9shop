// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_9shop/services/firebase_service.dart';
import 'package:project_9shop/provider/location_provider.dart';
import 'package:project_9shop/screen/main_screen.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? smsOtp;
  String? verificationId;
  String error = '';
  final FirebaseService _service = FirebaseService();
  bool loading = false;
  LocationProvider locationData = LocationProvider();
  DocumentSnapshot? snapshot;
  Future<void> verifyPhone({
    BuildContext? context,
    String? sdt,
  }) async {
    loading = true;
    notifyListeners();

    // Check for null values in parameters
    if (context != null && sdt != null) {
      // Define verificationCompleted callback
      verificationCompleted(PhoneAuthCredential credential) async {
        loading = false;
        notifyListeners();
        await _auth.signInWithCredential(credential);
      }

      // Define verificationFailed callback
      verificationFailed(FirebaseAuthException e) {
        loading = false;
        error = e.toString();
        error = e.toString();
        notifyListeners();
      }

      // Define smsOtpSend callback
      smsOtpSend(String? verId, int? resendToken) async {
        verificationId = verId;
        // Call smsOtpDialog
        smsOtpDialog(context, sdt);
      }

      try {
        // Perform phone number verification
        _auth.verifyPhoneNumber(
          phoneNumber: sdt,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: smsOtpSend,
          codeAutoRetrievalTimeout: (String verId) {
            verificationId = verId;
          },
        );
      } catch (e) {
        error = e.toString();
        notifyListeners();
      }
    } else {}
  }

  String getCurrentUserUid() {
    return _auth.currentUser?.uid ?? '';
  }

  Future<void> smsOtpDialog(BuildContext context, String sdt) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Column(
              children: [
                Text('Mã xác nhận'),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Nhập mã có 6 số từ sms',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                )
              ],
            ),
            content: SizedBox(
              height: 85,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value) {
                  smsOtp = value;
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    if (verificationId != null && smsOtp != null) {
                      PhoneAuthCredential phoneAuthCredential =
                          PhoneAuthProvider.credential(
                              verificationId: verificationId!,
                              smsCode: smsOtp!);

                      final User user = (await _auth
                              .signInWithCredential(phoneAuthCredential))
                          .user!;

                      if (locationData.selectedAdressAll != null) {
                        updateUser(
                            id: user.uid,
                            sdt: user.phoneNumber,
                            latitude: locationData.latitude,
                            longitude: locationData.longitude,
                            address: locationData.selectedAdressAll.toString());
                      } else {
                        _createUser(
                          id: user.uid,
                          sdt: user.phoneNumber,
                        );
                      }

                      // Inside smsOtpDialog function
                      // ignore: unnecessary_null_comparison
                      if (user != null) {
                        String docname = user.uid;

                        CollectionReference taiKhoanCollection =
                            FirebaseFirestore.instance
                                .collection('TaiKhoanNguoiDung');

                        taiKhoanCollection
                            .doc(docname)
                            .get()
                            .then((DocumentSnapshot document) {
                          if (document.exists) {
                            var userData =
                                document.data() as Map<String, dynamic>;
                            // ignore: unused_local_variable
                            String matk = userData['id'];

                            if (userData['hovaten'] == null ||
                                userData['hovaten'].isEmpty) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainScreen()),
                                (route) => false,
                              );
                            } else {
                              Navigator.of(context).pop();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainScreen()),
                                (route) => false,
                              );
                            }
                          } else {
                            // Document does not exist
                            // ignore: avoid_print
                            print('Document does not exist');
                          }
                        }).catchError((error) {
                          // ignore: avoid_print
                          print('Error getting document: $error');
                        });
                      } else {
                        // ignore: avoid_print
                        print('Login fails');
                      }
                    } else {
                      // Handle the case where either verificationId or smsOtp is null
                      // ignore: avoid_print
                      print('verificationId or smsOtp is null');
                    }
                  } catch (e) {
                    error = 'Mã OTP không tồn tại';
                    notifyListeners();
                    // ignore: avoid_print
                    print(e.toString());
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Xong'),
              )
            ],
          );
        });
  }

  void _createUser(
      {String? id,
      String? sdt,
      double? longitude,
      double? latitude,
      String? address}) {
    CollectionReference taiKhoanCollection =
        FirebaseFirestore.instance.collection('TaiKhoanNguoiDung');

    taiKhoanCollection.doc(id).get().then((DocumentSnapshot document) {
      if (document.exists) {
        taiKhoanCollection.doc(id).update({
          'sdt': sdt,
        });
        loading = false;
        notifyListeners();
      } else {
        // Document does not exist, create a new document with 'id' and 'sdt'
        taiKhoanCollection.doc(id).set({
          'id': id,
          'sdt': sdt,
          'kinhdo': longitude,
          'vido': latitude,
          'diachi': address,
        });
        loading = false;
        notifyListeners();
      }
    }).catchError((error) {
      // ignore: avoid_print
      print('Error checking document existence: $error');
    });
  }

  void updateUser({
    String? id,
    String? sdt,
    double? longitude,
    double? latitude,
    String? address,
  }) async {
    try {
      // Check if latitude and longitude are not null before creating GeoPoint
      if (latitude != null && longitude != null) {}

      // Update user data
      await FirebaseFirestore.instance
          .collection('TaiKhoanNguoiDung')
          .doc(id)
          .update({
        'sdt': sdt,
        'kinhdo': longitude,
        'vido': latitude,
        'diachi': address,
      });
      loading = false;
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print('Error updating user: $e');
    }
  }

  getUserDetails() async {
    DocumentSnapshot result = await FirebaseFirestore.instance
        .collection('TaiKhoanNguoiDung')
        .doc(_auth.currentUser!.uid)
        .get();
    snapshot = result;
    notifyListeners();
    return result;
  }
}
