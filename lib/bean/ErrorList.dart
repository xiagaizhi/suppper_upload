//端游列表

import 'package:refresh_upload/base/BaseList.dart';

class ErrorList extends BaseList<int> {
  @override
  Future<bool> onRefresh() async {
    // TODO: implement onRefresh
    pageIndex = 1;
    return loadMore();
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    // TODO: implement loadData
    hasmore=false;
    return await fakeRequest(0, 10);
  }
  void reSetIndex(){
    pageIndex=1;
  }
  Future<bool> fakeRequest(int from, int to) async {
    return Future.delayed(Duration(seconds: 2), () {
      return false;
    });
  }
}