import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/weather_service.dart';

class forecast_screen extends StatefulWidget {
  final String city;
  const forecast_screen({super.key, required this.city});

  @override
  State<forecast_screen> createState() => _forecast_screenState();
}

class _forecast_screenState extends State<forecast_screen> {
  final WeatherServices _wetherservices=WeatherServices();
  List<dynamic>? forecast;

  @override
  void initState() {
    super.initState();
    fetchforecast();
  }

  Future<void> fetchforecast()async{
    try{
      final forecastdate=await _wetherservices.fetch7dayforecast(widget.city);
      setState(() {
        forecast=forecastdate["forecast"]["forecastday"];
      });
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:Scaffold(
         body: forecast==null?Container(
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
           height: MediaQuery.of(context).size.height,
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
             child:SingleChildScrollView(
               child: Column(
                 children: [
                   Padding(padding:EdgeInsets.all(10),
                     child:Row(
                       children: [
                         InkWell(
                           onTap: (){
                             Navigator.pop(context);
                           },
                           child: Icon(Icons.arrow_back,color: CupertinoColors.white,size: 30,),
                         ),
                         SizedBox(width: 15,),
                         Text("7 Day forecast",style: GoogleFonts.lato(
                             fontSize: 30,
                             color: Colors.white,
                             fontWeight: FontWeight.bold
                         ),),
                       ],
                     ),
                   ),
                   ListView.builder(
                       physics: NeverScrollableScrollPhysics(),
                       shrinkWrap: true,
                       itemCount: forecast!.length,
                       itemBuilder:(context, index) {
                         final day=forecast![index];
                         String iconUrl="http:${day["day"]["condition"]["icon"]}";
                         return Padding(padding: EdgeInsets.all(10),
                         child:ClipRect(
                           child: BackdropFilter(
                             filter:ImageFilter.blur(sigmaX: 3,sigmaY: 3),
                             child: Container(
                               padding: EdgeInsets.all(5),
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
                               child:ListTile(
                                 leading: Image.network(iconUrl),
                                 title: Text("${day["date"]}\n ${day['day']["avgtemp_c"]}C",
                                     style:GoogleFonts.lato(
                                   fontSize: 20,
                                   color: CupertinoColors.white,
                                   fontWeight: FontWeight.bold
                                 )),
                                 subtitle: Text(day["day"]["condition"]["text"],
                                     style:GoogleFonts.lato(
                                     fontSize: 16,
                                     color: CupertinoColors.white,
                                     fontWeight: FontWeight.bold
                                 )),
                                 trailing: Text(" Max: ${day["day"]["maxtemp_c"]} C\n"
                                     " Min: ${day["day"]["mintemp_c"]} C",

                                     style:GoogleFonts.lato(
                                     fontSize: 16,
                                     color: CupertinoColors.white,
                                     fontWeight: FontWeight.bold
                                 )),
                               )
                             ),
                           ),
                         ),
                         );
                       },)
                 ],
               ),
             )
         ),
        )
    );
  }
}
