// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_9shop/screen/category_screen.dart';
import 'package:project_9shop/screen/chatbot/chat_bot_screen.dart';
import 'package:project_9shop/screen/home_screen.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:project_9shop/screen/my_orders_screen.dart';
import 'package:project_9shop/screen/profile_screen.dart';
import 'package:project_9shop/widgets/cart/cart_notification.dart';

class MainScreen extends StatefulWidget {
  final int? index;

  const MainScreen({this.index, Key? key}) : super(key: key);

  static const String id = 'main-screen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    CategoryScreen(),
    MyOrdersScreen(),
    ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    if (widget.index != null) {
      setState(() {
        _selectedIndex = widget.index!;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton.extended(
              backgroundColor: Colors.blue.shade900,
              elevation: 3,
              icon: const Icon(
                Icons.chat,
                size: 12,
                color: Colors.white,
              ),
              label: const Text(
                "Hỗ trợ",
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChatBotScreen()));
              },
            ),
            const SizedBox(
              height: 5,
            ),
            const CartNotification(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: BottomNavigationBar(
          elevation: 4,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 0 ? IconlyBold.home : IconlyLight.home,
              ),
              label: 'Trang Chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 1
                    ? IconlyBold.category
                    : IconlyLight.category,
              ),
              label: 'Danh Mục',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 3 ? IconlyBold.bag : IconlyLight.bag,
              ),
              label: 'Đơn Hàng',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 4 ? IconlyBold.profile : IconlyLight.profile,
              ),
              label: 'Tài Khoản',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue.shade900,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
        ),
      ),
    );
  }
}
