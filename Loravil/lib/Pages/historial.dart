import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class Histories extends StatefulWidget {
  const Histories({Key? key}) : super(key: key);

  @override
  State<Histories> createState() => _HistoriesState();
}

class _HistoriesState extends State<Histories>
    with SingleTickerProviderStateMixin {
  List<dynamic> usersHistorialData = [];
  List<dynamic> createdUsersData = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchUsersHistorialData();
    fetchCreatedUsersData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchUsersHistorialData() async {
    final String serverIp = "192.168.100.152";
    final url = Uri.parse('http://$serverIp:5500/usersHistorial');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          usersHistorialData = json.decode(response.body);
        });
      } else {
        print('Failed to load users historial data: ${response.statusCode}');
        // Handle error appropriately (e.g., show a SnackBar)
      }
    } catch (e) {
      print('Error fetching users historial data: $e');
      // Handle error appropriately
    }
  }

  Future<void> fetchCreatedUsersData() async {
    final String serverIp = "192.168.100.152";
    final url = Uri.parse('http://$serverIp:5500/createdUsers');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          createdUsersData = json.decode(response.body);
        });
      } else {
        print('Failed to load created users data: ${response.statusCode}');
        // Handle error appropriately
      }
    } catch (e) {
      print('Error fetching created users data: $e');
      // Handle error appropriately
    }
  }

  Widget buildCard(String title, String content) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(content),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histories and Users'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Users Historial'),
            Tab(text: 'Created Users'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // UsersHistorial Tab
          ListView.builder(
            itemCount: usersHistorialData.length,
            itemBuilder: (context, index) {
              final item = usersHistorialData[index];
              // Format the timestamp
              final timestamp =
                  item['timestamp'] != null
                      ? DateFormat(
                        'yyyy-MM-dd HH:mm:ss',
                      ).format(DateTime.parse(item['timestamp']))
                      : 'N/A'; // Format date and time

              return buildCard(
                'Login Record',
                'Username: ${item['Username'] ?? 'N/A'}\nTimestamp: $timestamp\nAction: ${item['action'] ?? 'N/A'}',
              );
            },
          ),
          // CreatedUsers Tab
          ListView.builder(
            itemCount: createdUsersData.length,
            itemBuilder: (context, index) {
              final item = createdUsersData[index];
              return buildCard(
                'Created User',
                'Username: ${item['Username'] ?? 'N/A'}\n /* Add other relevant fields here */', // Adapt this line
              );
            },
          ),
        ],
      ),
    );
  }
}
