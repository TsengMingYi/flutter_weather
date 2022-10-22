import 'dart:ui';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather2/constants.dart';
import 'package:flutter_weather2/screens/city_screen.dart';
import 'package:flutter_weather2/screens/weather_data_list.dart';
import 'package:flutter_weather2/services/weather.dart';
import 'package:flutter_weather2/services/weather_data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


class LocationScreen extends StatefulWidget {
  late final dynamic locationWeather;
  late final List<Weather> weatherList;
  LocationScreen(
      {required dynamic locationWeather, required List<Weather> weatherList}) {
    this.locationWeather = locationWeather;
    this.weatherList = weatherList;
  }

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String? weatherIcon;
  int? temp;
  String? cityName;
  String? weatherMessage;
  List<Weather> weatherList = [];
  stt.SpeechToText speech = stt.SpeechToText();
  bool _isListening = false;

  WeatherModel weather = new WeatherModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUI(widget.locationWeather, widget.weatherList);
  }

  void updateUI(dynamic weatherData, List<Weather> weatherList1) {
    setState(() {
      if (weatherData == null) {
        weatherIcon = "Error";
        weatherMessage = "unable to know";
        temp = 0;
        cityName = "";
        return;
      }
      var temp1 = weatherData['main']['temp'];
      temp = temp1.toInt();
      int id = weatherData['weather'][0]['id'];
      cityName = weatherData['name'];
      weatherIcon = weather.getWeatherIcon(id);
      weatherMessage = weather.getMessage(temp!);
      weatherList = weatherList1;
    });
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await speech.initialize(onStatus: (val) {
        print("onStatus: $val");
      }, onError: (val) {
        setState(() {
          _isListening = false;
        });
        print("onErroe: $val");
      });
      if (available) {
        Fluttertoast.showToast(msg: '請說出想查詢的地點');
        setState(() {
          _isListening = true;
          speech.listen(onResult: (val) {
            setState(() async {
              if(val.finalResult){
                if(speech.isNotListening){
                  setState((){
                    _isListening = false;
                  });
                }
                cityName = val.recognizedWords;
                if (cityName != null) {
                  var weatherData = await weather.getCityWeather(cityName!);
                  List<Weather> weatherList =
                  await weather.getCityWeather2(cityName!);

                  updateUI(weatherData, weatherList);
                }
              }
            });
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () async {
            Fluttertoast.showToast(msg: '定位中');
            var weatherData = await weather.getLocationWeather();
            List<Weather> weatherData1 = await weather.getLocationWeather2();
            // setState(() {
            //   widget.weatherList = weatherData1;
            // });
            updateUI(weatherData, weatherData1);
          },
          child: const Icon(Icons.near_me),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () async {
                String cityName = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return const CityScreen();
                }));
                if (cityName != null) {
                  var weatherData = await weather.getCityWeather(cityName);
                  List<Weather> weatherList =
                      await weather.getCityWeather2(cityName);
                  updateUI(weatherData, weatherList);
                }
              },
              child: const Icon(Icons.search),
            ),
          ),
        ],
        automaticallyImplyLeading: false,
        title: Center(child: Text(cityName!)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF27292D),Color(0xFF7CD8FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          // image: DecorationImage(
          //   image: const AssetImage('images/26786.png'),
          //   fit: BoxFit.cover,
          //   colorFilter: ColorFilter.mode(
          //       Colors.white.withOpacity(0.8), BlendMode.dstATop),
          // ),
        ),
        constraints: const BoxConstraints.expand(),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            '$temp°',
                            style: kTempTextStyle,
                          ),
                          Text(
                            '$weatherIcon️',
                            style: kConditionTextStyle,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Text(
                        "$weatherMessage in $cityName!",
                        textAlign: TextAlign.right,
                        style: kMessageTextStyle,
                      ),
                    ),
                    Container(
                      height: 100.0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return WeatherTile(
                            temp: weatherList[index].getWeatherTemp(),
                            cityName: weatherList[index].getCityName(),
                            weatherMessage:
                                weatherList[index].getWeatherMessage(),
                            weatherIcon: weatherList[index].getWeatherIcon(),
                            weatherTime: weatherList[index].getTime(),
                          );
                        },
                        itemCount: weatherList.length,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Colors.white,
        // glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
    );
  }
}

//
// double temp =  dataDecode['main']['temp'];
// int id = dataDecode['weather'][0]['id'];
// String cityName = dataDecode['name'];
