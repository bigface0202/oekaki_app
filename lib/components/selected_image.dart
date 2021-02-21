import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class SelectedImage extends StatelessWidget {
  final image;
  SelectedImage(this.image);
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: SizedBox(
        width: image.width.toDouble(),
        height: image.height.toDouble(),
        child: CustomPaint(
          painter: ImagePainter(image),
        ),
      ),
    );
  }
}

class ImagePainter extends CustomPainter {
  final ui.Image image;
  ImagePainter(this.image);

  @override
  void paint(ui.Canvas canvas, Size size) {
    final paint = Paint();
    if (image != null) {
      canvas.drawImage(image, Offset(0, 0), paint);
    }
  }

  @override
  bool shouldRepaint(covariant ImagePainter oldDelegate) => false;
  // image != oldDelegate.image || params != oldDelegate.params;
}
