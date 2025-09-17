import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:loravil/Pages/nodos.dart';
import 'package:loravil/Pages/map.dart';
import 'package:loravil/Pages/historial.dart';

class MyDrawer {
  static Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menú',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Mapa'),
            onTap: () {
              Navigator.pop(context); // Cierra el drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OpenstreetmapScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.campaign),
            title: const Text('Nodos'),
            onTap: () {
              Navigator.pop(context); // Cierra el drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.atm),
            title: const Text('Historial'),
            onTap: () {
              Navigator.pop(context); // Cierra el drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Histories()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class MapWidgetBuilder {
  static Widget buildMap(MapController mapController) {
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: const MapOptions(
            initialCenter: LatLng(19.05800, -95.998436),
            initialZoom: 15,
            minZoom: 3,
            maxZoom: 100,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
            CurrentLocationLayer(
              style: const LocationMarkerStyle(
                marker: DefaultLocationMarker(
                  child: Icon(Icons.location_pin, color: Colors.white),
                ),
                markerSize: Size(35, 35),
                markerDirection: MarkerDirection.heading,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CardList {
  Widget buildTwoLineCard(String text, String content) {
    return Card(
      child: ListTile(
        leading: FlutterLogo(size: 56.0),
        title: Text(text),
        subtitle: Text(content),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}
