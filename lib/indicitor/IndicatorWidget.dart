import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refresh_upload/base/LoadMoreState.dart';
class IndicatorWidget extends StatelessWidget{
  final LoadMoreState state;
  final Function tryAgain;
  final Color backgroundColor;
  final bool isSliver;
  const IndicatorWidget({Key key, this.state, this.tryAgain,  this.backgroundColor, this.isSliver}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget widget;
    switch(state){
      case LoadMoreState.None:
        widget = Container(height: 0.0);
        break;
      case LoadMoreState.Empty:
        widget = Text("空空如也～");
        widget = _setbackground(true, widget, double.infinity);
        if (isSliver) {
          widget = SliverFillRemaining(
            child: widget,
          );
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
          );
        }
        break;
      case LoadMoreState.Error:
        widget = Text("加载失败，点击重试",);
        widget = _setbackground(false, widget, 35.0);
        if (tryAgain != null) {
          widget = GestureDetector(
            onTap: () {
              tryAgain();
            },
            child: widget,
          );
        }
        break;
      case LoadMoreState.Loading:
        widget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 5.0),
              height: 15.0,
              width: 15.0,
              child: getIndicator(context),
            ),
            Text( "加载中...")
          ],
        );
        widget = _setbackground(false, widget, 35.0);
        break;
      case LoadMoreState.NoMore:
        widget = Text( "没有更多啦！");
        widget = _setbackground(false, widget, 35.0);
        break;
      case LoadMoreState.Refreshing:
        widget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 0.0),
              height: 30.0,
              width: 30.0,
              child: getIndicator(context),
            ),
            Text("加载中")
          ],
        );
        widget = _setbackground(true, widget, double.infinity);
        if (isSliver) {
          widget = SliverFillRemaining(
            child: widget,
          );
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
          );
        }
        break;
      case LoadMoreState.RefreshError:
        widget = Text("出错啦，点击重试",);
        widget = _setbackground(true, widget, double.infinity);
        if (tryAgain != null) {
          widget = GestureDetector(
            onTap: () {
              tryAgain();
            },
            child: widget,
          );
        }
        if (isSliver) {
          widget = SliverFillRemaining(
            child: widget,
          );
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
          );
        }
        break;
    }
    return widget;
  }
  Widget _setbackground(bool full, Widget widget, double height) {
    widget = Container(
        width: double.infinity,
        height: height,
        child: widget,
        color: backgroundColor ?? Colors.white,
        alignment: Alignment.center);
    return widget;
  }
  Widget getIndicator(BuildContext context) {
    return Platform.isIOS
        ? CupertinoActivityIndicator(
      animating: true,
      radius: 16.0,
    )
        : CircularProgressIndicator(
      strokeWidth: 2.0,
      valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
    );
  }
}