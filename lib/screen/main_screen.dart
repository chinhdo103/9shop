// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_9shop/screen/accout_screen.dart';
import 'package:project_9shop/screen/cart_screen.dart';
import 'package:project_9shop/screen/home_screen.dart';
import 'package:project_9shop/screen/message_screen.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const String id = 'main-screen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  // ignore: unused_field
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    MessageScreen(),
    CartScreen(),
    AccountScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 4,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: //(icon đàu là icon lúc ấn - icon sau lúc nhả)
                Icon(_selectedIndex == 0 ? IconlyBold.home : IconlyLight.home),
            label: 'Trang Chủ',
          ),
          BottomNavigationBarItem(
            icon:
                Icon(_selectedIndex == 1 ? IconlyBold.chat : IconlyLight.chat),
            label: 'Tin Nhắn',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 2 ? IconlyBold.buy : IconlyLight.buy),
            label: 'Giỏ Hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(
                _selectedIndex == 3 ? IconlyBold.profile : IconlyLight.profile),
            label: 'Tài Khoản',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue.shade900,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
