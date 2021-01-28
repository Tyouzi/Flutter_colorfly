import 'package:flutter/cupertino.dart';
import 'package:flutter_colorfly/component/cells/artwork_cell.dart';

class ArtWorkList extends StatefulWidget {
  ArtWorkList({Key key}) : super(key: key);

  @override
  _ArtWorkListState createState() => _ArtWorkListState();
}

class _ArtWorkListState extends State<ArtWorkList> {
  Widget itemBuilder(BuildContext context, int index) {
    return ArtWorkCell(
      onPress: this.onItemPress(),
    );
  }

  onItemPress() {}
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
        itemBuilder: this.itemBuilder,
        itemCount: 10,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1,
          crossAxisCount: 2,
        ),
      ),
    );
  }
}
