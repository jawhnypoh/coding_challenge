# eBay Coding Challenge App
An eBay browsing application that allows the user to search for any item that's available on eBay.com. This application was developed using [Flutter](https://flutter.dev/), and is compatible with both iOS and Android platforms. 

![eBay App Screenshots](https://i.imgur.com/ZBsrh3W.png)

## Application Features
- **Search:** Entering a keyword to search will return a list of results pulled from the `api.ebay.com/buy/browse/v1/item_summary/` endpoint
- **Infinite Scroll:** Reaching the end of the list (50 items by default from API) will generate another API call to load more results 
- **Detail Item Screen:** Tapping an item in the list goes to another screen that pulls detailed information about specific item from the `api.ebay.com/buy/browse/v1/item/` endpoint

## Libraries Used
- **[Dio](https://pub.dev/packages/dio)** for making API calls 
- **[Intl](https://pub.dev/packages/intl)** for using `DateFormat()` in item delivery implementation

## Instructions
You will need to provie your own `client_ID` and `client_secret` in order for the app to generate the proper credentials for the OAuth2 Authorization that is needed to access the endpoints. 
These variables are put in as Strings in the `ClientAuth` class that's found in `auth.dart`:
```dart
final String identifier = '<YOUR-CLIENT-ID>'
final String secret = '<YOUR-CLIENT-SECRET>'
```

## Bugs
There may be some screens that appear to load indefinitely, or that are red and show error messages. This only happens on rare ocassions and is the result of the API returning null values. Widgets cannot display null values, and so we get an error. \
The infinite loading bug is caused by the API returning null values for estimated shipping dates, and I couldn't figure out which values return null from the API call when the red error screen appears. 
