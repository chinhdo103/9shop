import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as FBauth;
import 'package:project_9shop/provider/auth_provider.dart' as AuthPRD;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';
import 'package:project_9shop/services/firebase_service.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';

class ProfileUpdateScreen extends StatefulWidget {
  static const String id = 'profile-update-screen';
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final _fromKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseService _user = FirebaseService();
  var firstName = TextEditingController();

  var lastName = TextEditingController();
  var email = TextEditingController();
  var mobile = TextEditingController();
  FirebaseService _service = FirebaseService();

  dynamic image;
  String? fileName;

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    if (result != null) {
      await loadImage(result);
    } else {
      Fluttertoast.showToast(
        msg: "Huỷ Chọn Ảnh",
        toastLength: Toast.LENGTH_SHORT,
        webPosition: "center",
        webShowClose: false,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> loadImage(FilePickerResult result) async {
    try {
      File file = File(result.files.single.path!);
      setState(() {
        image = file;
        fileName = result.files.single.name;
        print('Image loaded successfully. fileName: $fileName');
      });
    } catch (e) {
      print('Failed to load image: $e');
      // Handle the failure
    }
  }

  updateProfile() async {
    String? downloadURL;

    if (image != null) {
      String fileName = 'userImage/${DateTime.now().millisecondsSinceEpoch}';
      var ref = firebase_storage.FirebaseStorage.instance.ref(fileName);
      String? mimeType = mime(basename(fileName)) ?? 'image/jpeg';
      print('MIME Type: $mimeType');

      var metaData = firebase_storage.SettableMetadata(contentType: mimeType);
      firebase_storage.TaskSnapshot uploadSnapshot =
          await ref.putData((image as File).readAsBytesSync(), metaData);
      downloadURL = await uploadSnapshot.ref.getDownloadURL();
    }

    Map<String, dynamic> updateData = {
      'Ho': firstName.text,
      'Ten': lastName.text,
      'email': email.text,
    };

    if (downloadURL != null) {
      updateData['hinhanh'] = downloadURL;
    }

    if (_fromKey.currentState!.validate()) {
      return FirebaseFirestore.instance
          .collection('TaiKhoanNguoiDung')
          .doc(user!.uid)
          .update(updateData);
    }
  }

  @override
  void initState() {
    _user.getUserById(user!.uid).then((value) {
      if (mounted) {
        setState(() {
          firstName.text = (value.data() as Map<String, dynamic>)['Ho'] ?? '';
          lastName.text = (value.data() as Map<String, dynamic>)['Ten'] ?? '';
          email.text = (value.data() as Map<String, dynamic>)['email'] ?? '';
          mobile.text = user!.phoneNumber!;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<AuthPRD.AuthProvider>(context);

    FBauth.User? user = FBauth.FirebaseAuth.instance.currentUser;
    userDetails.getUserDetails();
    var userDetailsData = userDetails.snapshot?.data() as Map<String, dynamic>?;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Cập nhật thông tin',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      bottomSheet: InkWell(
        onTap: () {
          if (_fromKey.currentState!.validate()) {
            EasyLoading.show(status: 'Đang cập nhật thông tin...');
            updateProfile().then((value) {
              EasyLoading.showSuccess('Đã cập nhật thông tin');

              Navigator.pop(context);
            });
          }
        },
        child: Container(
          width: double.infinity,
          height: 56,
          color: Colors.blueGrey[900],
          child: const Center(
            child: Text(
              'Cập nhật',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
            key: _fromKey,
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Stack(
                    fit: StackFit.expand,
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 58,
                        child: ClipOval(
                          child: SizedBox(
                            width: 115,
                            height: 115,
                            child: image != null
                                ? Image.file(
                                    image, // Use Image.file instead of Image.memory
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/9Shop-logo.png',
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : Image.network(
                                    userDetailsData?['hinhanh'] ?? '',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: -10,
                        bottom: 0,
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Padding(
                            padding: EdgeInsets.zero,
                            child: TextButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      side: const BorderSide(
                                          color: Colors.white)),
                                ),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey),
                              ),
                              onPressed: pickImage,
                              child: const Icon(IconlyLight.camera),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: firstName,
                        decoration: const InputDecoration(
                            labelText: 'Nhập họ',
                            labelStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.zero),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Nhập họ';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: lastName,
                        decoration: const InputDecoration(
                            labelText: 'Nhập tên ',
                            labelStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.zero),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Nhập tên';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                  controller: mobile,
                  enabled: false,
                  decoration: const InputDecoration(
                      labelText: 'Số Điện Thoại',
                      labelStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.zero),
                ),
                const SizedBox(
                  height: 40, // Remove this SizedBox
                ),
                TextFormField(
                  controller: email,
                  decoration: const InputDecoration(
                      labelText: 'Tài khoản email ',
                      labelStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.zero),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nhập Email';
                    }
                    return null;
                  },
                ),
              ],
            )),
      ),
    );
  }
}
