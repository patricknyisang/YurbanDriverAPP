import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:yurbandrivers/BaseURL.dart';
import 'package:yurbandrivers/models/GetRequestrideModel.dart';
import 'package:yurbandrivers/screens/LoginScreen.dart';
import 'package:yurbandrivers/screens/MyRideScreen.dart';
import 'package:yurbandrivers/screens/ProfileScreen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String DRIVERFNAME = '';
  String DRIVERLNAME = '';
  String DRIVERPHONE = '';
  String DRIVERID = '';
  bool isLoading = false;

  List<GetRequestrideModel> requestrides = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchMyRides();
  }

  Future<void> _fetchMyRides() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DRIVERID = prefs.getString("DRIVERID") ?? ''; // Use DRIVERID if available
    DRIVERPHONE = prefs.getString("DRIVERPHONE") ?? ''; 
    DRIVERFNAME = prefs.getString("DRIVERFNAME") ?? '';   
    DRIVERLNAME = prefs.getString("DRIVERLNAME") ?? ''; 

    setState(() {
      isLoading = true;
    });

    final url = "${BaseURL.REQUESTRIDES}";
    print('Request URL: $url');

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          requestrides = data.map((json) => GetRequestrideModel.fromJson(json)).toList();
        });
      } else {
        _showErrorDialog("Failed to load data. Please try again later.");
      }
    } catch (e) {
      _showErrorDialog("An error occurred: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      DRIVERID = prefs.getString("DRIVERID") ?? ''; 
      DRIVERPHONE = prefs.getString("DRIVERPHONE") ?? ''; 
      DRIVERFNAME = prefs.getString("DRIVERFNAME") ?? '';   
      DRIVERLNAME = prefs.getString("DRIVERLNAME") ?? ''; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.black,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.red,
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.directions_car,
                      color: Colors.white,
                      size: 40,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Yurban Driver',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: Colors.white),
                title: Text('Home', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.person, color: Colors.white),
                title: Text('Profile', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.directions_car, color: Colors.white),
                title: Text('My Rides', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyRideScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.white),
                title: Text('Log Out', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: HomeScreen(
        isLoading: isLoading,
        requestrides: requestrides,
        goOnline: goOnline,
        goOffline: goOffline,
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> goOnline() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String driverId = prefs.getString("PID") ?? '';

    Map<String, dynamic> postData = {"PID": driverId};
    String jsonString = json.encode(postData);
    print('JSON Data Log: $jsonString');

    try {
      final response = await http.post(
        Uri.parse(BaseURL.ONLINESTATUS),
        headers: {'Content-Type': 'application/json'},
        body: jsonString,
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode != 200) {
        // Handle failure
        _showErrorDialog("Failed to go online. Please try again.");
      }
    } catch (e) {
      _showErrorDialog("An error occurred: $e");
    }
  }

  Future<void> goOffline() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String driverId = prefs.getString("PID") ?? '';

    Map<String, dynamic> postData = {"PID": driverId};
    String jsonString = json.encode(postData);
    print('JSON Data Log: $jsonString');

    try {
      final response = await http.post(
        Uri.parse(BaseURL.OFFLINESTATUS),
        headers: {'Content-Type': 'application/json'},
        body: jsonString,
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode != 200) {
        // Handle failure
        _showErrorDialog("Failed to go offline. Please try again.");
      }
    } catch (e) {
      _showErrorDialog("An error occurred: $e");
    }
  }
}

class HomeScreen extends StatelessWidget {
  final bool isLoading;
  final List<GetRequestrideModel> requestrides;
  final VoidCallback goOnline;
  final VoidCallback goOffline;

  HomeScreen({
    required this.isLoading,
    required this.requestrides,
    required this.goOnline,
    required this.goOffline,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          color: Colors.grey[300],
          child: Center(
            child: Text(
              'Map Here',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton(
                text: 'Go Offline',
                color1: Colors.redAccent,
                color2: Colors.red,
                icon: Icons.do_not_disturb,
                onPressed: goOffline,
              ),
              _buildButton(
                text: 'Go Online',
                color1: Colors.greenAccent,
                color2: Colors.green,
                icon: Icons.check_circle,
                onPressed: goOnline,
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(label: Text('From')),
                    DataColumn(label: Text('To')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: requestrides
                      .map(
                        (data) => DataRow(cells: [
                          DataCell(Text(data.from)),
                          DataCell(Text(data.to)),
                          DataCell(Text(data.action)),
                        ]),
                      )
                      .toList(),
                ),
              ),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required Color color1,
    required Color color2,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 16),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ).copyWith(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.grey;
            }
            return Colors.transparent;
          },
        ),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color1, color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          alignment: Alignment.center,
          constraints: BoxConstraints(maxWidth: 150, minHeight: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
