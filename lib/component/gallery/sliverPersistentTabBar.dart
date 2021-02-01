import 'package:flutter/material.dart';
import 'package:flutter_colorfly/utils/HexColor.dart';

class SliverPersistentTabBar extends SliverPersistentHeaderDelegate {
  final TabBar child;

  SliverPersistentTabBar({@required this.child});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    return Container(
      color: HexColor('#f5f5f5'),
      child: this.child,
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => this.child.preferredSize.height;

  @override
  // TODO: implement minExtent
  double get minExtent => this.child.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return true;
  }
}
