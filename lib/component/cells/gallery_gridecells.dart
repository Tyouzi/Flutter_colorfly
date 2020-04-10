import 'package:flutter/material.dart';

class GalleryCells extends StatelessWidget{
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
            child: Text('22222'),
          ),)
      ),
    );
  }
  
}