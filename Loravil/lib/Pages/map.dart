import 'package:flutter/material.dart';
import 'package:loravil/Pages/methods.dart';
import 'package:flutter_map/flutter_map.dart';

//OpenStreetMap
class OpenstreetmapScreen extends StatefulWidget {
  const OpenstreetmapScreen({super.key});

  @override
  State<OpenstreetmapScreen> createState() => _OpenstreetmapScreenState();
}

class _OpenstreetmapScreenState extends State<OpenstreetmapScreen> {
  final MapController _mapController = MapController();
  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa de rutas"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading:
            false, // Opcional: Elimina el botón "volver" automático
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              // Agrega un IconButton en el leading
              icon: const Icon(Icons.menu), // Icono de menú (hamburguesa)
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Abre el drawer
              },
            );
          },
        ),
      ),
      drawer: MyDrawer.buildDrawer(context),
      body: MapWidgetBuilder.buildMap(_mapController),
    );
  }
}
