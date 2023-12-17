import 'dart:math';
import 'package:flutter/material.dart';

class WheelOfFortune extends StatefulWidget {
  static const String id = 'WheelOfFortune';
  @override
  _WheelOfFortuneState createState() => _WheelOfFortuneState();
}

class _WheelOfFortuneState extends State<WheelOfFortune>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final List<int> pointValues = [10, 20, 30, 40, 50, 60];

  @override
  void initState() {
    super.initState();

    // Tạo AnimationController với thời gian quay là 3 giây
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    // Tạo Tween cho Animation từ 0 đến 2*pi (một vòng tròn)
    _animation = Tween(begin: 0.0, end: 2 * pi).animate(_controller)
      ..addListener(() {
        setState(() {
          // Làm mới UI mỗi khi giá trị animation thay đổi
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vòng Quay Thưởng'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            _controller.reset();
            _controller.forward();
          },
          child: CustomPaint(
            painter: WheelPainter(_animation.value, pointValues),
            size: Size(200, 200),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class WheelPainter extends CustomPainter {
  final double rotation;
  final List<int> pointValues;

  WheelPainter(this.rotation, this.pointValues);

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;

    // Vẽ vòng tròn
    Paint wheelPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(radius, radius), radius, wheelPaint);

    // Vẽ số điểm xung quanh
    TextPainter tp = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final double labelRadius = radius - 20; // Bán kính để vẽ số điểm

    for (int i = 0; i < pointValues.length; i++) {
      double angle = (2 * pi / pointValues.length) * i - pi / 2 + rotation;
      double x = radius + labelRadius * cos(angle);
      double y = radius + labelRadius * sin(angle);

      canvas.drawCircle(Offset(x, y), 20, wheelPaint);

      TextSpan span = TextSpan(
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        text: pointValues[i].toString(),
      );
      tp.text = span;
      tp.layout();
      tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

void main() {
  runApp(MaterialApp(home: WheelOfFortune()));
}
