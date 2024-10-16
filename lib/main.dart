import 'package:flutter/material.dart';
import 'package:flutter_application_1/bloc/weather_bloc.dart';
import 'package:flutter_application_1/home_screen/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(future: _determinePosition(), builder: (context,snap){
        if(snap.hasData){
          return BlocProvider<WeatherBloc>(
        create: (context) => WeatherBloc()..add(FetchWeather(snap.data as Position)),
        child: const HomeScreen(),);
        }
        else{
          return Scaffold(body:Center(child: CircularProgressIndicator(),));
        }
      })
     
      );
   
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if(!serviceEnabled){
    return Future.error('Location services are disabled');
  }
  permission = await Geolocator.checkPermission();
  if(permission == LocationPermission.denied){
    permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.denied){
      return Future.error('Location Permissions are denied');
    }
  }
  if(permission == LocationPermission.deniedForever){
    return Future.error("Denied Forever");
  }
  return await Geolocator.getCurrentPosition();
}

