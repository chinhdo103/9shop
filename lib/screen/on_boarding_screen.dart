import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_9shop/provider/auth_provider.dart';
import 'package:project_9shop/provider/location_provider.dart';
import 'package:project_9shop/screen/main_screen.dart';
import 'package:provider/provider.dart';

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
    final auth = Provider.of<AuthProvider>(context);

    // ignore: no_leading_underscores_for_local_identifiers
    bool _validPhoneNumber = false;
    // ignore: no_leading_underscores_for_local_identifiers
    var _phonenumberController = TextEditingController();

    void showBottomSheet(context) {
      showModalBottomSheet(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, StateSetter myState) {
          return SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible:
                        auth.error == 'Mã OTP không tồn tại' ? true : false,
                    child: SizedBox(
                      child: Column(
                        children: [
                          Text(
                            '${auth.error} Thử lại',
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Text(
                    'Đăng Nhập',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Nhập số điện thoại để tiếp tục',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _phonenumberController,
                    decoration: const InputDecoration(
                      prefixText: '+84  ',
                      labelText: 'Số điện thoại đủ 10 số',
                    ),
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    onChanged: (value) {
                      if (value.length == 10) {
                        myState(() {
                          _validPhoneNumber = true;
                        });
                      } else {
                        _validPhoneNumber = false;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AbsorbPointer(
                          absorbing: _validPhoneNumber ? false : true,
                          child: TextButton(
                              onPressed: () {
                                myState(() {
                                  auth.loading = true;
                                });
                                String sdt =
                                    '+84${_phonenumberController.text}';
                                auth
                                    .verifyPhone(
                                  context: context,
                                  sdt: sdt,
                                )
                                    .then((value) {
                                  _phonenumberController.clear();
                                });
                              },
                              style: _validPhoneNumber
                                  ? ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.blue.shade400),
                                    )
                                  : ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.grey),
                                    ),
                              child: auth.loading
                                  ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    )
                                  : Text(
                                      _validPhoneNumber
                                          ? 'Tiếp tục'
                                          : 'Nhập số điện thoại',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }),
      );
    }

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
                              showBottomSheet(context);
                              // onButtonPressed(context);
                            }),
                      )
                    : TextButton(
                        onPressed: () {
                          setState(() {
                            scrollerPosition = 4;
                          });
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
