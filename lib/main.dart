import 'package:flutter/material.dart';
import 'package:coding_challenge/models/info_model.dart';
import 'package:intl/intl.dart';
import 'package:oauth2/oauth2.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coding Challenge',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: EbaySearch(),
    );
  }
}

class EbaySearchState extends State<EbaySearch> {
  final TextEditingController _query = TextEditingController();
  var dio = Dio();
  List items = List();
  final String _queryURL = 'https://api.ebay.com/buy/browse/v1/item_summary/search?';
  Widget _appTitle = Text('eBay Search App');
  Icon _queryIcon = Icon(Icons.search);

  EbaySearchState() {}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(
        child: _buildResultsList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: _queryIcon,
      title: TextField(
        controller: _query,
        decoration: InputDecoration(
          hintText: 'Search for anything...',
          hintStyle: TextStyle(color: Colors.white),
        ),
        onSubmitted: (_queryText) {
          if(_queryText.isNotEmpty) {
            _getQueryResults(_queryText);
          }
        },
        style: TextStyle(
            color: Colors.white),
      ),
    );
  }

  Widget _buildResultsList() {
    return ListView.separated(
      itemCount: items == null ? 0 : items.length,
      itemBuilder: (BuildContext context, int idx) {
        return ListTile(
          leading: Image.network(items[idx]['image']['imageUrl'],
          width: 75.0, height: double.infinity),
          title: Text(items[idx]['title']),
          subtitle: Text('\$' + items[idx]['price']['value'], style: TextStyle(fontSize: 15.0),),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailedItem(itemId: items[idx]['itemId'])),
            );
          },
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  // Build the query URL based on what user entered
  String _buildQueryURL(String _queryText) {
    final String _finalURL = _queryURL + 'q=' + _queryText + '&limit=100';
    print('finalURL is: ' + _finalURL);
    return _finalURL;
  }

  // Get results from eBay API with query text
  void _getQueryResults(String _queryText) async {
    final String authToken = 'Bearer v^1.1#i^1#r^0#p^1#I^3#f^0#t^H4sIAAAAAAAAAOVYa2wUVRTutttCedjEEBQkugyKSp3ZmZ3uYybsxm23lIU+tt0CZY3g3Zk77djZmWXurO3aALUJlaDyowQfFW01viUhGAnxETRNhPj4oaJgSFD5YSgiJqKJYBC9M7uUbSUt0g02cf9s5txzz/3O951z752hu0tKl/Qu7/19tm1a4WA33V1oszEz6dKS4vIbigrnFxfQOQ62we7bu+09RcNLEUgoSb4JoqSmIujoTCgq4i2jn0jpKq8BJCNeBQmIeEPgo8G6Wt5F0XxS1wxN0BTCEQ75CejlfBLtcgMvYL0QcNiqXorZrPkJNytxIi2wHGAAiEMBjyOUgmEVGUA1/ISLZjiSoUnG0+xieRfHs27K5XbFCMdqqCNZU7ELRRMBCy5vzdVzsI4PFSAEdQMHIQLh4LJoQzAcqq5vXurMiRXI8hA1gJFCo5+qNBE6VgMlBcdfBlnefDQlCBAhwhnIrDA6KB+8BOYa4FtUA1GUuLhP8AGfV/LEfXmhcpmmJ4AxPg7TIoukZLnyUDVkIz0Ro5iN+INQMLJP9ThEOOQw/xpTQJElGep+oroyuDYYiRCBFVqbqqYjGokpl9XWqjYy0hQi2TjLSAxdIZLQU8H6JFHILpSJlqV5zEpVmirKJmnIUa8ZlRCjhmO5YXK4wU4NaoMelAwT0Yift5lmLnHI+mKmqBkVU0abauoKE5gIh/U4sQIjsw1Dl+MpA45EGDtgUYS1TiZlkRg7aNVitnw6kZ9oM4wk73R2dHRQHSyl6a1OF00zzpa62qjQBhOAwL5mr2f85YknkLKVigDxTCTzRjqJsXTiWsUA1FYiUEEzXtaX5X00rMBY6z8MOTk7R3dE3jqEZqAgsCwjQljh8or56JBAtkidJg4YB2kyAfR2aCQVIEBSwHWWSkBdFnEsCVeKBEnRw0lkBSdJZNwtekhGgpCGMB4XON//qVGuttSjUNChkZdaz1udR9JyO6xuaelwly/3RKqDa9d4K0VJjUXLq1auauKqW2IeX7yyEa30tvqvthuunLygJWFEU2QhnQcGzF7PIwusLkaAbqSjUFGwYVKJIjPRqSWyOR/hACApU2ZjU4KWcGoA7+imab2FeFI5B5PJcCKRMkBcgeH87Ob/0U5+xfRkfNeZUjlh/TJCymLmkkJZalLoIYHSIdJSOr6fUQ3mmd2stUMV74CGrikK1Fczkxb6eutr9voEfPzLw+Lacs/fTWUq1bagyLiE1k+1zK6LojKYYqcx4/YyLo/P7XVPKq8qS9Pm9FQ7h5ZryIDieKnZa67xWu0c/ZIfKLB+TI9tH91j21tos9FO+g5mEb2wpGiVvWjWfCQbkJKBRCG5VcXvrjqk2mE6CWS9sMQm93356Nc5nxUG76dvHvmwUFrEzMz5ykAvuDxSzJTdNJvhGJrxuFgXx7pj9KLLo3Zmrn3On7Uv9m+/s/boA4duuWC/uLmR+mvDB/TsESebrbjA3mMrUE69fd/BgRP+U4tn/faUv2/GFzD2SqCv/YaP9j37SHfYe64/9NjS4U8Xv9yyZuCTH1ynbQt2nHrttu+nxZZNWyD3huwb+6M/DglNbOC9b87ufGfNvguBpl/9zq4j29b9sfKl6Z/vql4UO9+45au6p4fKu74r42ZsPfb+8f3zNjLVx7sOD/cOXFxycrt2ZsWu82VExd79j+9448SWMjH17txzc956eO2BrpOBrcUL66Z3Dt27+fVvfxL2CDM2fZjqJ35+/kbnkarF6wpffeHWu2tq7vpsd1/ppp2DBw7dM3R695PnNkyv37PnuWMXf9n2BHe2YUWrIAy3nd5/cF4vPX/g42CkY9Wbh7cfDYVqlkTPRJ/JyPc3aBJPYvARAAA=';
    dio.options.headers = {'Authorization' : authToken};
    try {
      final Response response = await dio.get<void>(_buildQueryURL(_queryText));
      print(response);
      List resultsList = List();
      for(int i=0; i<response.data['itemSummaries'].length; i++) {
        resultsList.add(response.data['itemSummaries'][i]);
      }
      setState(() {
        items = resultsList;
      });
    }
    catch (e) {
      print(e);
    }
  }
}

