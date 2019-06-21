import 'package:flutter/material.dart';
import 'package:refresh_upload/base/BaseList.dart';
import 'package:refresh_upload/base/LoadMoreState.dart';
import 'package:refresh_upload/indicitor/IndicatorWidget.dart';
import 'package:refresh_upload/loadmore/SliverLoadMoreList.dart';

class LoadMoreCustomScrollView extends StatefulWidget {
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
  LoadMoreCustomScrollView(
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
      this.onScrollNotification, this.list})
      : assert(slivers != null),
        super(key: key);
  @override
  _LoadingMoreCustomScrollViewState createState() =>
      _LoadingMoreCustomScrollViewState();
}

class _LoadingMoreCustomScrollViewState
    extends State<LoadMoreCustomScrollView> {
  List<SliverLoadMoreList> _loadingMoreWidgets;
  @override
  void initState() {
    ///提取LoadingMoreSliverList数组
    _loadingMoreWidgets = widget.slivers
        .where((x) {
          return x is SliverLoadMoreList;
        })
        .map<SliverLoadMoreList>((f) => f as SliverLoadMoreList)
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    List<Widget> widgets = List<Widget>();
    var loadingMoreWidgets = this._loadingMoreWidgets;
    if (loadingMoreWidgets.length > 0) {
      var slivers = widget.slivers;
      if (widget.reverse) {
        slivers = slivers.reversed;
        loadingMoreWidgets = loadingMoreWidgets.reversed;
      }
      //当前sliver可以加载更多，终止添加新的sivler
      for (int i = 0; i < slivers.length; i++) {
        var item = slivers[i];
        widgets.add(item);
        if (item is SliverLoadMoreList) {
          if (loadingMoreWidgets.length > 1) {
//            item.sliverListConfig.showFullScreenLoading = showFullScreenLoading;
//            showFullScreenLoading = false;
            item.listConfig.showNoMore = loadingMoreWidgets.last == item;
          }
          if (widget.rebuildCustomScrollView) {
            item.listConfig.list.stream.listen(onDataChanged);
            widgets.remove(item);
            widgets
                .add(item.listConfig.buildFirst(context, item.listConfig.list));
          }

          if (item.listConfig.list.hasmore) {
            break;
          }
        }
      }
    } else {
      widgets = widget.reverse ? widget.slivers.reversed : widget.slivers;
    }
    ///处理滑动通知
    return StreamBuilder<LoadMoreState>(
      stream: widget.list?.customStream,
      initialData: LoadMoreState.Loading,
      builder: (context,data){
        print("recvvvvv");
        print(data.data);
        widgets.last is SliverToBoxAdapter?widgets.removeLast(): widgets.add(SliverToBoxAdapter(child: IndicatorWidget(state: data.data,isSliver: false,),));
        return NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: CustomScrollView(
            semanticChildCount: widget.semanticChildCount,
            shrinkWrap: widget.shrinkWrap,
            scrollDirection: widget.scrollDirection,
            physics: widget.physics,
            primary: widget.primary,
            cacheExtent: widget.cacheExtent,
            controller: widget.controller,
            slivers: widgets,
          ),
        );
      },
    );
    // }
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (widget.onScrollNotification != null)
      widget.onScrollNotification(notification);
    if (notification.depth != 0) return false;

    if (notification.metrics.axisDirection == AxisDirection.down &&
        notification.metrics.pixels >= notification.metrics.maxScrollExtent) {
      var loadingMoreWidgets = this._loadingMoreWidgets;

      if (loadingMoreWidgets.length > 0) {
        if (widget.reverse) {
          loadingMoreWidgets = loadingMoreWidgets.reversed;
        }

        SliverLoadMoreList preList;
        for (int i = 0; i < loadingMoreWidgets.length; i++) {
          var item = loadingMoreWidgets[i];

          var preListIsloading = preList?.listConfig?.list?.currentState ==
                  LoadMoreState.Loading ??
              false;

          if (!preListIsloading &&
              item.listConfig.list.hasmore &&
              !(item.listConfig.list.currentState == LoadMoreState.Loading) &&
              !(item.listConfig.list.currentState == LoadMoreState.Error)) {
            if (preList != item && loadingMoreWidgets.length > 1) {
              //if(item.sliverListConfig.sourceList)
              setState(() {
                item.listConfig.list.length == 0
                    ? item.listConfig.list.refresh()
                    : item.listConfig.list.loadMore();
              });
            } else {
              item.listConfig.list.length == 0
                  ? item.listConfig.list.refresh()
                  : item.listConfig.list.loadMore();
            }
            break;
          }
          preList = item;
        }
      }
    }
    return false;
  }

  void onDataChanged(BaseList data) {
    //if (data != null) {
    setState(() {});
    //}
  }
}
