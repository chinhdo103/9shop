import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:project_9shop/widgets/banner_widget.dart';
import 'package:project_9shop/widgets/brand_highlights.dart';
import 'package:project_9shop/widgets/category_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue.shade900,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: AppBar(
            backgroundColor: Colors.blue.shade900,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              '9Shop',
              style: TextStyle(letterSpacing: 2),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(IconlyLight.buy))
            ],
          ),
        ),
        //listview thực hiện việc scroll màn hình với nhóm các widgets
        body: ListView(
          children: const [
            SearchWidget(),
            SizedBox(height: 10),
            BannerWidget(),
            BrandHighLights(),
            CategoryWidget(),

            //một số sản phẩm sẽ hiển thị sau đây
          ],
        ));
  }
}

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 64,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const TextField(
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(8, 15, 8, 0),
                        hintText: 'Tìm kiếm sản phẩm',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 20,
                          color: Colors.grey,
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
          width: MediaQuery.of(context).size.width,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Icon(
                    IconlyLight.infoSquare,
                    size: 12,
                    color: Colors.white,
                  ),
                  Text(
                    '100% Chính Hãng',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    IconlyLight.infoSquare,
                    size: 12,
                    color: Colors.white,
                  ),
                  Text(
                    'Hoàn Trả Trong 48H',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    IconlyLight.infoSquare,
                    size: 12,
                    color: Colors.white,
                  ),
                  Text(
                    'Giao Hàng Miễn Phí',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
