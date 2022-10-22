import 'package:flutter_weather2/services/location.dart';
import 'package:flutter_weather2/services/networking.dart';
import 'package:flutter_weather2/services/weather_data.dart';

const String apiKey = "f0eac5fa027900bf81a9803a98bfabac";
const openWeatherMapUrl = "https://api.openweathermap.org/data/2.5/weather";
const openWeatherMapUrl2 = "https://api.openweathermap.org/data/2.5/forecast";

class WeatherModel {

  Future<dynamic> getCityWeather(String cityName) async{
    String url = "$openWeatherMapUrl?q=$cityName&appid=$apiKey&lang=zh_tw&units=metric";
    NetworkHelper networkHelper = new NetworkHelper(url);
    var weatherData = await networkHelper.getData();
    return weatherData;
  }
  Future<List<Weather>> getCityWeather2(String cityName) async{
    String url = "$openWeatherMapUrl2?q=$cityName&appid=$apiKey&lang=zh_tw&units=metric";
    NetworkHelper networkHelper = new NetworkHelper(url);
    List<Weather> weatherList = await networkHelper.getDataDetail();
    return weatherList;
  }

  Future<dynamic> getLocationWeather() async{
    Location location = new Location();
    await location.getLocation();
    NetworkHelper networkHelper = new NetworkHelper("$openWeatherMapUrl?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric");
    var dataDecode = await networkHelper.getData();
    return dataDecode;
  }

  Future<List<Weather>> getLocationWeather2() async{
    Location location = new Location();
    await location.getLocation();
    NetworkHelper networkHelper = new NetworkHelper('$openWeatherMapUrl2?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric&lang=zh_tw');
    List<Weather> weatherList = await networkHelper.getDataDetail();
    return weatherList;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return '來吃冰淇淋吧🍦';
      // return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return '來穿短褲短袖吧👕';
      // return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return '你需要圍巾🧣和手套🧤';
      // return 'You\'ll need 🧣 and 🧤';
    } else {
      return '以防萬一穿一件外套吧🧥';
      // return 'Bring a 🧥 just in case';
    }
  }
  int changeTime(String time){
    String s = time.substring(0,19);
    String s1 = s.substring(0,4);
    String s2 = s.substring(5,7);
    String s3 = s.substring(8,10);
    String s4 = s.substring(11,13);
    String s5 = s.substring(14,16);
    String s6 = s.substring(17,19);
    String s7 = s1+s2+s3+s4+s5+s6;
    int nowTime = int.parse(s7);
    return nowTime;
  }
}