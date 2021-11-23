import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<MapPage> {
  final uuid = const Uuid();
  final LatLng _center = const LatLng(13.731283160553428, 100.5416772151501);

  final List<LatLng> _currentPoints = [];

  Set<Marker> get _markers => HashSet.from(_currentPoints
      .map<Marker>((point) => Marker(
            markerId: MarkerId(uuid.v1()),
            position: point,
          ))
      .toList());

  Set<Polygon> get _polygons => HashSet.from([
        Polygon(
          polygonId: PolygonId(uuid.v1()),
          points: _currentPoints,
          strokeWidth: 2,
          fillColor: Colors.yellow.withOpacity(0.4),
        )
      ]);

  bool get _hasPointOnScreen => _currentPoints.isNotEmpty;

  void _onTapMapPoint(LatLng location) {
    setState(() {
      _currentPoints.add(location);
    });
  }

  void _onTapUndo() {
    setState(() {
      _currentPoints.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        backgroundColor: Colors.black,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 15,
        ),
        onTap: _onTapMapPoint,
        markers: _markers,
        polygons: _polygons,
        myLocationButtonEnabled: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _hasPointOnScreen ? _onTapUndo : null,
        child: const Icon(Icons.undo),
        backgroundColor: Colors.black,
      ),
    );
  }
}
