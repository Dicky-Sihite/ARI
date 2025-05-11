import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ResultScreen extends StatefulWidget {
  final String city;

  const ResultScreen({required this.city});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Map<String, dynamic>? currentData;
  List<dynamic> forecastList = [];
  bool isLoading = true;
  String? errorMessage;

  String getWeatherImage(String main) {
    switch (main.toLowerCase()) {
      case 'clear':
        return 'assets/images/sunny_icon.png';
      case 'clouds':
        return 'assets/images/cloudy_icon.png';
      case 'rain':
        return 'assets/images/rain_icon.png';
      case 'thunderstorm':
        return 'assets/images/thunder_icon.png';
      case 'snow':
        return 'assets/images/snow_icon.png';
      case 'mist':
      case 'fog':
      case 'haze':
        return 'assets/images/mist_icon.png';
      default:
        return 'assets/images/default_icon.png';
    }
  }

  final String apiKey = '889051f0740466d14f1698f0354d4599';

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      fetchWeather(widget.city);
    });
  }

  Future<void> fetchWeather(String city) async {
    final currentUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=id';
    final forecastUrl = 'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric&lang=id';

    try {
      final responses = await Future.wait([
        http.get(Uri.parse(currentUrl)),
        http.get(Uri.parse(forecastUrl))
      ]);

      if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
        final current = json.decode(responses[0].body);
        final forecast = json.decode(responses[1].body);
        setState(() {
          currentData = current;
          forecastList = forecast['list'].where((item) {
            return item['dt_txt'].toString().contains("12:00:00");
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Gagal mengambil data cuaca.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
  }

  Widget buildForecastCard(dynamic item) {
    final date = DateFormat('EEEE, d/M/yyyy', 'id_ID').format(DateTime.parse(item['dt_txt']));
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.lightBlue[200],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(date, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 4),
          Row(
            children: [
              Image.asset(
                getWeatherImage(item['weather'][0]['main']),
                width: 40,
              ),
              SizedBox(width: 10),
              Expanded(child: Text('${item['weather'][0]['description']}', style: TextStyle(color: Colors.white))),
            ],
          ),
          SizedBox(height: 6),
          Text('Suhu: Min ${item['main']['temp_min']}°C / Max ${item['main']['temp_max']}°C', style: TextStyle(color: Colors.white))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.city.toUpperCase())),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!, style: TextStyle(color: Colors.red)))
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.lightBlue[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cuaca Saat Ini', style: TextStyle(color: Colors.white)),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${currentData!['main']['temp'].round()}°C', style: TextStyle(fontSize: 36, color: Colors.white)),
                          Text('${currentData!['weather'][0]['description']}', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      Image.asset(
                        getWeatherImage(currentData!['weather'][0]['main']),
                        width: 60,
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [Icon(Icons.wb_sunny, color: Colors.yellow), SizedBox(width: 4), Text(DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(currentData!['sys']['sunrise'] * 1000)), style: TextStyle(color: Colors.white))]),
                      Row(children: [Icon(Icons.nights_stay, color: Colors.orange), SizedBox(width: 4), Text(DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(currentData!['sys']['sunset'] * 1000)), style: TextStyle(color: Colors.white))]),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoBox('Angin', '${currentData!['wind']['speed']} m/s', 'assets/images/wind_icon.png'),
                _infoBox('Suhu', '${currentData!['main']['temp']}°', 'assets/images/temp_icon.png'),
                _infoBox('Kelembapan', '${currentData!['main']['humidity']}%', 'assets/images/humidity_icon.png'),
              ],
            ),
            SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Prakiraan 5 Hari', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            SizedBox(height: 10),
            ...forecastList.map((item) => buildForecastCard(item)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _infoBox(String title, String value, String iconPath) {
    return Container(
      padding: EdgeInsets.all(12),
      width: 100,
      decoration: BoxDecoration(
        color: Colors.lightBlue[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Image.asset(iconPath, width: 32),
          SizedBox(height: 8),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.white)),
        ],
      ),
    );
  }
}
