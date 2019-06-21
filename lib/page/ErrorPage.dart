import 'package:flutter/material.dart';
import 'package:refresh_upload/bean/EmptyList.dart';
import 'package:refresh_upload/bean/ErrorList.dart';
import 'package:refresh_upload/bean/TestSource.dart';
import 'package:refresh_upload/loadmore/ListConfig.dart';
import 'package:refresh_upload/loadmore/LoadMoreList.dart';

class ErrorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ErrorState();
  }
}

class ErrorState extends State<ErrorPage> {
  ErrorList errorList;
  @override
  void initState() {
    super.initState();
    errorList = new ErrorList();
  }

  @override
  void dispose() {
    super.dispose();
    errorList.dispose();
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
          list: errorList),), onRefresh: _onRefresh),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.navigate_next),
          onPressed: (){
            errorList.refresh(true);
          }),
    );
  }
  Future<Null> _onRefresh() async {
    await errorList.refresh();
  }
}
