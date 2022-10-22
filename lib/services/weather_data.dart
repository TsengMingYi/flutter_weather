class Weather{
  int? _temp;
  int? _id;
  String? _cityName;
  String? _weatherMessage;
  String? _weatherIcon;
  String? _time;

  int getWeatherTemp(){
    return _temp!;
  }
  void setWeatherTemp(int temp){
    _temp = temp;
  }
  String getTime(){
    return _time!;
  }
  void setTime(String time){
    _time = time;
  }
  int getId(){
    return _id!;
  }
  void setId(int id){
    _id = id;
  }
  String getCityName(){
    return _cityName!;
  }
  void setCityName(String cityName){
    _cityName = cityName;
  }
  String getWeatherMessage(){
    return _weatherMessage!;
  }
  void setWeatherMessage(String weatherMessage){
    _weatherMessage = weatherMessage;
  }
  String getWeatherIcon(){
    return _weatherIcon!;
  }
  void setWeatherIcon(String weatherIcon){
    _weatherIcon = weatherIcon;
  }

}