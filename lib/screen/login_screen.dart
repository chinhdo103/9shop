import 'package:flutter/material.dart';
import 'package:project_9shop/provider/auth_provider.dart';
import 'package:project_9shop/provider/location_provider.dart';
import 'package:project_9shop/screen/home_screen.dart';
import 'package:project_9shop/screen/main_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _validPhoneNumber = false;
  var _phonenumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: auth.error == 'Mã OTP không tồn tại' ? true : false,
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          '${auth.error} Thử lại',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                        SizedBox(
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
                      setState(() {
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
                              setState(() {
                                auth.loading = true;
                              });
                              String sdt = '+84${_phonenumberController.text}';
                              auth
                                  .verifyPhone(
                                context: context,
                                sdt: sdt,
                              )
                                  .then((value) {
                                _phonenumberController.clear();
                                setState(() {
                                  auth.loading = false;
                                });
                              });

                              // Navigate to MainScreen only if OTP verification was successful
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const MainScreen(),
                                ),
                              );

                              // Handle OTP verification failure if needed
                              // Display an error message or take appropriate action
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
                                    style: const TextStyle(color: Colors.white),
                                  )),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
