import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../models/stock_alert.dart';
import '../services/stock_service.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _companyController = TextEditingController();
  final StockService _stockService = StockService();

  double price = 0.0;
  String action = 'Buy';
  double threshold = 5.0;

  List<StockAlert> alerts = [];
  final List<String> nseStocks = [
    // Nifty 50
    'RELIANCE',
    'TCS',
    'HDFCBANK',
    'INFY',
    'ICICIBANK',
    'HINDUNILVR',
    'AXISBANK',
    'KOTAKBANK',
    'SBIN',
    'ITC',
    'LT',
    'BHARTIARTL',
    'HCLTECH',
    'TECHM',
    'ASIANPAINT',
    'MARUTI',
    'NESTLEIND',
    'SUNPHARMA',
    'TITAN',
    'POWERGRID',
    'TATAMOTORS',
    'TATASTEEL',
    'ULTRACEMCO',
    'ONGC',
    'COALINDIA',
    'BAJFINANCE',
    'BAJAJFINSV',
    'BEL',
    'DRREDDY',
    'EICHERMOT',
    'GRASIM',
    'HINDALCO',
    'HEROMOTOCO',
    'INDUSINDBK',
    'NTPC',
    'SBILIFE',
    'SHRIRAMFIN',
    'WIPRO',
    'TRENT',
    'JIOFIN',
    'ADANIENT',
    'ADANIPORTS',
    'APOLLOHOSP',
    'BAJAJ-AUTO',  // some APIs use dash
    'BRITANNIA',
    'BPCL',
    'CIPLA',
    'DIVISLAB',
    'ITC',
    'SIEMENS',
    'VELT',
    // Nifty Next‑50
    'ABB',
    'ADANIENSOL',
    'ADANIGREEN',
    'ADANIPOWER',
    'AMBUJACEM',
    'BAJAJHLDNG',
    'BAJAJHFL',
    'BANKBARODA',
    'BRITANNIA',  // duplicates ok
    'BOSCHLTD',
    'CANBK',
    'CGPOWER',
    'CHOLAFIN',
    'DABUR',
    'DIVISLAB',
    'DLF',
    'DMART',
    'GAIL',
    'GODREJCP',
    'HAVELLS',
    'HAL',
    'HYUNDAI',
    'ICICIGI',
    'ICICIPRULI',
    'INDHOTEL',
    'IOC',
    'INDIGO',
    'NAUKRI',
    'IRFC',
    'JINDALSTEL',
    'JSWENERGY',
    'LICI',
    'LODHA',
    'LTIM',
    'PIDILITIND',
    'PFC',
    'PNB',
    'RECLTD',
    'MOTHERSON',
    'SHREECEM',
    'SIEMENS',
    'SWIGGY',
    'TATAPOWER',
    'TORNTPHARM',
    'TVSMOTOR',
    'UNITDSPR',
    'VBL',
    'VEDL',
    'ZYDUSLIFE',
    'ADANITOTAL',    // Adani Total Gas
    'MARICO',
    'GAIL',
    'PFC',
    'IRFC',
    'CANBK',
    'PNB',
    'BPCL',
    'IOC',
    'NTPC',
    'LICI',
    'UNITDSPR',
    'VBL',
    'VEDL',
    'ZYDUSLIFE',
  ];

 


  void _saveAlert() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final alert = StockAlert(
        companyName: _companyController.text.trim(),
        price: price,
        action: action,
        threshold: threshold,
      );

      setState(() {
        alerts.add(alert);
        _companyController.clear();
      });

      _formKey.currentState!.reset();
    }
  }

  Widget _buildLivePriceTile(StockAlert alert) {
    return FutureBuilder<double?>(
      future: _stockService.getCurrentPrice(alert.companyName),
      builder: (context, snapshot) {
        String liveText = 'Fetching...';
        Color color = Colors.grey;

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            final livePrice = snapshot.data!;
            final diffPercent = ((livePrice - alert.price).abs() / alert.price) * 100;

            liveText = '₹${livePrice.toStringAsFixed(2)}\nChange: ${diffPercent.toStringAsFixed(2)}%';

            if (diffPercent >= alert.threshold) {
              color = Colors.redAccent;
              liveText = '🚨 $liveText';
            } else {
              color = Colors.green;
            }
          } else {
            liveText = 'Error';
            color = Colors.red;
          }
        }

        return ListTile(
          title: Text(alert.companyName),
          subtitle: Text('${alert.action} at ₹${alert.price} | Alert: ${alert.threshold}%'),
          trailing: Text(liveText, style: TextStyle(color: color, fontSize: 12)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📈 NSE Stock Alerts'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TypeAheadFormField<String>(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _companyController,
                      decoration: const InputDecoration(
                        labelText: 'Stock Symbol (NSE)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    suggestionsCallback: (pattern) {
                      return nseStocks
                          .where((stock) =>
                              stock.toLowerCase().contains(pattern.toLowerCase()))
                          .toList();
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(title: Text(suggestion));
                    },
                    onSuggestionSelected: (suggestion) {
                      _companyController.text = suggestion;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Select a stock symbol';
                      }
                      if (!nseStocks.contains(value)) {
                        return 'Please select from suggestions';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Buy/Sell Price',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Enter price' : null,
                    onSaved: (value) => price = double.parse(value!),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: action,
                    decoration: const InputDecoration(
                      labelText: 'Action',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Buy', 'Sell']
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setState(() => action = val!),
                    onSaved: (val) => action = val!,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Alert if change exceeds (%)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'Enter threshold' : null,
                    onSaved: (value) => threshold = double.parse(value!),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _saveAlert,
                    icon: const Icon(Icons.notifications_active),
                    label: const Text('Save Alert'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text('📋 Your Alerts:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Expanded(
              child: alerts.isEmpty
                  ? const Text('No alerts yet.')
                  : ListView.builder(
                      itemCount: alerts.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: _buildLivePriceTile(alerts[index]),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}