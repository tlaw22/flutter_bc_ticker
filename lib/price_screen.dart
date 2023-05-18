import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
const apiKey = '6109C0F8-D4A9-403F-BC6D-395C6661F7DB';
const apiURL = 'https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=6109C0F8-D4A9-403F-BC6D-395C6661F7DB';
class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrancy = 'AUD';
//   String selectedCurrency = 'AUD';
  DropdownButton<String> androidDropdown() {

    List<DropdownMenuItem<String>> dropDownItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      String currency = (currenciesList[i]);
      var newitem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      dropDownItems.add(newitem);
    }

    return DropdownButton<String>(
      value: selectedCurrancy,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          getData();
          selectedCurrancy = value!;
        });
        print(value);
      },
    );
  }
  CupertinoPicker iOSPicker(){
    // Use the loop to create a list
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex) {
          print(selectedIndex);
        },
        children: pickerItems,
    );
  }

  String bitcoinValue = '?';
  // create get data async method
  void getData() async {
    try {
      var data = await CoinData().getCoinData(selectedCurrancy);
      //13. We can't await in a setState(). So you have to separate it out into two steps.
      setState(() {
        bitcoinValue = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    //14. Call getData() when the screen loads up. We can't call CoinData().getCoinData() directly here because we can't make initState() async.
    getData();
  }
 // I debug in chrome so this was unnecessary
    getPicker() {
      if(Platform.isIOS){
        return iOSPicker();
      } else if (Platform.isAndroid){
        return androidDropdown();
      } else {
        return androidDropdown();
      }
    }

  // List<DropdownMenuItem<String>> getDropDownItems() {}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child:  Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $bitcoinValue',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            // child: Platform.isIOS ? iOSPicker() : androidDropdown(),
            child: androidDropdown(),
          ),
        ],
      ),
    );
  }
}
