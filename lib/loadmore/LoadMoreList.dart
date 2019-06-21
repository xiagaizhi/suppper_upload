import 'package:flutter/material.dart';
import 'package:refresh_upload/base/BaseList.dart';
import 'package:refresh_upload/base/LoadMoreState.dart';
import 'package:refresh_upload/loadmore/ListConfig.dart';

class LoadMoreList<T> extends StatelessWidget {
  final ListConfig<T> listConfig;
  final NotificationListenerCallback<ScrollNotification> scrollNotification;
  const LoadMoreList({Key key, this.scrollNotification, this.listConfig})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<BaseList>(
      stream: listConfig.list?.stream,
      initialData: listConfig.list,
      builder: (data, stream) {
        print("recive list");
        return NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: listConfig.buildFirst(context, stream.data));
      },
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (scrollNotification != null) scrollNotification(notification);

    if (notification.depth != 0) return false;
    if (notification.metrics.axisDirection == AxisDirection.down &&
        notification.metrics.pixels >= notification.metrics.maxScrollExtent) {
      if (listConfig.list.currentState != LoadMoreState.Loading &&
          listConfig.list.currentState != LoadMoreState.Error &&
          listConfig.list.hasmore) {
        print("Load more");
        listConfig.list.loadMore();
      }
    }
    return false;
  }
}
