import 'package:flutter/material.dart';
import 'package:refresh_upload/base/BaseList.dart';
import 'package:refresh_upload/base/LoadMoreState.dart';
import 'package:refresh_upload/indicitor/IndicatorWidget.dart';
import 'package:refresh_upload/loadmore/SliverLoadMoreList.dart';

class LoadMoreCustom<T> extends StatelessWidget {
  final List<Widget> slivers;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController controller;
  final bool primary;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final double cacheExtent;
  final int semanticChildCount;
  final bool rebuildCustomScrollView;
  final NotificationListenerCallback<ScrollNotification> onScrollNotification;
  final BaseList list;
  LoadMoreCustom(
      {Key key,
      this.scrollDirection = Axis.vertical,
      this.reverse = false,
      this.controller,
      this.primary,
      this.physics,
      this.shrinkWrap = false,
      this.cacheExtent,
      this.slivers = const <Widget>[],
      this.semanticChildCount,
      this.rebuildCustomScrollView: false,
      this.onScrollNotification,
      this.list})
      : assert(slivers != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<LoadMoreState>(
      stream: list?.customStream,
      initialData: LoadMoreState.Loading,
      builder: (context, data) {
        print("recive from custom");
        return NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: buildCustomScrollView(data.data));
      },
    );
  }

  Widget buildCustomScrollView(LoadMoreState state) {
    List<Widget> widgets = List<Widget>();
    for (int i = 0; i < slivers.length; i++) {
      var item = slivers[i];
      widgets.add(item);
      if (item is SliverLoadMoreList) {
        if (item.listConfig.list.hasmore) {
          break;
        }
      }
    }
    widgets.last is SliverToBoxAdapter?widgets.removeLast(): widgets.add(SliverToBoxAdapter(child: IndicatorWidget(state: state,isSliver: false,),));
    return CustomScrollView(
      semanticChildCount: semanticChildCount,
      shrinkWrap: shrinkWrap,
      scrollDirection: scrollDirection,
      physics: physics,
      primary: primary,
      cacheExtent: cacheExtent,
      controller: controller,
      slivers: widgets,
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (onScrollNotification != null) onScrollNotification(notification);

    if (notification.depth != 0) return false;
    if (notification.metrics.axisDirection == AxisDirection.down &&
        notification.metrics.pixels >= notification.metrics.maxScrollExtent) {
      if (list.currentState != LoadMoreState.Loading &&
          list.currentState != LoadMoreState.Error &&
          list.hasmore) {
        print("Load more");
        list.loadMore();
      }
    }
    return false;
  }
}
