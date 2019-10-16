import 'package:flutter/material.dart';
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

  EbaySearchState() {
//    _query.addListener(() {
//      if(_query.text.isEmpty) {
//        setState(() {
//          _queryText = '';
//        });
//      }
//      else {
//        setState(() {
//          _queryText = _query.text;
//        });
//      }
//    });
  }

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
    final String authToken = 'Bearer v^1.1#i^1#I^3#f^0#p^1#r^0#t^H4sIAAAAAAAAAOVYb2wTZRhf9w8GDAwxukyD9ZAPOO/63l17115oSdeObDC2sm5zLCK5P2/Xs+3d5d47Rk3UZcIGxIjRkIyIyYhoogYBE0P84BfEmUwElJAJHzRRSVSUOBZDCBC9u5bRTTKQNbjEfmnueZ/3eX/P7/c87/vegb7KqicHGgeuVLvmlQ73gb5Sl4tcCKoqK+oWl5XWVpSAAgfXcN8TfeX9ZT+vQnwmrXFtEGmqgqB7ayatIM4xBjFTVziVRzLiFD4DEWeIXDy8vpmjCMBpumqooprG3E3RIOb3kRSg/CItCBQQJcuo3AzZrgYxHw+9/gRFBfws6w/wjDWOkAmbFGTwihHEKEAGcBLgJNMOWI7ycjRFsBTTjbk7oY5kVbFcCICFHLScM1cvgDozUh4hqBtWECzUFF4Tbw03RRta2ld5CmKF8jTEDd4w0dSniCpBdyefNuHMyyDHm4uboggRwjyh3ApTg3Lhm2DuAb7DNG2xCKEfsMAb8PsYtihUrlH1DG/MjMO2yBKecFw5qBiykb0ToxYbwnNQNPJPLVaIpqjb/ttg8mk5IUM9iDXUhzeGYzEstFZNKko2puIW5bLSE0nisbYoTgs0mSCBV8Ih46X9CUnML5SLlqd52koRVZFkmzTkblGNemihhtO5IQu4sZxalVY9nDBsRIV+gZsckr5uW9SciqaRVGxdYcYiwu083lmBydmGocuCacDJCNMHHIqCGK9psoRNH3RqMV8+W1EQSxqGxnk8vb29RC9NqHqPhwKA9HStb46LSZjhMdvX7nXHX77zBFx2UhGhNRPJnJHVLCxbrVq1ACg9WMgLSJb253mfCis03foPQ0HOnqkdUawO8Qoi6RUYryQmKEaCVDE6JJQvUo+NAwp8Fs/wegoaWpoXIS5adWZmoC5LHO1LUFaRQlxiAgncG0gkcMEnMTiZgBBAKAhiwP9/apS7LfU4FHVoFKfWi1Xnsaycgg1dXb2+ukYm1hDe+DRbLyWU7nhdZF1HW6Chq5vxC/Ub0Dq2J3i33XD75EVVgzE1LYvZYjBg93rxWKB1KcbrRjYO02nLMKtEkZ3o3BLZno+sALwmE3ZjE6Ka8ai8taPbps0O4lnlHNa0pkzGNHghDZuKtJv/Nzv5bdOTrbvOnMrJ0i8npCzlLimEoyaBtoiEDpFq6tb9jGi1z+x2NQUVawc0dDWdhnonOWuh77u+uXN9Jj7+5WFxb7kX8aYyh2pbTMtWCW2ea5ndF0Vlfo6dxqSPJSkSMCw1q7wijqbt2bl2DjWqyIDSjKmVr7m3a7Vn6jt+qMT5kf2uj0G/60ipywU8YAW5HDxeWdZRXraoFskGJGQ+QSC5R7HeXXVIpGBW42W9tNIlv/7N4NmCrwrDm0DN5HeFqjJyYcFHBvDorZEKcsnD1WSABCQDWMpLU91g+a3RcvKh8gdLdqLdV4+VNY5envCFjoy98IV/JAyqJ51croqS8n5XyQImAsYv/Tk0sqNz8dKPdi/ZtL3tjd9fPs+O/jE2cL17weC3Sw4e33nyLU/Np+f41al9oyWpd/aO+B77q+6TGrqh4uszQ0fPd35GHbhWFdpF7AhvO3N62XDdxSvJlq9+wV5/D9SPa/u2p/bMO/Pjlp+W35hY+ciu+cPV0VPj310/9u7+A7XPdJT+EPv81z1nW0bHBsiO+U+FtiS/X5Sq2Y83xysOR6ODe33Xmlcuu3EJvfLBiJg8eOolc/DqhbXvv9m7etzsPC00Hj02OiTWTCx8+9nT60/ATcnRbRdo8gFA04cub5/Ye+LQivYW88ML617b5x9kh47PP3z1UEfky5MXx2qXvrj5VfXc85nfcvL9Dfr7GjHvEQAA';
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
      body: createItem(),
    );
  }

  Widget createItem() {
    return Scaffold(
        body: Center(
          child: FutureBuilder<Info>(
              future: _getItemResults(itemId),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Text(snapshot.data.title),
                        Text(snapshot.data.subtitle),
                        Text(snapshot.data.itemId),
                      ],
                    )
                  );
                }
                else {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              }
          ),
        ),
    );
  }

