import 'package:flutter/material.dart';
import 'package:refresh_upload/bean/EmptyList.dart';
import 'package:refresh_upload/bean/TestSource.dart';
import 'package:refresh_upload/loadmore/ListConfig.dart';
import 'package:refresh_upload/loadmore/LoadMoreList.dart';

class EmptyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EmptyState();
  }
}

class EmptyState extends State<EmptyPage> {
  EmptyList emptyList;
  @override
  void initState() {
    super.initState();
    emptyList = new EmptyList();
  }

  @override
  void dispose() {
    super.dispose();
    emptyList.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("empty"),),
      body:RefreshIndicator(child: LoadMoreList(listConfig: ListConfig<int>(
          itemBuilder: (BuildContext context, int item, int index) {
            return Container(
              child: Center(
                child: Text(item.toString()),
              ),
              height: 50,
            );
          },
          list: emptyList),), onRefresh: _onRefresh),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.navigate_next),
          onPressed: (){
            emptyList.refresh(true);
          }),
    );
  }
  Future<Null> _onRefresh() async {
    await emptyList.refresh();
  }
}
