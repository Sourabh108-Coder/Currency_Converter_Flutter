import 'package:currency_converter/currency_service.dart';
import 'package:flutter/material.dart';

class CurrencyMaterialPage extends StatefulWidget {
  const CurrencyMaterialPage({super.key});

  @override
  State<CurrencyMaterialPage> createState() => _CurrencyMaterialPage();
}

Future<double> conversionProcess(
  BuildContext context,
  String? toCurrency,
  String? fromCurrency,
  double amount,

) async {
  if (toCurrency == null || fromCurrency == null || amount <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Please Select Both The Currencies.",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
    return 0.0;
  } 

    if (toCurrency == fromCurrency) {
      return amount;
    } 
    
    final rates = await CurrencyService().getRates(fromCurrency);

    if(rates == null  || !rates.containsKey(toCurrency))
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch conversion rates.'),backgroundColor: Colors.red,),);
      return 0.0;
    } 

  return amount * rates[toCurrency]!;
}



class _CurrencyMaterialPage extends State<CurrencyMaterialPage> {
  TextEditingController textcontroller = TextEditingController();

  double result = 0.0;

  String? toSelectedCurrency;

  String? fromSelectedCurrency;

  List<String> currenciesList = ['USD', 'INR', 'EUR', 'JPY', 'GBP'];

  bool isLoading = false;

  @override
  void dispose() {
    textcontroller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,
        title: Text(
          "Currency Converter",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black38,
        centerTitle: true,
      ),
      backgroundColor: Color.fromRGBO(31, 41, 55, 1.0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${toSelectedCurrency == 'INR' ? 'INR' : (toSelectedCurrency == 'USD' ? 'USD' : (toSelectedCurrency == 'JPY' ? 'JPY' : (toSelectedCurrency == 'GBP' ? 'GBP' : (toSelectedCurrency == 'EUR' ? 'EUR' : 'N/A'))))}: ${toSelectedCurrency == 'INR' ? '₹' : (toSelectedCurrency == 'USD' ? '＄' : (toSelectedCurrency == 'JPY' ? '¥' : (toSelectedCurrency == 'GBP' ? '£' : (toSelectedCurrency == 'EUR' ? '€' : '- -'))))} ${result != 0 ? result.toStringAsFixed(2) : "0"}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 38.8,
                color: Color.fromRGBO(255, 255, 255, 1.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                controller: textcontroller,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(52, 211, 153, 1.0),
                  fontSize: 20.0,
                ),
                decoration: InputDecoration(
                  hintText: "Enter The Amount",
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(52, 211, 153, 1.0),
                  ),
                  prefixIcon: Icon(
                    fromSelectedCurrency == 'USD'
                        ? Icons.monetization_on_sharp
                        : (fromSelectedCurrency == 'INR'
                              ? Icons.currency_rupee_sharp
                              : (fromSelectedCurrency == 'EUR'
                                    ? Icons.euro_sharp
                                    : (fromSelectedCurrency == 'JPY'
                                          ? Icons.currency_yen_sharp
                                          : (fromSelectedCurrency == 'GBP'
                                                ? Icons.currency_pound_sharp
                                                : Icons.help_outline)))),
                  ),
                  prefixIconColor: Color.fromRGBO(52, 211, 153, 1.0),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(52, 211, 153, 1.0),
                      width: 2.0,
                      style: BorderStyle.solid,
                      strokeAlign: BorderSide.strokeAlignCenter,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(52, 211, 153, 1.0),
                      width: 2.0,
                      style: BorderStyle.solid,
                      strokeAlign: BorderSide.strokeAlignCenter,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),

                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 10, 20),
                  child: Container(
                    width: 170.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromRGBO(52, 211, 153, 1.0),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.only(
                      left: 5,
                    ), // ✅ use symmetric padding
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(52, 211, 153, 1.0),
                          fontSize: 15.0,
                        ),
                        isExpanded: true, // ✅ makes it fill the container
                        hint: Text(
                          "From",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(52, 211, 153, 1.0),
                            fontSize: 15.0,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(5),
                        menuWidth: 200.0,
                        menuMaxHeight: 200.0,
                        elevation: 10,
                        value: fromSelectedCurrency,
                        items: currenciesList.map((String currency) {
                          return DropdownMenuItem<String>(
                            value: currency,
                            child: Text(currency),
                          );
                        }).toList(),
                        onChanged: (String? newCurrency) {
                          setState(() {
                            fromSelectedCurrency = newCurrency!;
                            result = 0.0;
                          });
                        },
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 10, 20),
                  child: Container(
                    width: 170.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromRGBO(52, 211, 153, 1.0),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.only(
                      left: 5,
                    ), // ✅ use symmetric padding
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(52, 211, 153, 1.0),
                          fontSize: 15.0,
                        ),
                        isExpanded: true, // ✅ makes it fill the container
                        hint: Text(
                          "To",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(52, 211, 153, 1.0),
                            fontSize: 15.0,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(5),
                        menuWidth: 200.0,
                        menuMaxHeight: 200.0,
                        elevation: 10,
                        value: toSelectedCurrency,
                        items: currenciesList.map((String currency) {
                          return DropdownMenuItem<String>(
                            value: currency,
                            child: Text(currency),
                          );
                        }).toList(),
                        onChanged: (String? newCurrency) {
                          setState(() {
                            toSelectedCurrency = newCurrency!;
                            result = 0.0;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
              child: ElevatedButton(
                onPressed: () async {
                  final input = textcontroller.text.trim();
                  final amount = double.tryParse(input);

                  if (amount == null || amount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Please Enter a Valid Amount.",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  setState(() => isLoading = true);

                  final value = await conversionProcess(
                    context,
                    toSelectedCurrency,
                    fromSelectedCurrency,
                    double.parse(textcontroller.text),
                  );
                  

                  setState(() {
                    result = value;
                    isLoading = false;
                  });
                },
                style: ButtonStyle(
                  elevation: WidgetStatePropertyAll(38.0),
                  backgroundColor: WidgetStatePropertyAll(
                    Color.fromRGBO(52, 211, 153, 1.0),
                  ),
                  foregroundColor: WidgetStatePropertyAll(Colors.black87),
                  fixedSize: WidgetStatePropertyAll(Size(410, 50)),
                  textStyle: WidgetStatePropertyAll(
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.black87,
                    ),
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: isLoading ? CircularProgressIndicator(color: Colors.black): Text("Convert the Amount"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
