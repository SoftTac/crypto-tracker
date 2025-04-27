import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> with SingleTickerProviderStateMixin {
  String selectedCurrency = 'USD';
  Map<String, String> coinValues = {};
  bool isLoading = true;
  bool isRefreshing = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    fetchData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    if (isRefreshing) return;

    setState(() {
      isRefreshing = true;
      isLoading = true;
    });

    try {
      final data = await CoinData().getCoinData(selectedCurrency);
      if (data.isEmpty) {
        throw Exception('No data received');
      }
      setState(() {
        coinValues = data;
        isLoading = false;
        isRefreshing = false;
      });
      _animationController.forward(from: 0);
    } catch (e) {
      setState(() {
        isLoading = false;
        isRefreshing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
  Widget getPicker() {
    if (Platform.isIOS) {
      return CupertinoPicker(
        backgroundColor: Colors.transparent,
        itemExtent: 40.0,
        magnification: 1.2,
        onSelectedItemChanged: (selectedIndex) {
          setState(() => selectedCurrency = currenciesList[selectedIndex]);
          fetchData();
        },
        children: currenciesList.map((currency) {
          return Center(
            child: Text(
              currency,
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          );
        }).toList(),
      );
    } else {
      return DropdownButton<String>(
        value: selectedCurrency,
        dropdownColor: Colors.blue[800],
        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
        style: TextStyle(color: Colors.white, fontSize: 18),
        underline: Container(height: 2, color: Colors.white),
        onChanged: (value) {
          setState(() => selectedCurrency = value!);
          fetchData();
        },
        items: currenciesList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    }
  }

  Widget buildCryptoCard(String cryptoSymbol) {
    return CryptoCard(
      cryptoCurrency: cryptoSymbol,
      value: isLoading ? '?' : coinValues[cryptoSymbol] ?? 'Error',
      selectedCurrency: selectedCurrency,
      icon: cryptoIcons[cryptoSymbol] ?? '⁕',
    ).animate(controller: _animationController).fadeIn().slideY(
      begin: 0.5,
      end: 0,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: Text('Crypto Tracker',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isRefreshing
                ? Icons.refresh
                : Icons.refresh_outlined,
              color: Colors.white,
            ),
            onPressed: fetchData,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? ListView.builder(
              itemCount: cryptoList.length,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[800]!,
                  highlightColor: Colors.grey[700]!,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[800],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                );
              },
            )
                : ListView(
              children: cryptoList.map(buildCryptoCard).toList(),
            ),
          ),
          Container(
            height: 120,
            width: 180,
            decoration: BoxDecoration(
              color: Colors.blue[900],
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(
                    'Select Currency',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(child: getPicker()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    required this.value,
    required this.selectedCurrency,
    required this.cryptoCurrency,
    required this.icon,
  });

  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.blueGrey[800],
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Text(
                icon,
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cryptoCurrency,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '1 $cryptoCurrency = $value $selectedCurrency',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                value == '?' || value == 'Error'
                    ? Icons.error_outline
                    : Icons.attach_money,
                color: value == '?' ? Colors.amber
                    : value == 'Error' ? Colors.red
                    : Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
