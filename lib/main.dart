import 'package:flutter/material.dart';
import 'package:coding_challenge/detailed_item.dart';
import 'package:coding_challenge/utils/auth.dart';
import 'package:dio/dio.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coding Challenge',
      theme: ThemeData(
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
  String authToken, nextURL;
  Icon _queryIcon = Icon(Icons.search);
  ScrollController _scrollControler = ScrollController();
  bool isLoading = false;

  EbaySearchState() {}

  @override
  void initState() {
    super.initState();
    _scrollControler.addListener(() {
      // If reach the bottom of ListView, call _loadMoreData()
      if(_scrollControler.position.pixels == _scrollControler.position.maxScrollExtent) {
        loadMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollControler.dispose();
    super.dispose();
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
          hintText: 'Tap here to search...',
          hintStyle: TextStyle(color: Colors.white),
        ),
        onSubmitted: (_queryText) {
          if(_queryText.isNotEmpty) {
            getQueryResults(_queryText);
          }
        },
        style: TextStyle(
            color: Colors.white),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    return ListView.separated(
      itemCount: items == null ? 0 : items.length + 1, // +1 to account for progress bar
      itemBuilder: (BuildContext context, int idx) {
        if(idx == items.length) {
          return _buildProgressIndicator();
        }
        else {
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
        }
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
      controller: _scrollControler,
    );
  }

  // Build the query URL based on what user entered
  String buildQueryURL(String _queryText) {
    final String _finalURL = _queryURL + 'q=' + _queryText;
    return _finalURL;
  }

  // Get results from eBay API with query text
  Future<Response> getQueryResults(String _queryText) async {
    String encoded = ClientAuth().generateEncodedCredentials();
    authToken = await ClientAuth().getAuthorizationToken(encoded);
    dio.options.headers = {'Authorization' : authToken};

    try {
      final Response response = await dio.get<void>(buildQueryURL(_queryText));
      print(response);
      nextURL = response.data['next'];
      final List resultsList = List();
      for(int i=0; i<response.data['itemSummaries'].length; i++) {
        resultsList.add(response.data['itemSummaries'][i]);
      }
      _scrollControler.animateTo(_scrollControler.position.minScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);

      setState(() {
        items = resultsList;
        isLoading = false;
      });
      return response;
    } catch (e) {
      print(e);
      return e;
    }
  }

  // Load more data from original API call's 'next' url
  void loadMoreData() async {
    print('_loadMoreData() called, isLoading is ' + isLoading.toString());
    if(!isLoading) {
      setState(() {
        isLoading = true;
      });

      try {
        dio.options.headers = {'Authorization' : authToken};
        final Response response = await dio.get(nextURL);
        nextURL = response.data['next'];
        print(response);
        final List resultsList = List();
        for(int i=0; i<response.data['itemSummaries'].length; i++) {
          resultsList.add(response.data['itemSummaries'][i]);
        }
        setState(() {
          isLoading = false;
          items.addAll(resultsList);
        });
      } catch (e) {
        print(e);
      }
    }
  }
}

class EbaySearch extends StatefulWidget {
  @override
  EbaySearchState createState() => EbaySearchState();
}