import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_weather2/screens/location_screen.dart';
import 'package:flutter_weather2/services/weather.dart';
import 'package:flutter_weather2/services/weather_data.dart';


class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}


class _LoadingScreenState extends State<LoadingScreen> {

  double? latitude;
  double? longitude;

  void getLocationData() async{
    WeatherModel weatherModel = new WeatherModel();
    var weatherData = await weatherModel.getLocationWeather();
    List<Weather> weatherList = await weatherModel.getLocationWeather2();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
      return LocationScreen(locationWeather: weatherData, weatherList: weatherList);
    }) , (route) => false);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationData();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitCubeGrid(
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}
