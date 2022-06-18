import 'package:clima/services/location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

const apiKey = '53a323c07689400df8185afdc2574879';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double latitude;
  double longitude;
  var temperature;
  var condition;
  var city;
  var state;
  var wspeed;
  var country;
  var feelTemp;
  var humid;
  var press;
  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    Location location = Location();
    await location.getCurrentLocation();
    latitude = location.latitude;
    longitude = location.longitude;
    getData();
  }

  Future getData() async {
    var res = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&APPID=$apiKey&units=metric'));
    print(res.statusCode);
    var decodedata = jsonDecode(res.body);
    setState(() {
      this.temperature = decodedata['main']['temp'];
      this.condition = decodedata['weather'][0]['id'];
      this.city = decodedata['name'];
      this.state = decodedata['weather'][0]['description'];
      this.wspeed = decodedata['wind']['speed'];
      this.country = decodedata['sys']['country'];
      this.feelTemp = decodedata['main']['feels_like'];
      this.humid = decodedata['main']['humidity'];
      this.press = decodedata['main']['pressure'];
    });
  }

  var intHours = int.parse(DateFormat('kk').format(DateTime.now()));
  getDateTime(h) {
    if (h > 8 && h < 12) {
      return '🔅 Good Morning';
    } else if (h >= 12 && h < 16) {
      return '🔆 Good Afternoon';
    } else if (h >= 16 && h < 21) {
      return '🌙 Good Evening';
    } else {
      return '🌃 Good Night';
    }
  }
  
  var intIconHours = int.parse(DateFormat('kk').format(DateTime.now()));
  getIconData(i) {
    if (i > 8 && i < 12) {
      return Icons.wb_sunny_outlined;
    } else if (i >= 12 && i < 16) {
      return Icons.wb_sunny_sharp;
    } else if (i >= 16 && i < 20) {
      return Icons.nightlight_round;
    } else {
      return Icons.nights_stay_sharp;
    }
  }

  var imageHours = int.parse(DateFormat('kk').format(DateTime.now()));
  getImageData(p) {
    if (p > 8 && p < 12) {
      return AssetImage('images/morning.jpg');
    } else if (p >= 12 && p < 16) {
      return AssetImage('images/afternoon.jpg');
    } else if (p >= 16 && p < 20) {
      return AssetImage('images/evening.jpg');
    } else {
      return AssetImage('images/night1.jpg');
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm  -EEEEEEEEEE d MMMM').format(now);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        title: Center(
          child: GestureDetector(
            onTap: () {
              Geolocator.openAppSettings();
            },
            child: Column(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 35.0,
                ),
                Text(
                  'Allow Location',
                  style: GoogleFonts.lato(fontSize: 10.0),
                )
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search_outlined,
              size: 35.0,
              color: Colors.white,
            )),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Container(
              child: Icon(
                Icons.menu,
                size: 35.0,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image(
              image: getImageData(imageHours),
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black38,
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 120,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                      city == null?'...':city.toString() + ',' + country.toString(),
                      style: GoogleFonts.lato(
                          fontSize: 40.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                    child: Text(
                      formattedDate,
                      style:
                          GoogleFonts.lato(fontSize: 15.0, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      getDateTime(intHours),
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        decorationThickness: 10,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(16),
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border(
                          top: BorderSide(width: 0, color: Colors.transparent),
                        )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            height: 100.0,
                            width: double.infinity,
                            child: Icon(
                              getIconData(intIconHours),
                              size: 90,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Container(
                            child: Text(
                              temperature==null?'...':temperature.toString() + ' °C',
                              style: GoogleFonts.lato(
                                  fontSize: 65.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: Text(
                                'Feel Like :   ' + feelTemp.toString() + ' °C',
                                style: GoogleFonts.lato(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: Center(
                              child: Text(
                            state == null?'...':state.toString().toUpperCase(),
                            style: GoogleFonts.lato(
                                fontSize: 30.0, fontWeight: FontWeight.bold),
                          )),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(8),
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border(
                          top: BorderSide(width: 1, color: Colors.white),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Humidity',
                                  style: GoogleFonts.lato(fontSize: 20),
                                ),
                                SizedBox(
                                  width: 0,
                                ),
                                Text(
                                  'Wind',
                                  style: GoogleFonts.lato(fontSize: 20),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Pressure',
                                  style: GoogleFonts.lato(fontSize: 20),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.water_drop_sharp,
                                    size: 50,
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Icon(
                                    Icons.wind_power_outlined,
                                    size: 50,
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Icon(
                                    Icons.thermostat_auto_sharp,
                                    size: 50,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  humid == null?'...':humid.toString() + '  g/kg',
                                  style: GoogleFonts.lato(fontSize: 12.5),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  wspeed == null?'...':wspeed.toString() + '   kmph',
                                  style: GoogleFonts.lato(fontSize: 12.5),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  press == null?'...':press.toString() + '   hPa',
                                  style: GoogleFonts.lato(fontSize: 12.5),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}