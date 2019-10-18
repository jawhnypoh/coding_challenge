import 'package:flutter/material.dart';
import 'package:coding_challenge/models/info_model.dart';
import 'package:coding_challenge/utils/auth.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:async';

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
                              child: Text('Est. Delivery ' + DateFormat('EEE, MMM d').format(snapshot.data.shippingOptions[0].minEstimatedDeliveryDate) + ' - ' + DateFormat('EEE, MMM d').format(snapshot.data.shippingOptions[0].maxEstimatedDeliveryDate)),
                            ),
                            Divider(color: Colors.grey),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                              child: Text('Sold By: ' + snapshot.data.seller.username, style: TextStyle(fontSize: 15.0),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text('Condition: ' + snapshot.data.condition, style: TextStyle(fontSize: 15.0)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text('Brand: ' + snapshot.data.brand, style: TextStyle(fontSize:  15.0)),
                            ),
                            Divider(color: Colors.grey),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                              child: Text('Item Description: ', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                            ),
                            Text(snapshot.data.description, style: TextStyle(fontSize: 15.0)),
                          ],
                        )
                    );
                  }
                  else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
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

class DetailedItem extends StatefulWidget {
  // Declare itemId that holds itemId
  final String itemId;

  // Require an ItemId in the constructor
  DetailedItem({Key key, @required this.itemId}) : super(key: key);

  @override
  DetailedItemState createState() => DetailedItemState(itemId);
}