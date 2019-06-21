import 'package:flutter/material.dart';
import 'package:refresh_upload/bean/TestSource.dart';
import 'package:refresh_upload/loadmore/ListConfig.dart';
import 'package:refresh_upload/loadmore/LoadMoreCustomScrollView.dart';
import 'package:refresh_upload/loadmore/LoadMoreList.dart';
import 'package:refresh_upload/loadmore/SliverListConfig.dart';
import 'package:refresh_upload/loadmore/SliverLoadMoreList.dart';

class GridPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GridState();
  }
}

class GridState extends State<GridPage> {
  TestSource testSource;
  @override
  void initState() {
    super.initState();
    testSource = new TestSource();
  }

  @override
  void dispose() {
    super.dispose();
    testSource.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Gridview"),
      ),
      body: RefreshIndicator(
          child: LoadMoreList(
            listConfig: ListConfig<int>(
                itemBuilder: (BuildContext context, int item, int index) {
                  return Container(
                    color: Colors.blue,
                    child: Center(
                      child: Text(item.toString()),
                    ),
                    height: 50,
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, //每行三列
                    crossAxisSpacing: 15, //横轴方向子元素的间距。
                    mainAxisSpacing: 20, //主轴方向的间距。
                    childAspectRatio: 0.64 //显示区域宽高相等
//                    childAspectRatio: 0.5
                    ),
                list: testSource),
          ),
          onRefresh: _onRefresh),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.navigate_next),
          onPressed: () {
            testSource.refresh(true);
          }),
    );
  }

  Future<Null> _onRefresh() async {
    await testSource.refresh();
  }
}
