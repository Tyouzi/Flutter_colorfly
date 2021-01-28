import 'package:flutter/cupertino.dart';
import 'package:flutter_colorfly/component/profile/profile_header.dart';
import 'package:flutter_colorfly/component/profile/profile_tabbar.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfileState();
  }
}

class ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Column(
      children: [ProfileHeader(), Expanded(child: ProfileTabBar())],
    ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
