import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';
import 'package:project_9shop/services/firebase_service.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:project_9shop/provider/location_provider.dart';
import 'package:project_9shop/screen/map_screen.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  static const String id = 'edit-profile-screen';

  final String matk;
  const EditProfileScreen({super.key, required this.matk});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  dynamic image;
  String? fileName;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _hovatenController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _sdtController = TextEditingController();
  final TextEditingController _diachiController = TextEditingController();
  FirebaseService _service = FirebaseService();
  @override
  void initState() {
    super.initState();
    _loadUserInfo(widget.matk);
  }

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

  Future<void> _updateUserInfo() async {
    try {
      String userId = widget.matk;
      if (_emailController.text.trim().isEmpty ||
          _hovatenController.text.trim().isEmpty ||
          _sdtController.text.trim().isEmpty ||
          _diachiController.text.trim().isEmpty) {
        // Display a toast message for empty fields
        Fluttertoast.showToast(
          msg: 'Không được để trống các thông tin',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return;
      }
      if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
          .hasMatch(_emailController.text.trim())) {
        // Display a toast message for invalid email format
        Fluttertoast.showToast(
          msg: 'Email không hợp lệ',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return;
      }

      // Check if an image is selected
      if (image == null || !(image is File)) {
        // Display a toast message for not selecting a valid image
        Fluttertoast.showToast(
          msg: 'Vui lòng chọn ảnh',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return;
      }

      // Upload image to Firebase Storage
      String fileName = 'userImage/${DateTime.now().millisecondsSinceEpoch}';
      var ref = firebase_storage.FirebaseStorage.instance.ref(fileName);
      String? mimeType = mime(basename(fileName)) ?? 'image/jpeg';
      print('MIME Type: $mimeType');

      var metaData = firebase_storage.SettableMetadata(contentType: mimeType);
      firebase_storage.TaskSnapshot uploadSnapshot =
          await ref.putData((image as File).readAsBytesSync(), metaData);
      String downloadURL = await uploadSnapshot.ref.getDownloadURL();

      // Update user information in Firestore with the downloadURL of the uploaded image
      await _service.taikhoannguoidung.doc(userId).update({
        'hovaten': _hovatenController.text.trim(),
        'email': _emailController.text.trim(),
        'sdt': _sdtController.text.trim(),
        'diachi': _diachiController.text.trim(),
        'hinhanh': downloadURL,
        // Add other fields as needed
      });

      // Display a success message or perform any other actions
      Fluttertoast.showToast(
        msg: "Cập nhật thông tin thành công",
        toastLength: Toast.LENGTH_SHORT,
        webPosition: "center",
        webShowClose: false,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      // Navigate back to the main screen
    } catch (e) {
      print('Failed to update user info: $e');
      // Handle failure here
    }
  }

  Future<void> _loadUserInfo(String id) async {
    try {
      // Retrieve user information from Firestore
      DocumentSnapshot userSnapshot =
          await _service.taikhoannguoidung.doc(id).get();

      // Check if the user exists
      if (userSnapshot.exists) {
        // Extract user data
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        // Set the text of the controllers
        _sdtController.text = userData['sdt']; // Use '=' for assignment
        _diachiController.text = userData['diachi'];
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Failed to load user info: $e');
      // Handle failure here
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context, listen: false);

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Thông tin tài khoan"),
        ),
        body: SingleChildScrollView(
          child: Center(
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
                                : Image.asset(
                                    'assets/images/9Shop-logo.png',
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
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    controller: _hovatenController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20),
                      prefixIcon: const Icon(
                        IconlyLight.user2,
                        size: 22,
                      ),
                      hintText: 'Tên khách hàng',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20),
                      prefixIcon: const Icon(
                        Icons.mail,
                        size: 22,
                      ),
                      hintText: 'Tài Khoản Email',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    enabled: false,
                    controller: _sdtController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(
                          10), // Limit to 10 digits
                    ],
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20),
                      prefixIcon: const Icon(
                        IconlyLight.call,
                        size: 22,
                      ),
                      hintText: 'Số điện thoại',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    controller: _diachiController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20),
                      prefixIcon: const Icon(
                        IconlyLight.location,
                        size: 22,
                      ),
                      hintText: 'Địa chỉ cụ thể',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        borderSide: BorderSide.none,
                      ),
                      // Add the suffixIcon property for the location icon button
                      suffixIcon: IconButton(
                        icon: locationData.loading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white))
                            : const Icon(
                                Icons.location_on,
                                color: Colors.blue,
                              ),
                        onPressed: () async {
                          setState(() {
                            locationData.loading = true;
                          });
                          await locationData.getCurrentPostion();
                          if (locationData.permissionAllowed == true) {
                            // ignore: use_build_context_synchronously
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const MapScreen(),
                              ),
                            );
                            setState(() {
                              locationData.loading = false;
                            });
                          } else {
                            print('Không cho phép');
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(20)),
                      iconColor: MaterialStateProperty.all<Color>(Colors.black),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.blue.shade500),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      _updateUserInfo();
                    },
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            "Cập Nhật Thông Tin",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
