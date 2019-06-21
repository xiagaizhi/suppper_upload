import 'package:flutter/material.dart';
import 'package:refresh_upload/base/BaseList.dart';
import 'package:refresh_upload/base/BaseListConfig.dart';

class ListConfig<T> extends BaseListConfig<T> {
  ListConfig({itemBuilder, BaseList<T> list, SliverGridDelegate gridDelegate})
      : super(itemBuilder, list, gridDelegate);

  @override
  Widget buildFirst(BuildContext context, BaseList source) {
    Widget widget = super.buildFirst(context, source);
    if (widget == null) {
      if (gridDelegate == null) {
        print("secend and build listview");
        widget = ListView.builder(
          itemBuilder: buildListItem,
          itemCount: source.length + 1,
        );
      }else{
        widget = CustomScrollView(
          slivers: <Widget>[
            SliverGrid(
              gridDelegate: gridDelegate,
              delegate: SliverChildBuilderDelegate((BuildContext context,
                  int index) {
                return buildGridItem(context, index);
              }, childCount: list.length),
            ),
            SliverToBoxAdapter(
              child: buildGridItem(context, -1),
            )
          ],
        );
      }
    }
    return widget;
  }
}