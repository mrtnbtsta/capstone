import 'dart:async';
import 'package:capstone_project/config.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places_web/flutter_google_places_web.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class UserMapDisplay extends StatefulWidget {
  final LatLng? coordinates;
  const UserMapDisplay({super.key, required this.coordinates});

  @override
  State<UserMapDisplay> createState() => _UserMapDisplayState();
}

class _UserMapDisplayState extends State<UserMapDisplay> {
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();
  Map<String, Marker> markers = {};
  @override
  void initState() {
    FlutterGooglePlacesWeb(
      apiKey: "AIzaSyBRKMkgNpqQvMDgGVdnIbXNbjF9cJMRnVM",
      proxyURL: kIsWeb
          ? 'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api'
          : null,
      required: true,
    );
    // if (widget.coordinates != null) {
    //   getPolyLinePoints().then((coordinates) => {
    //         // generatePolyLineFromPoints(coordinates),
    //       });
    // }
    super.initState();
  }

  static const LatLng pGooglePlex =
      LatLng(37.42796133580664, -122.085749655962);

  Map<PolylineId, Polyline> polyLines = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.coordinates == null
          ? const Center(child: Text("Loading..."))
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                  target: LatLng(widget.coordinates!.latitude,
                      widget.coordinates!.longitude),
                  zoom: 14),
              onMapCreated: (controller) {
                mapController.complete(controller);
              },
              markers: {
                Marker(
                    markerId: const MarkerId("currentLocation"),
                    icon: BitmapDescriptor.defaultMarkerWithHue(255),
                    visible: true,
                    infoWindow: const InfoWindow(title: "You", snippet: "You"),
                    position: widget.coordinates!)
              },
              // polylines: Set<Polyline>.of(polyLines.values),
            ),
    );
  }

  Future<List<LatLng>> getPolyLinePoints() async {
    List<LatLng> polyLineCoordinates = [];
    PolylinePoints polyLinePoints = PolylinePoints();
    PolylineResult result = await polyLinePoints.getRouteBetweenCoordinates(
        Config.apiKey,
        PointLatLng(
            widget.coordinates!.latitude, widget.coordinates!.longitude),
        PointLatLng(pGooglePlex.latitude, pGooglePlex.longitude),
        travelMode: TravelMode.walking);

    if (result.points.isNotEmpty) {
      for (var points in result.points) {
        polyLineCoordinates.add(LatLng(points.latitude, points.longitude));
      }
    } else {
      //
    }
    return polyLineCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polyLineCoordinates) async {
    PolylineId id = const PolylineId("poly");
    Polyline polyLine = Polyline(
        polylineId: id,
        color: Colors.black,
        points: polyLineCoordinates,
        width: 8);
    setState(() {
      polyLines[id] = polyLine;
    });
  }
}
