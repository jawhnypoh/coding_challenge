import 'package:flutter/material.dart';
import 'package:coding_challenge/models/info_model.dart';
import 'package:coding_challenge/utils/auth.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:async';

import 'package:oauth2/oauth2.dart';

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
    return _finalURL;
  }

  // Get results from eBay API with query text
  void _getQueryResults(String _queryText) async {
    String encoded = ClientAuth().generateEncodedCredentials();
    String authToken = await ClientAuth().getAuthorizationToken(encoded);
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
        child: SingleChildScrollView(
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
                            child: Text('US \$' + snapshot.data.price.value, style: TextStyle(fontSize: 25.0)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text('Sold By: ' + snapshot.data.seller.username, style: TextStyle(fontSize: 15.0),),
                          ),
                          Text('Condition: ' + snapshot.data.condition, style: TextStyle(fontSize: 15.0)),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text('Description: ' + snapshot.data.description, style: TextStyle(fontSize: 15.0)),
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
      )
    );
  }

  // Build the item detailed URL based on itemID
  String _buildItemURL(String itemId) {
    final String _finalURL = _itemURL + itemId;
    return _finalURL;
  }

  // Get the item detail results from API call
  Future<Info> _getItemResults(String itemId) async {
    String encoded = ClientAuth().generateEncodedCredentials();
    String authToken = await ClientAuth().getAuthorizationToken(encoded);
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