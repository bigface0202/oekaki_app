import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../components/palette.dart';
import '../components/paper.dart';
import '../components/icon_pallete.dart';
import '../models/strokes_model.dart';

class PaperScreen extends StatelessWidget {
  static const routeName = '/paper-scren';
  @override
  Widget build(BuildContext context) {
    final image = ModalRoute.of(context).settings.arguments as ui.Image;
    final strokes = Provider.of<StrokesModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('お絵描きApp'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {},
            color: Colors.white,
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          // Align(
          //   alignment: Alignment.center,
          //   child: SelectedImage(image),
          // ),
          Paper(image, image.width, image.height),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Palette(),
              IconPalette(),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('削除します'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () {
                      strokes.clear();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
