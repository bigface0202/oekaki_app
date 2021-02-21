import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../screens/paper_screen.dart';

class IndexScreen extends StatefulWidget {
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  final picker = ImagePicker();

  ui.Image image;

  Future<void> _takePicture() async {
    final imageFile = await picker.getImage(
      source: ImageSource.camera,
    );
    if (imageFile == null) {
      return;
    }
    final imageByte = await imageFile.readAsBytes();
    image = await decodeImageFromList(imageByte);
    Navigator.of(context).pushNamed(PaperScreen.routeName, arguments: image);
  }

  Future<void> _getImageFromGallery(BuildContext context) async {
    final imageFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (imageFile == null) {
      return;
    }
    final imageByte = await imageFile.readAsBytes();
    image = await decodeImageFromList(imageByte);
    Navigator.of(context).pushNamed(PaperScreen.routeName, arguments: image);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            RaisedButton.icon(
              icon: Icon(
                Icons.photo_camera,
                color: Colors.white,
              ),
              color: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              label: Text(
                'カメラ',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              textColor: Theme.of(context).primaryColor,
              onPressed: _takePicture,
            ),
            RaisedButton.icon(
              icon: Icon(
                Icons.photo_library,
                color: Colors.white,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.blueAccent,
              label: Text(
                'ギャラリー',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              textColor: Theme.of(context).primaryColor,
              onPressed: () => _getImageFromGallery(context),
            ),
          ],
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final ui.Image image;
  CirclePainter(this.image);

  @override
  void paint(ui.Canvas canvas, Size size) {
    final paint = Paint();
    if (image != null) {
      canvas.drawImage(image, Offset(0, 0), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CirclePainter oldDelegate) => false;
  // image != oldDelegate.image || params != oldDelegate.params;
}
