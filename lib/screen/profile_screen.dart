import 'package:firebase_auth/firebase_auth.dart' as FBauth;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:project_9shop/provider/auth_provider.dart';
import 'package:project_9shop/provider/location_provider.dart';
import 'package:project_9shop/screen/coupon_all_screen.dart';
import 'package:project_9shop/screen/map_screen.dart';
import 'package:project_9shop/screen/my_orders_screen.dart';
import 'package:project_9shop/screen/on_boarding_screen.dart';
import 'package:project_9shop/screen/prize_wheel.dart';
import 'package:project_9shop/screen/profile_update_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  static const String id = 'profile-screen';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<AuthProvider>(context);
    var locationData = Provider.of<LocationProvider>(context);

    FBauth.User? user = FBauth.FirebaseAuth.instance.currentUser;
    userDetails.getUserDetails();
    var userDetailsData = userDetails.snapshot?.data() as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.blue.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Quản lí tài khoản',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Stack(
              children: [
                Container(
                  color: Colors.blue.shade900,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: ClipOval(
                                child: userDetailsData?['hinhanh'] != null
                                    ? Image.network(
                                        userDetailsData?['hinhanh'],
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      )
                                    : const Center(
                                        child: Text(
                                          'Cập nhật ảnh',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              height: 70,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    userDetailsData?['Ho'] != null
                                        ? '${userDetailsData?['Ho']} ${userDetailsData?['Ten']}'
                                        : 'Cập nhật tên của bạn',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                  if (userDetailsData?['email'] != null)
                                    Text(
                                      '${userDetailsData?['email']}',
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  Text(
                                    user?.phoneNumber ?? '',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (userDetails.snapshot != null)
                          Material(
                            color: Colors.white,
                            child: ListTile(
                              title: Text(userDetailsData?['diachi'] ?? ''),
                              trailing: SizedBox(
                                width: 120,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: Colors.redAccent)),
                                  onPressed: () {
                                    EasyLoading.show(status: 'Đang tải...');
                                    locationData
                                        .getCurrentPostion()
                                        .then((value) {
                                      EasyLoading.dismiss();
                                      PersistentNavBarNavigator
                                          .pushNewScreenWithRouteSettings(
                                        context,
                                        screen: const MapScreen(),
                                        withNavBar: false,
                                        settings: const RouteSettings(
                                            name: MapScreen.id),
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.cupertino,
                                      );
                                    }).catchError((error) {
                                      EasyLoading.dismiss();
                                      // Handle the error here
                                      print(
                                          'Error getting current position: $error');
                                    });
                                  },
                                  child: const Text(
                                    'Thay đổi',
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ),
                              ),
                              leading: const Icon(
                                Icons.location_on,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  child: IconButton(
                    onPressed: () {
                      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                          context,
                          screen: const ProfileUpdateScreen(),
                          withNavBar: false,
                          settings:
                              const RouteSettings(name: ProfileUpdateScreen.id),
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino);
                    },
                    icon: const Icon(Icons.edit_outlined, color: Colors.white),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    screen: const MyOrdersScreen(),
                    settings: const RouteSettings(name: MyOrdersScreen.id),
                    pageTransitionAnimation: PageTransitionAnimation.cupertino);
              },
              child: const ListTile(
                leading: Icon(Icons.history),
                title: Text('Đơn hàng đã đặt'),
                horizontalTitleGap: 2,
              ),
            ),
            const Divider(),
            InkWell(
              onTap: () {
                PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    screen: const CouponAllScreen(),
                    settings: const RouteSettings(name: CouponAllScreen.id),
                    pageTransitionAnimation: PageTransitionAnimation.cupertino);
              },
              child: const ListTile(
                leading: Icon(Icons.comment_outlined),
                title: Text('Mã giảm giá của cửa hàng'),
                horizontalTitleGap: 2,
              ),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.notifications_none),
              title: Text('Thông báo'),
              horizontalTitleGap: 2,
            ),
            const Divider(),
            InkWell(
              onTap: () {
                PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    screen: WheelOfFortune(),
                    settings: const RouteSettings(name: WheelOfFortune.id),
                    pageTransitionAnimation: PageTransitionAnimation.cupertino);
              },
              child: const ListTile(
                leading: Icon(Icons.notifications_none),
                title: Text('Quay thưởng'),
                horizontalTitleGap: 2,
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Đăng xuất'),
              horizontalTitleGap: 2,
              onTap: () {
                FBauth.FirebaseAuth.instance.signOut();
                PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    screen: const OnBoardingScreen(),
                    settings: const RouteSettings(name: OnBoardingScreen.id),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino);
              },
            ),
          ],
        ),
      ),
    );
  }
}
