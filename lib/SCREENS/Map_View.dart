import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../MODELS/weather_model.dart';
import 'homepage.dart';

class MapView extends StatefulWidget {
  final double? latitude, longitude;
  const MapView({Key? key, this.latitude, this.longitude}) : super(key: key);
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late Future<Weather> _futureWeather;
  MapController controller = new MapController();
  @override
  void initState() {
    // latitude = widget.latitude!;
    // longitude = widget.longitude!;

    super.initState();
    if (latitude != null && longitude != null)
      _futureWeather = Weather.fetch(latitude, longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        FlutterMap(
          mapController: controller,
          options:
              MapOptions(center: LatLng(latitude, longitude), minZoom: 9.0),
          children: [
            TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c']),
            MarkerLayer(markers: [
              Marker(
                  width: 45.0,
                  height: 45.0,
                  point: LatLng(latitude, longitude),
                  builder: (context) => IconButton(
                      icon: const Icon(Icons.location_on),
                      color: Colors.red,
                      iconSize: 45.0,
                      onPressed: () {
                        print("Success");
                      }))
            ]),
          ],
        ),
        Positioned(
            left: 100,
            top: 30,
            right: 20,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: FutureBuilder<Weather>(
                future: _futureWeather,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final weather = snapshot.data!;
                    return Container(
                      constraints: BoxConstraints.expand(),
                      child: Row(
                        children: [
                          Image.network(
                            weather.iconUrl,
                            width: 100.0,
                          ),
                          Column(
                            children: [
                              Text(
                                '${weather.temperature.toString()}°C',
                                style: TextStyle(
                                    fontSize: 28,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                weather.description,
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return CircularProgressIndicator();
                },
              ),
            ))
      ]),
    );
  }
}
