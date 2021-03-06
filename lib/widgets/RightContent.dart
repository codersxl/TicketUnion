import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import 'package:ticketunion/model/RecomGoodModel.dart';
import 'package:ticketunion/net/HttpManger.dart';
import 'package:ticketunion/net/config.dart';
import 'package:ticketunion/provider/ChangeCate.dart';
import 'package:ticketunion/route/Application.dart';
import 'package:ticketunion/widgets/CacheImageManger.dart';
import 'package:ticketunion/widgets/ScreenUtils.dart';
import 'LoadingWidget.dart';

class RightContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RightContentState();
  }
}

class RightContentState extends State<RightContent> {
  int goodId = 0;
  List<Map> data = [];
  List childrens = [];
  int leftIndex = 0;
  int pageIndex = 0;
  List<MapData> mapData;
  int lastgoodId;

  Widget _loader(BuildContext context, String url) => Center(
        child: CircularProgressIndicator(),
      );

  Widget _error(BuildContext context, String url, Exception error) {
    print(error);
    return Center(child: const Icon(Icons.error));
  }

  Widget _items(index, children) {
    String src = "https:${mapData[index].pictUrl}";
    String url = "${mapData[index].couponShareUrl}";
    return Card(
        elevation: 15.0, //设置阴影
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0))),
        child: InkWell(
          onTap: (){
            Application.router.navigateTo(context,"/detail?id=${Uri.encodeComponent(url)}&src=${Uri.encodeComponent(src)}");
          },
          child: Container(
            width: ScreenUtils.width(500),
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: ScreenUtils.height(2)),
            child: Column(
              children: [
                //Image.network(src)
                Container(
                  height: ScreenUtils.height(360),
                  width: ScreenUtils.width(350),
                  child: CacheImageManger.CaheImage(src),
                ),

                Text(
                  "${mapData[index].title}",
                  maxLines: 2,
                  style: TextStyle(),
                ),

                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "${mapData[index].shopTitle}",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "卷后价:¥${mapData[index].couponAmount}",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Expanded(
      child: Provide<ChangeCate>(
        // ignore: missing_return
        builder: (context, child, childCategory) {
          leftIndex = childCategory.leftindex;
          pageIndex = childCategory.pageindex;
          goodId = childCategory.goodid;

          if (goodId != 0) {
            if (goodId != lastgoodId) {
              lastgoodId = goodId;
              getContent(Config.recomgoods, page: goodId).then((goodItem) {
                RecomGoodModel recomGoodModel =
                    RecomGoodModel.fromJson(goodItem);
                setState(() {
                  mapData = recomGoodModel
                      .data.tbkDgOptimusMaterialResponse.resultList.mapData;
                });
              });
              if (mapData != null) {
                return Container(
                  width: ScreenUtils.width(500),
                  margin: EdgeInsets.fromLTRB(ScreenUtils.width(5),
                      ScreenUtils.width(5), ScreenUtils.width(5), 0),
                  child: ListView.builder(
                      itemCount: mapData.length,
                      itemBuilder: (context, index) {
                        return _items(index, mapData);
                      }),
                );
              } else {
                return Container(
                  height: ScreenUtils.height(1330),
                  width: ScreenUtils.width(500),
                  child: LoadingWidget(),
                );;
                ;
              }
            } else {
              if (mapData != null && mapData.length != 0) {
                return Container(
                  width: ScreenUtils.width(500),
                  margin: EdgeInsets.fromLTRB(ScreenUtils.width(5),
                      ScreenUtils.width(5), ScreenUtils.width(5), 0),
                  child: ListView.builder(
                      itemCount: mapData.length,
                      itemBuilder: (context, index) {
                        return _items(index, mapData);
                      }),
                );
              } else {
                return Container(
                  height: ScreenUtils.height(1330),
                  width: ScreenUtils.width(500),
                  child: LoadingWidget(),
                );
              }
            }
          } else {
            return Container(
              height: ScreenUtils.height(1330),
              width: ScreenUtils.width(500),
              child: LoadingWidget(),
            );
          }
        },
      ),
    );
  }
}
