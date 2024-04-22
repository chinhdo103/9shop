import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:project_9shop/screen/edit_profile_screen.dart';
import 'package:project_9shop/screen/on_boarding_screen.dart';
import 'package:project_9shop/provider/auth_provider.dart' as MyAppProvider;
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  static const String id = 'account-screen';
  final bool isLoggedIn;

  const AccountScreen({required this.isLoggedIn, super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffffffff),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            height: 35,
          ),
          widget.isLoggedIn ? userTitle() : userTitlenotLogin(),
          divider(),
          colorTitles(),
          divider(),
          bwTitle(),
        ],
      ),
    );
  }

  Widget userTitle() {
    final auth = Provider.of<MyAppProvider.AuthProvider>(context);

    // Assuming you have a method to get the current user ID from the AuthProvider
    String userId = auth.getCurrentUserUid(); // Replace with your method
    print('User ID: $userId'); // Add this line

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('TaiKhoanNguoiDung')
          .doc(userId)
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading state if the data is still loading
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          // Return an error state if there's an error
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          // Return a default state if the document does not exist
          return ListTile(
            title: Text('User not found'),
          );
        }

        // Retrieve user data from the document snapshot
        Map<String, dynamic> userData =
            snapshot.data!.data() as Map<String, dynamic>;
        String displayName = userData['hovaten'] ?? '';
        String profileImageUrl = userData['hinhanh'] ?? '';

        print('Display Name: $displayName'); // Add this line
        print('Profile Image URL: $profileImageUrl'); // Add this line

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(profileImageUrl),
          ),
          title: Text(
            displayName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Tài khoản khách hàng"),
        );
      },
    );
  }

  Widget divider() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Divider(
        thickness: 1.5,
      ),
    );
  }

  Widget userTitlenotLogin() {
    String url =
        "https://i.pinimg.com/originals/17/07/46/17074670b1d2d663fe3521a03f40c37c.gif";
    return InkWell(
      onTap: () {},
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(url),
        ),
        title: const Text(
          "Bạn chưa đăng nhập tài khoản",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text("Ấn vào để đăng nhập"),
      ),
    );
  }

  Widget colorTitles() {
    return Column(
      children: [
        colorTitle(
            Icons.person_outline, Colors.deepPurple, "Quản lý thông tin"),
        colorTitle(IconlyLight.bag, Colors.blue, "Đơn hàng đã đặt"),
        colorTitle(IconlyLight.heart, Colors.yellow, "Sản phẩm yêu thích"),
        colorTitle(IconlyLight.password, Colors.red, "Đổi mật khẩu"),
        colorTitle(Icons.remove_red_eye, Colors.teal, "Sản phẩm vừa xem"),
      ],
    );
  }

  Widget bwTitle() {
    final auth = Provider.of<MyAppProvider.AuthProvider>(context);

    return Column(
      children: [
        InkWell(
            onTap: () async {
              final auth = Provider.of<MyAppProvider.AuthProvider>(context,
                  listen: false);

              // Assuming you have a method to get the current user ID from the AuthProvider
              String userId =
                  auth.getCurrentUserUid(); // Replace with your method

              // Fetch user data
              DocumentSnapshot snapshot = await FirebaseFirestore.instance
                  .collection('TaiKhoanNguoiDung')
                  .doc(userId)
                  .get();

              if (snapshot.exists) {
                Map<String, dynamic> userData =
                    snapshot.data() as Map<String, dynamic>;
                // ignore: unused_local_variable
                String matk = userData['id'] ?? '';

                // Navigate to EditProfileScreen with user ID
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                    context, EditProfileScreen.id as Route<Object?>);
              }
            },
            child: colorTitle(Icons.help_outline, Colors.black, "Hỏi - Đáp")),
        colorTitle(IconlyLight.setting, Colors.black, "Phiên bản ứng dụng"),
        colorTitle(Icons.call, Colors.black, "Hotline"),
        InkWell(
            onTap: () {
              auth.error = '';
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OnBoardingScreen()),
                  (route) => false,
                );
              });
            },
            child: colorTitle(Icons.logout, Colors.black, "Đăng xuất")),
      ],
    );
  }

  Widget colorTitle(IconData icon, Color color, String text) {
    return ListTile(
      leading: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            color: color.withOpacity(0.09),
            borderRadius: BorderRadius.circular(18)),
        child: Icon(
          icon,
          color: color,
        ),
      ),
      title: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.black,
        size: 20,
      ),
    );
  }
}