class DetailedItemState extends State<DetailedItem> {
  String itemId;
  DetailedItemState(this.itemId);
  final String _itemURL = 'https://api.ebay.com/buy/browse/v1/item/';
  var dio = Dio();
//  Info info = Info();
  String parsedJson;
  Future<Info> info;

  @override
  void initState() {
    super.initState();
    _getItemResults(itemId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: FutureBuilder<Info>(
            future: _getItemResults(itemId),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(snapshot.data.title, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0, bottom: 5.0),
                          child: Container(
                            child: Image.network(snapshot.data.itemImage.imageUrl, width: double.infinity, height: 300.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Text('US \$' + snapshot.data.price.value, style: TextStyle(fontSize: 30.0)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text('Sold By: ' + snapshot.data.seller.username, style: TextStyle(fontSize: 17.0),),
                        ),
                        Text('Condition: ' + snapshot.data.condition, style: TextStyle(fontSize: 17.0)),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text('Description: ' + snapshot.data.description, style: TextStyle(fontSize: 17.0)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text('Est. Delivery ' + DateFormat('EEE, MMM d').format(snapshot.data.shippingOptions[0].minEstimatedDeliveryDate) + ' - ' + DateFormat('EEE, MMM d').format(snapshot.data.shippingOptions[0].maxEstimatedDeliveryDate)),
                        ),
                      ],
                    )
                );
              }
              else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }
        ),
      ),
    );
  }

  // Build the item detailed URL based on itemID
  String _buildItemURL(String itemId) {
    final String _finalURL = _itemURL + itemId;
    print('_finalURL is: ' + _finalURL);
    return _finalURL;
  }

  Future<Info> _getItemResults(String itemId) async {
    print('_getItemResults() called ');
    final String authToken = 'Bearer v^1.1#i^1#r^0#p^1#I^3#f^0#t^H4sIAAAAAAAAAOVYa2wUVRTutttCedjEEBQkugyKSp3ZmZ3uYybsxm23lIU+tt0CZY3g3Zk77djZmWXurO3aALUJlaDyowQfFW01viUhGAnxETRNhPj4oaJgSFD5YSgiJqKJYBC9M7uUbSUt0g02cf9s5txzz/3O951z752hu0tKl/Qu7/19tm1a4WA33V1oszEz6dKS4vIbigrnFxfQOQ62we7bu+09RcNLEUgoSb4JoqSmIujoTCgq4i2jn0jpKq8BJCNeBQmIeEPgo8G6Wt5F0XxS1wxN0BTCEQ75CejlfBLtcgMvYL0QcNiqXorZrPkJNytxIi2wHGAAiEMBjyOUgmEVGUA1/ISLZjiSoUnG0+xieRfHs27K5XbFCMdqqCNZU7ELRRMBCy5vzdVzsI4PFSAEdQMHIQLh4LJoQzAcqq5vXurMiRXI8hA1gJFCo5+qNBE6VgMlBcdfBlnefDQlCBAhwhnIrDA6KB+8BOYa4FtUA1GUuLhP8AGfV/LEfXmhcpmmJ4AxPg7TIoukZLnyUDVkIz0Ro5iN+INQMLJP9ThEOOQw/xpTQJElGep+oroyuDYYiRCBFVqbqqYjGokpl9XWqjYy0hQi2TjLSAxdIZLQU8H6JFHILpSJlqV5zEpVmirKJmnIUa8ZlRCjhmO5YXK4wU4NaoMelAwT0Yift5lmLnHI+mKmqBkVU0abauoKE5gIh/U4sQIjsw1Dl+MpA45EGDtgUYS1TiZlkRg7aNVitnw6kZ9oM4wk73R2dHRQHSyl6a1OF00zzpa62qjQBhOAwL5mr2f85YknkLKVigDxTCTzRjqJsXTiWsUA1FYiUEEzXtaX5X00rMBY6z8MOTk7R3dE3jqEZqAgsCwjQljh8or56JBAtkidJg4YB2kyAfR2aCQVIEBSwHWWSkBdFnEsCVeKBEnRw0lkBSdJZNwtekhGgpCGMB4XON//qVGuttSjUNChkZdaz1udR9JyO6xuaelwly/3RKqDa9d4K0VJjUXLq1auauKqW2IeX7yyEa30tvqvthuunLygJWFEU2QhnQcGzF7PIwusLkaAbqSjUFGwYVKJIjPRqSWyOR/hACApU2ZjU4KWcGoA7+imab2FeFI5B5PJcCKRMkBcgeH87Ob/0U5+xfRkfNeZUjlh/TJCymLmkkJZalLoIYHSIdJSOr6fUQ3mmd2stUMV74CGrikK1Fczkxb6eutr9voEfPzLw+Lacs/fTWUq1bagyLiE1k+1zK6LojKYYqcx4/YyLo/P7XVPKq8qS9Pm9FQ7h5ZryIDieKnZa67xWu0c/ZIfKLB+TI9tH91j21tos9FO+g5mEb2wpGiVvWjWfCQbkJKBRCG5VcXvrjqk2mE6CWS9sMQm93356Nc5nxUG76dvHvmwUFrEzMz5ykAvuDxSzJTdNJvhGJrxuFgXx7pj9KLLo3Zmrn3On7Uv9m+/s/boA4duuWC/uLmR+mvDB/TsESebrbjA3mMrUE69fd/BgRP+U4tn/faUv2/GFzD2SqCv/YaP9j37SHfYe64/9NjS4U8Xv9yyZuCTH1ynbQt2nHrttu+nxZZNWyD3huwb+6M/DglNbOC9b87ufGfNvguBpl/9zq4j29b9sfKl6Z/vql4UO9+45au6p4fKu74r42ZsPfb+8f3zNjLVx7sOD/cOXFxycrt2ZsWu82VExd79j+9448SWMjH17txzc956eO2BrpOBrcUL66Z3Dt27+fVvfxL2CDM2fZjqJ35+/kbnkarF6wpffeHWu2tq7vpsd1/ppp2DBw7dM3R695PnNkyv37PnuWMXf9n2BHe2YUWrIAy3nd5/cF4vPX/g42CkY9Wbh7cfDYVqlkTPRJ/JyPc3aBJPYvARAAA=';
    dio.options.headers = {'Authorization' : authToken};
    try {
      final Response response = await dio.get<void>(_buildItemURL(itemId));
      print(response);
      final jsonResult = json.decode(response.toString());
      parsedJson = response.toString();
      return Info.fromJson(jsonResult);
    }
    catch (e) {
      print(e);
    }
  }
}

class EbaySearch extends StatefulWidget {
  @override
  EbaySearchState createState() => EbaySearchState();
}

class DetailedItem extends StatefulWidget {
  // Declare itemId that holds itemId
  final String itemId;

  // Require an ItemId in the constructor
  DetailedItem({Key key, @required this.itemId}) : super(key: key);

  @override
  DetailedItemState createState() => DetailedItemState(itemId);
}
