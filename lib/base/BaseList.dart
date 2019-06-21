import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:refresh_upload/base/LoadMoreState.dart';

///状态管理：1页码，2指示器
///上拉加载：1冗余拦截，2子类处理，3返回数据处理
///下拉刷新：1页码重置，2上拉加载
///错误重试：1下拉刷新
///消息传递：传送新数据刷新页面
abstract class BaseList<T> extends ListBase<T> with _LoadingMoreBloc<T>,_CustomBloc<T>{

  @override
  int get length => _list.length;
  bool hasmore=true;
  set length(int newLength) => _list.length = newLength;
  var _list = <T>[];
  @override
  T operator [](int index) {
    // TODO: implement []
    return _list[index];
  }


  @override
  void operator []=(int index, T value) {
    // TODO: implement []=
    _list[index]=value;
  }
  LoadMoreState currentState = LoadMoreState.None;
  int pageIndex=1;
  @mustCallSuper
  Future<bool> loadMore() async {
    if(currentState==LoadMoreState.Loading||currentState==LoadMoreState.NoMore||!hasmore){
      //正在加载或者没有更多，拦截
      return false;
    }
    //通知布局改变刷新状态
    onStateChanged(this);
    print("loadMore");
    currentState = LoadMoreState.Loading;
    return await _toLoadMore();
  }
  Future<bool> _toLoadMore() async {
    var success=await loadData();
    if(success){
      this.length==0?currentState=LoadMoreState.Empty:currentState=LoadMoreState.None;
      pageIndex++;
    }else{
      currentState==LoadMoreState.Refreshing?currentState=LoadMoreState.RefreshError:currentState=LoadMoreState.Error;
    }
    //通知布局改变刷新状态
    print("_toLoadMore");
    print(currentState);
    onStateChanged(this);
    return success;
  }
  //@protected
  Future<bool> loadData();
  @mustCallSuper
  Future<bool> refresh([bool clear = false]) async {
    clear??this.clear();
    if(currentState==LoadMoreState.Refreshing){
      return false;
    }
    currentState=LoadMoreState.Refreshing;
    //重置页码
    pageIndex=1;
    return await _toLoadMore();
  }
  @mustCallSuper
  Future<bool> errorReload() async {
    return currentState==LoadMoreState.Error?loadMore():refresh();
  }

  @override
  void onStateChanged(BaseList<T> source) {
    super.onStateChanged(source);
  }
  @override
  void dispose() {
    _streamController.close();
    _customstreamController.close();
  }
}
class _LoadingMoreBloc<T> {
  final _streamController = new StreamController<BaseList<T>>.broadcast();
  Stream<BaseList<T>> get stream => _streamController.stream;

  void onStateChanged(BaseList<T> source) {
    if (!_streamController.isClosed) _streamController.sink.add(source);
  }

  void dispose() {
    _streamController.close();
  }
}
class _CustomBloc<T> {
  final _customstreamController = new StreamController<LoadMoreState>.broadcast();
  Stream<LoadMoreState> get customStream => _customstreamController.stream;
  Sink<LoadMoreState> get customSink => _customstreamController.sink;
  void dispose() {
    _customstreamController.close();
  }
}