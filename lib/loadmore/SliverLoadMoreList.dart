import 'package:flutter/material.dart';
import 'package:refresh_upload/base/BaseList.dart';
import 'package:refresh_upload/base/LoadMoreState.dart';
import 'package:refresh_upload/loadmore/SliverListConfig.dart';
class SliverLoadMoreList<T> extends StatelessWidget{
  final SliverListConfig<T> listConfig;
  final NotificationListenerCallback<ScrollNotification> scrollNotification;
  const SliverLoadMoreList({Key key, this.scrollNotification, this.listConfig})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<BaseList>(
      stream: listConfig.list?.stream,
      initialData: listConfig.list,
      builder: (data, stream) {
        print("recive");
        return listConfig.buildFirst(context, stream.data);
      },
    );
  }


}