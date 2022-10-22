import 'dart:async';
import 'package:flutter_weather2/services/weather.dart';
import 'package:flutter_weather2/services/weather_data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'dart:convert';
class NetworkHelper{
  NetworkHelper(this.url){}
  final String url;
  Future getData() async{
    Response response = await get(Uri.parse(url));
    if(response.statusCode == 200){
      String data = response.body;
      return jsonDecode(data);
    }else{
      print(response.statusCode);
    }
  }

  Future getDataDetail() async{
    List<Weather> weatherList = [];
    Response response = await get(Uri.parse(url));
    WeatherModel weatherModel = new WeatherModel();
    int nowTime = weatherModel.changeTime(DateTime.now().toString());
    if(response.statusCode == 200){
      String data = response.body;
      int cnt = jsonDecode(data)['cnt'];
      for(int i = 0;i<cnt;i++){
        String time = jsonDecode(data)['list'][i]['dt_txt'];
        int time1 = weatherModel.changeTime(time);
        if(time1 > nowTime){
          Weather weather = new Weather();
          var newweatherTemp = jsonDecode(data)['list'][i]['main']['temp'];
          weather.setWeatherTemp(newweatherTemp.toInt());
          weather.setCityName(jsonDecode(data)['city']['name']);
          weather.setId(jsonDecode(data)['list'][i]['weather'][0]['id']);
          weather.setWeatherMessage(weatherModel.getMessage(weather.getWeatherTemp().toInt()));
          weather.setWeatherIcon(weatherModel.getWeatherIcon(weather.getId()));
          weather.setTime(time);
          weatherList.add(weather);
        }
      }
      // list[0].main.temp
      return weatherList;
    }else{
      Fluttertoast.showToast(msg: '無法識別');
      print(response.statusCode);
    }
  }
}