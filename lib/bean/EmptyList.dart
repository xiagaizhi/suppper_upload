//端游列表

import 'package:refresh_upload/base/BaseList.dart';

class EmptyList extends BaseList<int> {
  @override
  Future<bool> onRefresh() async {
    // TODO: implement onRefresh
    pageIndex = 1;
    return loadMore();
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    // TODO: implement loadData
    bool isSuccess = false;
    if(pageIndex==3){
      hasmore=false;
      return true;
    }
    try {
      List<int> list = [];
      list=await fakeRequest(0, 20);
      if (pageIndex == 1) {
        this.clear();
      }
      this.addAll(list);
      hasmore = (list.length == 20);
      isSuccess = true;
      print(this.length);
    } catch (exception) {
      isSuccess = false;
    }
    return isSuccess;
  }
  void reSetIndex(){
    pageIndex=1;
  }
  Future<List<int>> fakeRequest(int from, int to) async {
    return Future.delayed(Duration(seconds: 2), () {
      return List();
    });
  }
}