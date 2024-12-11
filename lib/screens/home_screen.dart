import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather/screens/forecast_screen.dart';
import 'package:weather/services/weather_service.dart';

class home_screen extends StatefulWidget {
  const home_screen({super.key});

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  final WeatherServices _wetherservices=WeatherServices();
  String _city='Herat';
  Map<String,dynamic>? _curentwether;

  @override
  void initState() {
    super.initState();
    fetchweathre();
  }

  Future<void> fetchweathre()async{
    try{
      final weatherdate=await _wetherservices.fetchCurrentWeather(_city);
      setState(() {
        _curentwether=weatherdate;
      });
    }catch(e){
      print(e);
    }
  }

  void showcityselectiondialog(){
    showDialog(context: context, builder:(BuildContext context) {
      return AlertDialog(
        title:Text("Enter your city name"),
        content: TypeAheadField(
          suggestionsCallback: (pattern)async{
            return await _wetherservices.fetchCitySuggestion(pattern);
          },
          builder: (context,controller,focusname){
            return TextFormField(
              controller: controller,
              focusNode: focusname,
              autofocus: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(

                ),
                labelText: "City"
              ),
            );
          },
          itemBuilder: (context ,suggestion){
            return ListTile(title: Text(suggestion["name"]),);
          },
          onSelected: (city){
            setState(() {
              _city=city["name"];
            });
          },
        ),
        actions: [
          TextButton(onPressed:(){
            Navigator.pop(context);
          }, child: Text("Cancel")),
          TextButton(onPressed:(){
            Navigator.pop(context);
            fetchweathre();
          }, child: Text("Submit"))
        ],
      );
    },);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _curentwether==null? Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors:[
                Color(0xFF1A2324),
                Color.fromARGB(255, 125, 32, 142),
                Colors.purple,
                Color.fromARGB(255, 151, 44, 170 ),
              ]

          )
        ),
        child:Center(
          child: CircularProgressIndicator(color: Colors.blueAccent,),
        )
      ):Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors:[
                  Color(0xFF1A2324),
                  Color.fromARGB(255, 125, 32, 142),
                  Colors.purple,
                  Color.fromARGB(255, 151, 44, 170 ),
                ]
            )),
        child:ListView(
          children: [
            SizedBox(height: 10,),
            InkWell(
              onTap: showcityselectiondialog,
              child: Text(_city,style: GoogleFonts.lato(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),),
            ),
            Center(
              child:Column(
                children: [
                  Image.network("http:${_curentwether!["current"]["condition"]["icon"]}",
                  height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  Text("${_curentwether!["current"]["temp_c"].round()}C",style: GoogleFonts.lato(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),),
                  Text("${_curentwether!["current"]["condition"]["text"]}",
                    style: GoogleFonts.lato(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Max ${_curentwether!["forecast"]["forecastday"][0]["day"]['maxtemp_c'].round()}C",style: GoogleFonts.lato(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),),
                      Text("Min ${_curentwether!["forecast"]["forecastday"][0]["day"]['mintemp_c'].round()}C",style: GoogleFonts.lato(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment:MainAxisAlignment.spaceAround,
              children: [
                _buildweahterdetails(
                    "Sunrise", Icons.wb_sunny,
                _curentwether!["forecast"]["forecastday"][0]["astro"]
                ["sunrise"]
                ),
                _buildweahterdetails("Sunset", Icons.brightness_3,
                    _curentwether!["forecast"]["forecastday"][0]["astro"]
                    ["sunset"]
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment:MainAxisAlignment.spaceAround,
              children: [
                _buildweahterdetails(
                    "Humidity", Icons.opacity,
                    _curentwether!["current"]["humidity"]
                ),
                _buildweahterdetails(
                    "Wind  (KPH)", Icons.wind_power,
                    _curentwether!["current"]["wind_kph"]
                ),
              ],
            ),
            SizedBox(height: 20,),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1A2344),
                ),
                onPressed: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => forecast_screen(city: _city),));
              },child: Text("Next 7 Days",style: TextStyle(color: CupertinoColors.white),),),
            )
          ],
        ),
      ),
    );
  }
  Widget _buildweahterdetails(String label,IconData icon,dynamic value){
    return ClipRect(
      child: BackdropFilter(
        filter:ImageFilter.blur(sigmaX: 3,sigmaY: 3),
        child: Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
                colors:[
                  Color(0xFF1A2344).withOpacity(0.5),
                  Color(0xFF1A2344).withOpacity(0.2)
                ]),),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,color: CupertinoColors.white,),
              SizedBox(height: 8,),
              Text(label,style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 8,),
              Text(
                value is String ? value :value.toString(),
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.white,
              ),),
            ],
          ),
        ),
      ),
    );
  }
}
