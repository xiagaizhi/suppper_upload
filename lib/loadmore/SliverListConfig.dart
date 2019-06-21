import 'package:flutter/material.dart';
import 'package:refresh_upload/base/BaseList.dart';
import 'package:refresh_upload/base/BaseListConfig.dart';
int _kDefaultSemanticIndexCallback(Widget _, int localIndex) {
  return localIndex;
}
class SliverListConfig<T> extends BaseListConfig<T> {
  bool showNoMore = true;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final SemanticIndexCallback semanticIndexCallback;
  final int semanticIndexOffset;
  final int childCount;
  SliverListConfig({
    Widget Function(BuildContext context, T item, int index) itemBuilder,
    BaseList<T> list,
    SliverGridDelegate gridDelegate,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0,
    this.childCount,
  }) : super(itemBuilder, list, gridDelegate);
  @override
  Widget buildFirst(BuildContext context, BaseList source) {
    Widget widget = super.buildFirst(context, source);
    if(widget==null){
      //已经加载过了
      if (gridDelegate != null) {
        widget = SliverGrid(
            delegate: new SliverChildBuilderDelegate(buildSliverGridItem,
                addAutomaticKeepAlives: addAutomaticKeepAlives,
                addRepaintBoundaries: addRepaintBoundaries,
                addSemanticIndexes: addSemanticIndexes,
                semanticIndexCallback: semanticIndexCallback,
                semanticIndexOffset: semanticIndexOffset,
                childCount: list.length ),
            gridDelegate: gridDelegate);
      } else {
        widget = SliverList(
          delegate: new SliverChildBuilderDelegate(buildSliverListItem,
              addAutomaticKeepAlives: addAutomaticKeepAlives,
              addRepaintBoundaries: addRepaintBoundaries,
              addSemanticIndexes: addSemanticIndexes,
              semanticIndexCallback: semanticIndexCallback,
              semanticIndexOffset: semanticIndexOffset,
              childCount:list.length),
        );
      }
    }
    return widget;
  }
}