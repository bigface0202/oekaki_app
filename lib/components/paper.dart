import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oekaki_app/models/icon_model.dart';
import 'package:provider/provider.dart';
import '../models/pen_model.dart';
import '../models/strokes_model.dart';

class Paper extends StatelessWidget {
  final image;
  final width;
  final height;

  Paper(this.image, this.width, this.height);
  @override
  Widget build(BuildContext context) {
    final Size displaySize = MediaQuery.of(context).size;
    final pen = Provider.of<PenModel>(context);
    final strokes = Provider.of<StrokesModel>(context);
    final iconProv = Provider.of<IconModel>(context);

    return Listener(
      // onPointerDownは画面に指が触れた時にコールされる
      onPointerDown: (details) {
        if (details.position.dy < height) {
          strokes.add(pen, details.position, iconProv);
        }
      },
      // タッチでお絵かきしたいときは以下を使う
      // onPointerMove: (details) {
      //   strokes.update(details.position);
      // },
      // onPointerUp: (details) {
      //   strokes.update(details.position);
      // },
      child: FittedBox(
        child: SizedBox(
          width: image.width.toDouble(),
          height: image.height.toDouble(),
          child: CustomPaint(
            painter: _Painter(image, strokes, displaySize),
            child: ConstrainedBox(
              constraints: BoxConstraints.expand(),
            ),
          ),
        ),
      ),
    );
  }
}

class _Painter extends CustomPainter {
  final StrokesModel strokes;
  final ui.Image _image;
  final Size _displaySize;

  _Painter(this._image, this.strokes, this._displaySize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    canvas.drawImage(_image, Offset(0, 0), paint);
    strokes.all.forEach((stroke) {
      final icon = stroke.icon;
      final textStyle = ui.TextStyle(
        fontFamily: icon.fontFamily,
        color: stroke.color,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      );
      var builder = ui.ParagraphBuilder(ui.ParagraphStyle())
        ..pushStyle(textStyle)
        ..addText(String.fromCharCode(icon.codePoint));
      var para = builder.build();
      para.layout(const ui.ParagraphConstraints(width: 60));
      // final paint = Paint()
      //   ..color = stroke.color
      //   ..strokeCap = StrokeCap.round
      //   ..strokeWidth = 3;
      // canvas.drawPoints(ui.PointMode.polygon, stroke.points, paint);
      // canvas.drawParagraph(para, stroke.points[0]);
      canvas.drawParagraph(
          para,
          Offset(stroke.points[0].dx * size.width / _displaySize.width,
              stroke.points[0].dy * size.width / _displaySize.width));
      // print('Width:${size.width}');
      // print('Height:${size.height}');
      // print('Display Width:${_displaySize.width}');
      // print('Display Height:${_displaySize.height}');
      // print('Touched x: ${stroke.points[0].dx}');
      // print('Touched y: ${stroke.points[0].dy}');
      // print(stroke.points[0].dx * size.width / _displaySize.width);
      // print(stroke.points[0].dy * size.height / _displaySize.height);
    });
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) {
    return true;
  }
}
