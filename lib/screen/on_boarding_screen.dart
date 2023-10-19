import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_9shop/screen/main_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});
  static const String id = 'onboarding-screen';
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  //id tham chiếu của screen
  double scrollerPosition = 0;
  final store = GetStorage();

  onButtonPressed(context) {
    store.write('onBoarding', true);
    return Navigator.pushReplacementNamed(context, MainScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (val) {
              setState(() {
                scrollerPosition = val.toDouble();
              });
            },
            children: [
              OnBoardPage(
                boardColumn: Column(
                  mainAxisSize: MainAxisSize
                      .min, //thu gọn kích thước theo chiều dọc sao cho phù hợp với kích thước
                  children: [
                    const Text(
                      'Chào mừng \n Bạn đến với 9Shop',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Siêu thị phụ tùng \n Xe máy chính hãng',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        height: 300,
                        width: 300,
                        child: Image.asset('assets/images/onboarding-3.png'))
                  ],
                ),
              ),
              OnBoardPage(
                boardColumn: Column(
                  mainAxisSize: MainAxisSize
                      .min, //thu gọn kích thước theo chiều dọc sao cho phù hợp với kích thước
                  children: [
                    const Text(
                      'Đa dạng - Chất lượng',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Đa dạng sản phẩm \n Tha hồ lựa chọn',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        height: 300,
                        width: 300,
                        child: Image.asset('assets/images/onboarding-1.png'))
                  ],
                ),
              ),
              OnBoardPage(
                boardColumn: Column(
                  mainAxisSize: MainAxisSize
                      .min, //thu gọn kích thước theo chiều dọc sao cho phù hợp với kích thước
                  children: [
                    const Text(
                      'Giao hàng nhanh chóng',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Nội thành giao nhanh 2H',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        height: 300,
                        width: 300,
                        child: Image.asset('assets/images/onboarding-2.png'))
                  ],
                ),
              ),
              OnBoardPage(
                boardColumn: Column(
                  mainAxisSize: MainAxisSize
                      .min, //thu gọn kích thước theo chiều dọc sao cho phù hợp với kích thước
                  children: [
                    const Text(
                      'Đổi Trả Miễn Phí',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Đổi trả hàng hoá 48H',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        height: 300,
                        width: 300,
                        child: Image.asset('assets/images/onboarding-5.png'))
                  ],
                ),
              ),
              OnBoardPage(
                boardColumn: Column(
                  mainAxisSize: MainAxisSize
                      .min, //thu gọn kích thước theo chiều dọc sao cho phù hợp với kích thước
                  children: [
                    const Text(
                      'Bảo mật thông tin',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Thanh toán an toàn',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        height: 300,
                        width: 300,
                        child: Image.asset('assets/images/onboarding-6.png'))
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DotsIndicator(
                  dotsCount: 5,
                  position: scrollerPosition,
                  decorator: const DotsDecorator(
                      activeColor: Colors.white, color: Colors.yellow),
                ),
                scrollerPosition == 4
                    ? Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                            child: const Text(
                              'Bắt đầu mua sắm',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 45, 197, 146),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17),
                            ),
                            onPressed: () {
                              onButtonPressed(context);
                            }),
                      )
                    : TextButton(
                        onPressed: () {
                          onButtonPressed(context);
                        },
                        child: const Text(
                          'BỎ QUA ĐỂ VÀO ỨNG DỤNG >>',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//1 trang trong onboarding-screen
class OnBoardPage extends StatelessWidget {
  final Column? boardColumn;

  const OnBoardPage({Key? key, this.boardColumn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Center(child: boardColumn),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: MediaQuery.of(context).size.width, //chiều rộng màn hình
            height: 120,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 45, 197, 146),
              // borderRadius: const BorderRadius.only(
              //     topLeft: Radius.circular(100),
              //     topRight: Radius.circular(100)),
            ),
          ),
        ),
      ],
    );
  }
}
