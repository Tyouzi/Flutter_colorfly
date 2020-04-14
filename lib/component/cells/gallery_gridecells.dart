import 'package:flutter/material.dart';
import 'package:flutter_demo/model/template.dart';

class GalleryCells extends StatelessWidget{
    Template tem;
    GalleryCells({
      this.tem
    });
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Colors.pink,
          child: Center(
            child: Text(tem.id),
          ),)
      ),
    );
  }
  
}