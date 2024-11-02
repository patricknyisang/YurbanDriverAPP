import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yurbandrivers/BaseURL.dart';
import 'package:yurbandrivers/models/GetMyrideModel.dart';


class MyRideScreen extends StatefulWidget {
  const MyRideScreen({Key? key}) : super(key: key);
  
  @override
  MyRideScreenState createState() => MyRideScreenState();
}

class MyRideScreenState extends State<MyRideScreen> {
  String driverLName = '';
  String driverFName = '';
  String driverPhone = '';

  bool isLoading = false;
  List<GetMyrideModel> myrides = [];

  @override
  void initState() {
    super.initState();
    _loadUserData(); 
    _fetchMyRides();
  }

  Future<void> _fetchMyRides() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      driverPhone = prefs.getString("DRIVERPHONE") ?? ''; 
    setState(() {
      isLoading = true;
    });
    final url = "${BaseURL.GETMYRIDES}/$driverPhone";
    print('Request URL: $url');
    
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        myrides = data.map((json) => GetMyrideModel.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // Show error dialog
      _showErrorDialog("Failed to load Data. Please try again later.");
    }
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
   driverPhone = prefs.getString("DRIVERPHONE") ?? ''; 
      driverFName = prefs.getString("DRIVERFNAME") ?? '';   
      driverLName = prefs.getString("DRIVERLNAME") ?? ''; 
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Rides"),
      ),
      body: isLoading 
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(label: Text('From')),
                  DataColumn(label: Text('To')),
                  DataColumn(label: Text('Action')),
                ],
                rows: myrides
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
    );
  }
}
