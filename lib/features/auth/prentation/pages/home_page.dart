import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_green/core/theme/app_palette.dart';
import 'package:go_green/features/auth/app_auth_context.dart';
import '../../../../core/secrets/config.dart'; // Import the config file

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static route() => MaterialPageRoute(builder: (context) => const HomePage());

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  String _estimatedEmissions = "";
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  bool _mapLoaded = false;

  // Initial camera position (Mumbai coordinates)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(19.0760, 72.8777), // Mumbai coordinates
    zoom: 11,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(10.0),
        child: AppBar(
          backgroundColor: AppPallete.backgroundColor,
        ),
      ),
      body: Stack(children: [
        if (_polylines.isNotEmpty)
          Align(
            alignment: Alignment.topCenter,
            child: AnimatedOpacity(
              opacity: _polylines.isNotEmpty ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 2000),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 20.0),
                        child: Text(
                            "Estimated emissions: $_estimatedEmissions kg CO2",
                            style: const TextStyle(fontSize: 18)),
                      )),
                ],
              ),
            ),
          ),
        Positioned.fill(
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              setState(() {
                _mapLoaded = true;
              });
            },
            polylines: _polylines,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomGesturesEnabled: true,
          ),
        ),
        if (!_mapLoaded)
          const Positioned.fill(
              child: Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          )),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 3),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: AppPallete.backgroundColor,
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextField(
                          controller: _fromController,
                          decoration: const InputDecoration(
                            fillColor: AppPallete.backgroundColor,
                            labelText: 'From',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.location_on),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _toController,
                          decoration: const InputDecoration(
                            fillColor: AppPallete.backgroundColor,
                            labelText: 'To',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.location_on),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: _getRoute,
                          icon: const Icon(Icons.directions),
                          label: const Text('Show Route'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            //primary: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ))
      ]),
    );
  }

  Future<void> _getRoute() async {
    if (_fromController.text.isEmpty || _toController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both locations')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Function started')),
    );

    final from = Uri.encodeComponent(_fromController.text);
    final to = Uri.encodeComponent(_toController.text);

    try {
      final url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=$from&destination=$to&key=${Config.googleApiKey}';
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);
      final distance = data["routes"][0]["legs"][0]["distance"]["value"];

      final url2 =
          'http://10.0.2.2:5000/predict-emmisions?vehicle-class=Cargo Van&engine-size=4&fuel-type=Z&fuel-consumption=12&weight=2000&meters=$distance';
      final response2 = await http.get(Uri.parse(url2));
      final emissionsData = json.decode(response2.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$emissionsData')),
      );

      if (data['status'] == 'OK') {
        final points =
            _decodePolyline(data['routes'][0]['overview_polyline']['points']);

        final startLatLng = LatLng(
          data['routes'][0]['legs'][0]['start_location']['lat'],
          data['routes'][0]['legs'][0]['start_location']['lng'],
        );

        final endLatLng = LatLng(
          data['routes'][0]['legs'][0]['end_location']['lat'],
          data['routes'][0]['legs'][0]['end_location']['lng'],
        );

        setState(() {
          _markers = {
            Marker(
              markerId: const MarkerId('start'),
              position: startLatLng,
              infoWindow: const InfoWindow(title: 'Start'),
            ),
            Marker(
              markerId: const MarkerId('end'),
              position: endLatLng,
              infoWindow: const InfoWindow(title: 'End'),
            ),
          };

          _polylines = {
            Polyline(
              polylineId: const PolylineId('route'),
              points: points,
              color: Colors.green,
              width: 5,
            ),
          };

          _estimatedEmissions =
              (emissionsData["total_emissions"] / 1000).toStringAsFixed(1);
        });

        final bounds = LatLngBounds(
          southwest: LatLng(
            data['routes'][0]['bounds']['southwest']['lat'],
            data['routes'][0]['bounds']['southwest']['lng'],
          ),
          northeast: LatLng(
            data['routes'][0]['bounds']['northeast']['lat'] + data['routes'][0]['bounds']['northeast']['lat'] / 5,
            data['routes'][0]['bounds']['northeast']['lng'],
          ),
        );

        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not find route: ${data['status']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting route: $e')),
      );
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }
}
