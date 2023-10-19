import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_9shop/screen/main_screen.dart';
import 'package:project_9shop/screen/on_boarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        OnBoardingScreen.id: (context) => const OnBoardingScreen(),
        MainScreen.id: (context) => const MainScreen(),
      },
    );
  }
}

// 1 - code splash-screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String id = 'splash-screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final store = GetStorage();
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      //lần đầu khi mở app, app sẽ kiểm trả xem người dùng đã thấy onboard
      // screen rồi hay chưa
      //đọc getstore để thực hiện diều đó
      // ignore: no_leading_underscores_for_local_identifiers
      bool? _boarding = store.read('onBoarding');
      _boarding == null
          ? Navigator.pushReplacementNamed(context, OnBoardingScreen.id)
          : _boarding == true
              ? Navigator.pushReplacementNamed(context, MainScreen.id)
              :
              //if false
              Navigator.pushReplacementNamed(context, OnBoardingScreen.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: []); //hiển thị ứng dụng ở chế độ toàn màn hình
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/images/9Shop-logo.png'),
      ),
    );
  }
}
