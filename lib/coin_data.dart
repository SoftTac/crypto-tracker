import 'dart:convert';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'USD', 'EUR', 'GBP', 'JPY', 'AUD',
  'CAD', 'CHF', 'CNY', 'SEK', 'NZD',
  'MXN', 'SGD', 'HKD', 'NOK', 'KRW',
  'TRY', 'RUB', 'INR', 'BRL', 'ZAR'
];

const List<String> cryptoList = ['BTC', 'ETH', 'LTC', 'XRP', 'BNB'];

const Map<String, String> cryptoIcons = {
  'BTC': '₿',
  'ETH': 'Ξ',
  'LTC': 'Ł',
  'XRP': '✕',
  'BNB': '🅱',
};

class CoinData {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';

  Future<Map<String, String>> getCoinData(String selectedCurrency) async {
    final Map<String, String> cryptoPrices = {};
    final currency = selectedCurrency.toLowerCase();

    try {
      // Get all coins data in a single request
      final url = Uri.parse(
          '$_baseUrl/coins/markets?vs_currency=$currency&ids=bitcoin,ethereum,litecoin,ripple,binancecoin&order=market_cap_desc'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> coinsData = jsonDecode(response.body);

        for (final coinData in coinsData) {
          final symbol = coinData['symbol'].toUpperCase();
          if (cryptoList.contains(symbol)) {
            cryptoPrices[symbol] = coinData['current_price'].toStringAsFixed(2);
          }
        }

        // Ensure all cryptos have a value
        for (final crypto in cryptoList) {
          cryptoPrices.putIfAbsent(crypto, () => 'N/A');
        }
      } else {
        throw Exception('Failed to load: ${response.statusCode}');
      }
    } catch (e) {
      // If batch request fails, try individual requests
      await _fetchIndividualPrices(cryptoPrices, currency);
    }

    return cryptoPrices;
  }

  Future<void> _fetchIndividualPrices(
      Map<String, String> cryptoPrices,
      String currency
      ) async {
    const Map<String, String> coinIds = {
      'BTC': 'bitcoin',
      'ETH': 'ethereum',
      'LTC': 'litecoin',
      'XRP': 'ripple',
      'BNB': 'binancecoin',
    };

    for (final crypto in cryptoList) {
      try {
        final url = Uri.parse(
            '$_baseUrl/simple/price?ids=${coinIds[crypto]}&vs_currencies=$currency'
        );

        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final price = data[coinIds[crypto]]?[currency];
          cryptoPrices[crypto] = price?.toStringAsFixed(2) ?? 'N/A';
        } else {
          cryptoPrices[crypto] = 'Error';
        }
      } catch (e) {
        cryptoPrices[crypto] = 'Error';
      }
    }
  }
}