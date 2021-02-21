import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class IconModel extends ChangeNotifier {
  var _icon = Icons.add;
  double _width = 3;

  get icon => _icon;
  set icon(var icon) {
    _icon = icon;
    notifyListeners();
  }

  get width => _width;
  set width(double width) {
    _width = width;
    notifyListeners();
  }
}
