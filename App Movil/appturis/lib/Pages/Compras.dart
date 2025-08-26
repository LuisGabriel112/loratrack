import 'package:flutter/material.dart';
import 'package:appturis/Pages/OpenStreetMap.dart';

void main() => runApp(const Compras());

class Compras extends StatelessWidget {
  const Compras({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compras'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 9, child: Column()),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Center(child: ImageMethods().BuildImageRow(context)),
            ),
          ),
        ],
      ),
    );
  }
}
