import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class Location{
  double? latitude;
  double? longitude;

   Future<void> getLocation() async{
    try{
      Position position = await _determinePosition();
      latitude = position.latitude;
      longitude = position.longitude;
    }catch(e){
      print(e);
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        while(permission == LocationPermission.denied){
          Map<Permission, PermissionStatus> statuses = await [
            Permission.location,
          ].request();
          print(statuses[Permission.location]);
          if(statuses[Permission.location] == PermissionStatus.granted){
            print('hello');
            break;
          }
        }
        return await Geolocator.getCurrentPosition();
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      while(permission == LocationPermission.deniedForever){
        Map<Permission, PermissionStatus> statuses = await [
          Permission.location,
        ].request();
        print(statuses[Permission.location]);
        if(statuses[Permission.location] == PermissionStatus.granted){
          print('hello');
          break;
        }
      }
      return await Geolocator.getCurrentPosition();

      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}

