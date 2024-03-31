import 'package:flutter/material.dart';
import 'package:slot_seek/app_colors.dart';

void main() {
  runApp(const MaterialApp(
    home: CurvedRoadWithParking(),
  ));
}

class CurvedRoadWithParking extends StatelessWidget {
  const CurvedRoadWithParking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Curved Road with Parking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SizedBox(
            height: double.infinity,
            width: 400,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:const  [
                    ParkingSlot(),
                    ParkingSlot(),
                    ParkingSlot(),
                    ParkingSlot(),
                    ParkingSlot(),
                    ParkingSlot(),
                    ParkingSlot(),
                    ParkingSlot(),
                    ParkingSlot(),
                  ],
                ),
                const CurvedRoad(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:const  [
                    ParkingSlot(),
                    ParkingSlot(),
                    ParkingSlot(),
                    ParkingSlot(),
                    ParkingSlot(),
                    ParkingSlot(),
                    ParkingSlot(),
                    ParkingSlot(),
                    ParkingSlot(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CurvedRoad extends StatelessWidget {
  const CurvedRoad({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: double.infinity,
      child: CustomPaint(
        painter: CurvedRoadPainter(),
      ),
    );
  }
}

class CurvedRoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = AppColors.greyLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    var path = Path();
    path.moveTo(size.width / 2, 0);
    path.quadraticBezierTo(
        size.width / 4, size.height / 4, size.width / 2, size.height / 2);
    path.quadraticBezierTo(
        size.width * 3 / 4, size.height * 3 / 4, size.width / 2, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ParkingSlot extends StatelessWidget {
  const ParkingSlot({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 50,
      child: CustomPaint(
        painter: ParkingSlotPainter(),
      ),
    );
  }
}


class ParkingSlotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.blueGrey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawLine(
        Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
