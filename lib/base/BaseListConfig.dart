import 'package:flutter/material.dart';
import 'package:refresh_upload/base/BaseList.dart';
import 'package:refresh_upload/base/LoadMoreState.dart';
import 'package:refresh_upload/indicitor/IndicatorWidget.dart';
import 'package:refresh_upload/loadmore/SliverListConfig.dart';
///list or grid配置信息，负责构建视图，管理各种状态对应视图
class BaseListConfig<T>{
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final BaseList<T> list;
  final SliverGridDelegate gridDelegate;
  BaseListConfig(this.itemBuilder, this.list, this.gridDelegate);

  bool get isSliver {
    return this is SliverListConfig<T>;
  }

  Widget buildFirst(BuildContext context, BaseList source) {
    Widget widget;
    if(source==null||(source.length==0&&source.currentState==LoadMoreState.None)){
      //第一次加载
      source.refresh();
      widget=IndicatorWidget(state: list.currentState,isSliver: isSliver,);
      print("first load and to refresh");
    }else if(source.length==0&&source.currentState==LoadMoreState.Empty||source.currentState==LoadMoreState.RefreshError){
      //为空
      widget= widget=IndicatorWidget(state: list.currentState,isSliver: isSliver,);
      print("first load empty");
    }
    return widget;
  }
  Widget buildListItem(BuildContext context, int index) {
    //build不一定可见，系统会预构建几个item
    Widget widget;
    if (index == list.length) {
      //list尾部view
      var state = list.hasmore?LoadMoreState.Loading:LoadMoreState.NoMore;
      widget=IndicatorWidget(state: state,isSliver: isSliver,);
      print("secend build last item load");
      print(list.hasmore);
      return widget;
    }
    return itemBuilder(context, list[index], index);
  }
  Widget buildGridItem(BuildContext context,int index){
    Widget widget;
    if (index == -1) {
      //list尾部view
      var state = list.hasmore?LoadMoreState.Loading:LoadMoreState.NoMore;
      widget=IndicatorWidget(state: state,isSliver: isSliver,);
      print("secend build last item load");
      print(list.hasmore);
      list.customSink.add(state);
      return widget;
    }
    return itemBuilder(context, list[index], index);
  }
  Widget buildSliverListItem(BuildContext context, int index) {
    //build不一定可见，系统会预构建几个item
    Widget widget;
    if (index == list.length-1) {
      //list尾部view
      var state = list.hasmore?LoadMoreState.Loading:LoadMoreState.NoMore;
      list.customSink.add(state);
      return itemBuilder(context, list[index], index);
    }
    return itemBuilder(context, list[index], index);
  }
  Widget buildSliverGridItem(BuildContext context,int index){
    if (index == list.length-1) {
      //list尾部view
      var state = list.hasmore?LoadMoreState.Loading:LoadMoreState.NoMore;
      print("secend build last item load");
      print(list.hasmore);
      list.customSink.add(state);
    }
    return itemBuilder(context, list[index], index);
  }
}