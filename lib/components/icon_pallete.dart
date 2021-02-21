import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../models/icon_model.dart';
import '../models/pen_model.dart';

class IconPalette extends StatelessWidget {
  static const icons = [
    Icons.add,
    Icons.accessibility,
    Icons.ac_unit,
    Icons.access_alarm,
    Icons.exit_to_app,
    Icons.wallet_giftcard,
    Icons.east,
    Icons.qr_code,
    Icons.label,
    Icons.eco,
    Icons.pages,
    Icons.book,
  ];

  @override
  Widget build(BuildContext context) {
    final iconProv = Provider.of<IconModel>(context);
    final pen = Provider.of<PenModel>(context);
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: icons.length,
        itemBuilder: (context, index) {
          final i = icons[index];
          return GestureDetector(
            onTap: () {
              iconProv.icon = i;
            },
            child: iconContainer(
              i,
              i == iconProv.icon,
              pen.color,
            ),
          );
        },
      ),
    );
  }

  Widget iconContainer(var icon, bool selected, Color color) {
    return Container(
      height: 50,
      width: 45,
      padding: EdgeInsets.all(1.0),
      child: Center(
        child: Container(
          child: CircleAvatar(
            backgroundColor: Colors.blue[200],
            radius: 30,
            child: Icon(
              icon,
              size: 36,
              color: color,
            ),
          ),
          padding: selected ? EdgeInsets.all(2.0) : EdgeInsets.all(0),
          decoration: new BoxDecoration(
            color: Colors.black, // border color
            shape: BoxShape.circle,
            // boxShadow: [
            //   new BoxShadow(
            //     color: Colors.black.withOpacity(0.2),
            //     blurRadius: 5.0,
            //   ),
            // ],
          ),
        ),
      ),
    );
  }
}
