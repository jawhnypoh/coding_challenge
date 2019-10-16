import 'package:flutter/material.dart';
import 'package:coding_challenge/models/info_model.dart';
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
          title: Text(items[idx]['title']),
          subtitle: Text('\$' + items[idx]['price']['value']),
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
    final String authToken = ('Bearer v^1.1#i^1#I^3#r^0#f^0#p^1#t^H4sIAAAAAAAAAOVYbWwTZRxv124wXmYcBAkRUm5ojEuvz7W9rr3Qmu4NOl7arYOWGZj38tx67Hp33HOlK0RTRzK+4SsCH0xGgvGNJWIUTcRANAIxIkIkEE2GiUMxwgc+KBrD8O5aRjfJQNbgEvuluef5P//n9//9/v/nDeSrqp8cWDlwfa51RsVgHuQrrFZiNqiuqqyvsVUsqrSAEgPrYH5Z3t5vu7wc0WlRoTogUmQJQUdfWpQQZTYGsYwqUTKNBERJdBoiSmOpeHjNasqNA0pRZU1mZRFzRJqDGBdo4CBJQgZ4GxjI+/RW6ZbPTjmIMTxJ+hjWH6ADnI/zA70foQyMSEijJS2IuQERcBLASfg63QTlJim3B/d6yS7MsR6qSJAl3QQHWMiES5lj1RKsk0OlEYKqpjvBQpFwazwajjS3rO1c7irxFSryENdoLYPGfzXJHHSsp8UMnHwaZFpT8QzLQoQwV6gww3inVPgWmPuAb1Lt4xlANxBu0k8yRMDDl4XKVllN09rkOIwWgXPypikFJU3QcndjVGeD2QxZrfi1VncRaXYYf+0ZWhR4AapBrKUxvCEci2GhNjklSbmY7NQpF6SeppQz1tHs9DAegieAl3NCn9fj5zm2OFHBW5HmCTM1yRInGKQhx1pZa4Q6ajiRG6KEG90oKkXVMK8ZiErtPGMcgi5D1IKKGS0lGbrCtE6Ew/y8uwJjozVNFZiMBsc8TOwwKQpitKIIHDax08zFYvr0oSCW0jSFcrmy2Sye9eCy2uNyA0C4kmtWx9kUTNOYbmvUesFeuPsAp2CGwkJ9JBIoLafoWPr0XNUBSD1YyAuIBo+/yPt4WKGJrf9oKInZNb4iylUhAT/DcTQIBPwEIP1cOQokVMxRlwEDMnTOmabVXqgpIs1CJ6unWSYNVYGjPCTv1nMUOjlfgHd6AzzvZEjO5yR4CAGEDMMG/P+nOrnXTI9DVoVaWVK9bGkeywm9sCWZzJL1K32xlvCGREMjx0td8fqmVes6Ai3JLp+faWxHqxp6gvdaDHcOnpUVGJNFgc2VgwGj1svHgkflYrSq5eJQFPWGKQWKjECnl8jGeKQ7oBUBNwobZ+W0S6b1Bd1o6jYRTynmsKJE0umMRjMijJRnMf+PFvI7hifoR51pFZOuX0FIgSucUXBTTRxtZXEVIjmj6sczPGps2Z1yL5T0FVBTZVGE6npiykI/cH2NWp+cj3+5Wdxf7OU7qEyn3GZFQU+h7ukW2QNRVKCn2W5MkPqlx0cQbs+U4moyNe3MTbd9aKWMNMhNGpq99f5O1a7xd/yQxfwR/dYPQb/1UIXVClzgMaIOLK2yrbPb5ixCggZxgeZxJPRI+tVVhXgvzCm0oFZUWYWXz+48V/KqMLgRLBx7V6i2EbNLHhnAo7d7KomHHplLBAhA+Nz65dXt6QJ1t3vtxAL7fGl49S+LR/bP/NYSeO/ELHHxH2jO12DumJHVWmmx91stA/sSI+e3OxLd5IWnlfC5k6ElB/p2XFFe+XLep8/V71q1ZOMSat7AoXxk2Pb5F76j7zCS3O7akmnan/DXjiQP3FxQ+1PtzNk1r3V2WE5vOfHGw9//mVoxurdtztHTh3d/1y8d3Nu9mfztSPKv6icWWbemLMd/BG+PWpIL5ydGll0eXXY2ds12avDUC2999eLH3l1XX7qWj0V31mw7s0WpHRDP3Ih+03H8eu8no9mLp68mPpOeTTyv7ujefszf0frBm8M3N+85uXuPdmSGd9PQhV11Pyytu/TuYe7Uz7Mq3t9mr2pf0d12cNO+o/01rw89lRyy/HrpWPb36DMX8R3nK66cHBJeffwjIT98w2cvyPc354esQu8RAAA=');
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
    this._getItemResults(itemId);
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
                        Container(
//                          child: Image.network(snapshot.data.image.imageUrl),
                        ),
                        Text(snapshot.data.title, style: TextStyle(fontSize: 20.0)),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Text('Sold By: ' + snapshot.data.seller.username),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text('US \$' + snapshot.data.price.value, style: TextStyle(fontSize: 25.0)),
                        ),
                        Text('Description: ' + snapshot.data.description),
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
    final String authToken = ('Bearer v^1.1#i^1#I^3#r^0#f^0#p^1#t^H4sIAAAAAAAAAOVYbWwTZRxv124wXmYcBAkRUm5ojEuvz7W9rr3Qmu4NOl7arYOWGZj38tx67Hp33HOlK0RTRzK+4SsCH0xGgvGNJWIUTcRANAIxIkIkEE2GiUMxwgc+KBrD8O5aRjfJQNbgEvuluef5P//n9//9/v/nDeSrqp8cWDlwfa51RsVgHuQrrFZiNqiuqqyvsVUsqrSAEgPrYH5Z3t5vu7wc0WlRoTogUmQJQUdfWpQQZTYGsYwqUTKNBERJdBoiSmOpeHjNasqNA0pRZU1mZRFzRJqDGBdo4CBJQgZ4GxjI+/RW6ZbPTjmIMTxJ+hjWH6ADnI/zA70foQyMSEijJS2IuQERcBLASfg63QTlJim3B/d6yS7MsR6qSJAl3QQHWMiES5lj1RKsk0OlEYKqpjvBQpFwazwajjS3rO1c7irxFSryENdoLYPGfzXJHHSsp8UMnHwaZFpT8QzLQoQwV6gww3inVPgWmPuAb1Lt4xlANxBu0k8yRMDDl4XKVllN09rkOIwWgXPypikFJU3QcndjVGeD2QxZrfi1VncRaXYYf+0ZWhR4AapBrKUxvCEci2GhNjklSbmY7NQpF6SeppQz1tHs9DAegieAl3NCn9fj5zm2OFHBW5HmCTM1yRInGKQhx1pZa4Q6ajiRG6KEG90oKkXVMK8ZiErtPGMcgi5D1IKKGS0lGbrCtE6Ew/y8uwJjozVNFZiMBsc8TOwwKQpitKIIHDax08zFYvr0oSCW0jSFcrmy2Sye9eCy2uNyA0C4kmtWx9kUTNOYbmvUesFeuPsAp2CGwkJ9JBIoLafoWPr0XNUBSD1YyAuIBo+/yPt4WKGJrf9oKInZNb4iylUhAT/DcTQIBPwEIP1cOQokVMxRlwEDMnTOmabVXqgpIs1CJ6unWSYNVYGjPCTv1nMUOjlfgHd6AzzvZEjO5yR4CAGEDMMG/P+nOrnXTI9DVoVaWVK9bGkeywm9sCWZzJL1K32xlvCGREMjx0td8fqmVes6Ai3JLp+faWxHqxp6gvdaDHcOnpUVGJNFgc2VgwGj1svHgkflYrSq5eJQFPWGKQWKjECnl8jGeKQ7oBUBNwobZ+W0S6b1Bd1o6jYRTynmsKJE0umMRjMijJRnMf+PFvI7hifoR51pFZOuX0FIgSucUXBTTRxtZXEVIjmj6sczPGps2Z1yL5T0FVBTZVGE6npiykI/cH2NWp+cj3+5Wdxf7OU7qEyn3GZFQU+h7ukW2QNRVKCn2W5MkPqlx0cQbs+U4moyNe3MTbd9aKWMNMhNGpq99f5O1a7xd/yQxfwR/dYPQb/1UIXVClzgMaIOLK2yrbPb5ixCggZxgeZxJPRI+tVVhXgvzCm0oFZUWYWXz+48V/KqMLgRLBx7V6i2EbNLHhnAo7d7KomHHplLBAhA+Nz65dXt6QJ1t3vtxAL7fGl49S+LR/bP/NYSeO/ELHHxH2jO12DumJHVWmmx91stA/sSI+e3OxLd5IWnlfC5k6ElB/p2XFFe+XLep8/V71q1ZOMSat7AoXxk2Pb5F76j7zCS3O7akmnan/DXjiQP3FxQ+1PtzNk1r3V2WE5vOfHGw9//mVoxurdtztHTh3d/1y8d3Nu9mfztSPKv6icWWbemLMd/BG+PWpIL5ydGll0eXXY2ds12avDUC2999eLH3l1XX7qWj0V31mw7s0WpHRDP3Ih+03H8eu8no9mLp68mPpOeTTyv7ujefszf0frBm8M3N+85uXuPdmSGd9PQhV11Pyytu/TuYe7Uz7Mq3t9mr2pf0d12cNO+o/01rw89lRyy/HrpWPb36DMX8R3nK66cHBJeffwjIT98w2cvyPc354esQu8RAAA=');
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
