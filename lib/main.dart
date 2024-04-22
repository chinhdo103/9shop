import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
// ignore: library_prefixes
import 'package:project_9shop/provider/auth_provider.dart' as MyAppAuthProvider;
import 'package:project_9shop/provider/cart_provider.dart';
import 'package:project_9shop/provider/coupon_provider.dart';
import 'package:project_9shop/provider/location_provider.dart';
import 'package:project_9shop/provider/order_provider.dart';
import 'package:project_9shop/provider/product_provider.dart';
import 'package:project_9shop/provider/store_provider.dart';
import 'package:project_9shop/screen/cart_screen.dart';
import 'package:project_9shop/screen/chatbot/chat_bot_screen.dart';
import 'package:project_9shop/screen/edit_profile_screen.dart';
import 'package:project_9shop/screen/login_screen.dart';
import 'package:project_9shop/screen/main_screen.dart';
import 'package:project_9shop/screen/map_screen.dart';
import 'package:project_9shop/screen/my_orders_screen.dart';
import 'package:project_9shop/screen/on_boarding_screen.dart';
import 'package:project_9shop/screen/prize_wheel.dart';
import 'package:project_9shop/screen/product_details_screen.dart';
import 'package:project_9shop/screen/product_list_screen.dart';
import 'package:project_9shop/screen/profile_screen.dart';
import 'package:project_9shop/screen/profile_update_screen.dart';
import 'package:project_9shop/screen/save_product_screen.dart';
import 'package:project_9shop/screen/success_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(
      'vi'); // Initialize date formatting for Vietnamese locale

  await Firebase.initializeApp();
  await GetStorage.init();
  Stripe.publishableKey =
      "pk_test_51OOBpeJHlO4ZZ6TKBGGx3CgOE0uYWrtpmy25fLj2hHx1NrE4rc6qXEEKqPz4yE3yqqe28N0OHYY9pTCJ63mZwrzG00BJxjnn8G";
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MyAppAuthProvider.AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => StoreProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CouponProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
        ProfileScreen.id: (context) => const ProfileScreen(),
        SuccessScreen.id: (context) => const SuccessScreen(),

        OnBoardingScreen.id: (context) => const OnBoardingScreen(),
        MainScreen.id: (context) => const MainScreen(),
        MapScreen.id: (context) => const MapScreen(),
        WheelOfFortune.id: (context) => WheelOfFortune(),
        ProfileUpdateScreen.id: (context) => const ProfileUpdateScreen(),
        ChatBotScreen.id: (context) => const ChatBotScreen(),
        SaveProductScreen.id: (context) => const SaveProductScreen(
              favoriteProducts: [],
            ),

        // StripHome.id: (context) => const StripHome(),
        CartScreen.id: (context) => const CartScreen(
              document: null,
            ),
        MyOrdersScreen.id: (context) => const MyOrdersScreen(),
        ProductListScreen.id: (context) => const ProductListScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        EditProfileScreen.id: (context) => const EditProfileScreen(
              matk: '',
            ),
        ProductDetailsScreen.id: (context) =>
            ProductDetailsScreen(document: '' as DocumentSnapshot),
      },
      builder: EasyLoading.init(),
    );
  }
}

// 1 - code splash-screen
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
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const OnBoardingScreen()));
        } else {
          {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const MainScreen()));
          }
        }
      });
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