//  Widget createItem() {
//    return Scaffold(
//        body: ListView(
//          children: <Widget>[
//            ListTile(
//              contentPadding: EdgeInsets.all(10.0),
//              title: Text('Title',
//                style: TextStyle(
//                    fontSize: 25.0),
//              ),
//          subtitle: Text(info.subtitle),
//            )
//          ],
//        )
//    );
//  }

  // Build the item detailed URL based on itemID
  String _buildItemURL(String itemId) {
    final String _finalURL = _itemURL + itemId;
    print('_finalURL is: ' + _finalURL);
    return _finalURL;
  }

  Future<Info> _getItemResults(String itemId) async {
    print('_getItemResults() called ');
    final String authToken = 'Bearer v^1.1#i^1#I^3#f^0#p^1#r^0#t^H4sIAAAAAAAAAOVYb2wTZRhf9w8GDAwxukyD9ZAPOO/63l17115oSdeObDC2sm5zLCK5P2/Xs+3d5d47Rk3UZcIGxIjRkIyIyYhoogYBE0P84BfEmUwElJAJHzRRSVSUOBZDCBC9u5bRTTKQNbjEfmnueZ/3eX/P7/c87/vegb7KqicHGgeuVLvmlQ73gb5Sl4tcCKoqK+oWl5XWVpSAAgfXcN8TfeX9ZT+vQnwmrXFtEGmqgqB7ayatIM4xBjFTVziVRzLiFD4DEWeIXDy8vpmjCMBpumqooprG3E3RIOb3kRSg/CItCBQQJcuo3AzZrgYxHw+9/gRFBfws6w/wjDWOkAmbFGTwihHEKEAGcBLgJNMOWI7ycjRFsBTTjbk7oY5kVbFcCICFHLScM1cvgDozUh4hqBtWECzUFF4Tbw03RRta2ld5CmKF8jTEDd4w0dSniCpBdyefNuHMyyDHm4uboggRwjyh3ApTg3Lhm2DuAb7DNG2xCKEfsMAb8PsYtihUrlH1DG/MjMO2yBKecFw5qBiykb0ToxYbwnNQNPJPLVaIpqjb/ttg8mk5IUM9iDXUhzeGYzEstFZNKko2puIW5bLSE0nisbYoTgs0mSCBV8Ih46X9CUnML5SLlqd52koRVZFkmzTkblGNemihhtO5IQu4sZxalVY9nDBsRIV+gZsckr5uW9SciqaRVGxdYcYiwu083lmBydmGocuCacDJCNMHHIqCGK9psoRNH3RqMV8+W1EQSxqGxnk8vb29RC9NqHqPhwKA9HStb46LSZjhMdvX7nXHX77zBFx2UhGhNRPJnJHVLCxbrVq1ACg9WMgLSJb253mfCis03foPQ0HOnqkdUawO8Qoi6RUYryQmKEaCVDE6JJQvUo+NAwp8Fs/wegoaWpoXIS5adWZmoC5LHO1LUFaRQlxiAgncG0gkcMEnMTiZgBBAKAhiwP9/apS7LfU4FHVoFKfWi1Xnsaycgg1dXb2+ukYm1hDe+DRbLyWU7nhdZF1HW6Chq5vxC/Ub0Dq2J3i33XD75EVVgzE1LYvZYjBg93rxWKB1KcbrRjYO02nLMKtEkZ3o3BLZno+sALwmE3ZjE6Ka8ai8taPbps0O4lnlHNa0pkzGNHghDZuKtJv/Nzv5bdOTrbvOnMrJ0i8npCzlLimEoyaBtoiEDpFq6tb9jGi1z+x2NQUVawc0dDWdhnonOWuh77u+uXN9Jj7+5WFxb7kX8aYyh2pbTMtWCW2ea5ndF0Vlfo6dxqSPJSkSMCw1q7wijqbt2bl2DjWqyIDSjKmVr7m3a7Vn6jt+qMT5kf2uj0G/60ipywU8YAW5HDxeWdZRXraoFskGJGQ+QSC5R7HeXXVIpGBW42W9tNIlv/7N4NmCrwrDm0DN5HeFqjJyYcFHBvDorZEKcsnD1WSABCQDWMpLU91g+a3RcvKh8gdLdqLdV4+VNY5envCFjoy98IV/JAyqJ51croqS8n5XyQImAsYv/Tk0sqNz8dKPdi/ZtL3tjd9fPs+O/jE2cL17weC3Sw4e33nyLU/Np+f41al9oyWpd/aO+B77q+6TGrqh4uszQ0fPd35GHbhWFdpF7AhvO3N62XDdxSvJlq9+wV5/D9SPa/u2p/bMO/Pjlp+W35hY+ciu+cPV0VPj310/9u7+A7XPdJT+EPv81z1nW0bHBsiO+U+FtiS/X5Sq2Y83xysOR6ODe33Xmlcuu3EJvfLBiJg8eOolc/DqhbXvv9m7etzsPC00Hj02OiTWTCx8+9nT60/ATcnRbRdo8gFA04cub5/Ye+LQivYW88ML617b5x9kh47PP3z1UEfky5MXx2qXvrj5VfXc85nfcvL9Dfr7GjHvEQAA';
    dio.options.headers = {'Authorization' : authToken};
    try {
      final Response response = await dio.get<void>(_buildItemURL(itemId));
      print(response);
      final jsonResult = json.decode(response.toString());
      parsedJson = response.toString();
//        info = Info.fromJson(jsonResult);
//        print('Title: ' + info.title);
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

class Info {
  String itemId;
  String title;
  String subtitle;

  Info({
    this.itemId,
    this.title,
    this.subtitle,
  });

  factory Info.fromJson(Map<String, dynamic> parsedJson) {
    return Info(
      itemId: parsedJson['itemId'],
      title: parsedJson['title'],
      subtitle: parsedJson['subtitle']
    );
  }

  Map<String, dynamic> toJson() => {
    'itemId': itemId,
    'title': title,
    'subtitle': subtitle,
  };
}