import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:project_9shop/services/firebase_service.dart';
import 'package:project_9shop/provider/location_provider.dart';
import 'package:project_9shop/screen/edit_profile_screen.dart';
import 'package:project_9shop/screen/main_screen.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? smsOtp;
  String? verificationId;
  String error = '';
  FirebaseService _service = FirebaseService();
  bool loading = false;
  LocationProvider locationData = LocationProvider();
  DocumentSnapshot? snapshot;
  Future<void> verifyPhone({
    BuildContext? context,
    String? sdt,
  }) async {
    this.loading = true;
    notifyListeners();

    // Check for null values in parameters
    if (context != null && sdt != null) {
      // Define verificationCompleted callback
      final PhoneVerificationCompleted verificationCompleted =
          (PhoneAuthCredential credential) async {
        loading = false;
        notifyListeners();
        await _auth.signInWithCredential(credential);
      };

      // Define verificationFailed callback
      final PhoneVerificationFailed verificationFailed =
          (FirebaseAuthException e) {
        this.loading = false;
        error = e.toString();
        print(e.code);
        error = e.toString();
        notifyListeners();
      };

      // Define smsOtpSend callback
      final PhoneCodeSent smsOtpSend = (String? verId, int? resendToken) async {
        verificationId = verId;
        // Call smsOtpDialog
        smsOtpDialog(context, sdt);
      };

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
        print(e);
      }
    } else {
      // Handle the case where one or more variables is null
      print(
          'One or more variables (context, sdt, latitude, longitude, address) is null');
      print('context: $context');
      print('sdt: $sdt');

      // Additional error handling or fallback logic can be added here
    }
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
            content: Container(
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
                            String matk = userData['id'];

                            if (userData['hovaten'] == null ||
                                userData['hovaten'].isEmpty) {
                              // 'hovaten' is missing, navigate to update information page
                              Navigator.of(context).pop();
                              PersistentNavBarNavigator
                                  .pushNewScreenWithRouteSettings(context,
                                      screen: const MainScreen(),
                                      settings: const RouteSettings(
                                          name: MainScreen.id),
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.cupertino);
                            } else {
                              Navigator.of(context).pop();
                              PersistentNavBarNavigator
                                  .pushNewScreenWithRouteSettings(context,
                                      screen: const MainScreen(),
                                      settings: const RouteSettings(
                                          name: MainScreen.id),
                                      withNavBar: false,
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.cupertino);
                            }
                          } else {
                            // Document does not exist
                            print('Document does not exist');
                          }
                        }).catchError((error) {
                          print('Error getting document: $error');
                        });
                      } else {
                        print('Login fails');
                      }
                    } else {
                      // Handle the case where either verificationId or smsOtp is null
                      print('verificationId or smsOtp is null');
                    }
                  } catch (e) {
                    this.error = 'Mã OTP không tồn tại';
                    notifyListeners();
                    print(e.toString());
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
    // Assuming 'TaiKhoanNguoiDung' is the collection name
    CollectionReference taiKhoanCollection =
        FirebaseFirestore.instance.collection('TaiKhoanNguoiDung');

    // Check if the document with the given 'id' already exists
    taiKhoanCollection.doc(id).get().then((DocumentSnapshot document) {
      if (document.exists) {
        // Document exists, update the 'sdt' field only
        taiKhoanCollection.doc(id).update({
          'sdt': sdt,
        });
        this.loading = false;
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
        this.loading = false;
        notifyListeners();
      }
    }).catchError((error) {
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
      GeoPoint? geoPoint;
      if (latitude != null && longitude != null) {
        geoPoint = GeoPoint(latitude, longitude);
      }

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
      this.loading = false;
      notifyListeners();
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  getUserDetails() async {
    DocumentSnapshot result = await FirebaseFirestore.instance
        .collection('TaiKhoanNguoiDung')
        .doc(_auth.currentUser!.uid)
        .get();
    if (result != null) {
      snapshot = result;
      notifyListeners();
    } else {
      snapshot = null;
      notifyListeners();
    }
    return result;
  }
}
