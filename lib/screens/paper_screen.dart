import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../components/palette.dart';
import '../components/paper.dart';
import '../components/icon_pallete.dart';
import '../models/strokes_model.dart';

class PaperScreen extends StatefulWidget {
  static const routeName = '/paper-scren';

  @override
  _PaperScreenState createState() => _PaperScreenState();
}

class _PaperScreenState extends State<PaperScreen> {
  // キャプチャしたいWidgetを取得するためのキー
  GlobalKey _keyEditedImage = GlobalKey();
  // 編集した画像を表示する用
  Uint8List _editedImage64;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
    // _toastInfo(info);
  }

  void _exportToImage() async {
    // 現在描画されているWidgetを取得
    RenderRepaintBoundary boundary =
        _keyEditedImage.currentContext.findRenderObject();

    // 取得したWidgetからイメージファイルをキャプチャする
    ui.Image capturedImage = await boundary.toImage(
      pixelRatio: 3.0,
    );

    // PNG形式化
    ByteData byteData = await capturedImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    // バイトデータ化
    final _pngBytes = byteData.buffer.asUint8List();
    // BASE64形式化
    final _base64 = base64Encode(_pngBytes);
    // 画像をギャラリーへ保存
    final result = await ImageGallerySaver.saveImage(_pngBytes);
    setState(() {
      _editedImage64 = _pngBytes;
    });
  }

  void _getSizes() {
    final RenderBox renderBoxRed =
        _keyEditedImage.currentContext.findRenderObject();
    final sizeRed = renderBoxRed.size;
    print("SIZE of Red: $sizeRed");
  }

  void _getPositions() {
    final RenderBox renderBoxRed =
        _keyEditedImage.currentContext.findRenderObject();
    final positionRed = renderBoxRed.localToGlobal(Offset.zero);
    print("POSITION of Red: $positionRed ");
  }

  void _afterLayout(_) {
    _getSizes();
    _getPositions();
  }

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
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('画像を保存しますか'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('はい'),
                        onPressed: () {
                          _requestPermission();
                          _exportToImage();
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text('いいえ'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            color: Colors.white,
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          RepaintBoundary(
            key: _keyEditedImage,
            child: Container(child: Paper(image)),
          ),
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
                title: Text('編集を削除します'),
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
