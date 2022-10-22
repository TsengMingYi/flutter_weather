import 'package:flutter/material.dart';

class WeatherTile extends StatefulWidget {
  late final int? temp;
  late final String? cityName;
  late final String? weatherMessage;
  late final String? weatherIcon;
  late final String? weatherTime;

  WeatherTile({required int temp,required String cityName,required String weatherMessage,required String weatherIcon,required String weatherTime}){
    this.temp = temp;
    this.cityName = cityName;
    this.weatherMessage = weatherMessage;
    this.weatherIcon = weatherIcon;
    this.weatherTime = weatherTime;
  }

  @override
  State<WeatherTile> createState() => _WeatherTileState();
}

class _WeatherTileState extends State<WeatherTile> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(child: Text("${widget.temp}°")),
          Expanded(child: Text(widget.weatherIcon.toString())),
          Expanded(child: Text(widget.cityName.toString())),
          Expanded(child: Text(widget.weatherMessage.toString())),
          Expanded(child: Text(widget.weatherTime.toString())),
        ],
      ),
    );
  }
}
