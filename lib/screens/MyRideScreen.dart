import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:yurbandrivers/BaseURL.dart';
import 'package:yurbandrivers/models/GetMyrideModel.dart';


class MyRideScreen extends StatefulWidget {
  const MyRideScreen({Key? key}) : super(key: key);
  
  @override
  MyRideScreenState createState() => MyRideScreenState();
}

class MyRideScreenState extends State<MyRideScreen> {
    String DRIVERFNAME = '';
  String DRIVERLNAME = '';
  String DRIVERPHONE = '';
  String DRIVERID = '';
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
   DRIVERID = prefs.getString("PID") ?? ''; 
      DRIVERPHONE = prefs.getString("DRIVERPHONE") ?? ''; 
      DRIVERFNAME = prefs.getString("DRIVERFNAME") ?? '';   
      DRIVERLNAME = prefs.getString("DRIVERLNAME") ?? ''; 
    setState(() {
      isLoading = true;
    });
    final url = "${BaseURL.GETMYRIDES}/$DRIVERID";
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
  DRIVERID = prefs.getString("PID") ?? ''; 
      DRIVERPHONE = prefs.getString("DRIVERPHONE") ?? ''; 
      DRIVERFNAME = prefs.getString("DRIVERFNAME") ?? '';   
      DRIVERLNAME = prefs.getString("DRIVERLNAME") ?? ''; 
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
                    DataColumn(label: Text('Customer')),
                      DataColumn(label: Text('Phone')),

                  DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Action')),
                  
                ],
                rows: myrides
                    .map(
                      (data) => DataRow(cells: [
                        DataCell(Text(data.from)),
                        DataCell(Text(data.to)),
                         DataCell(Text(data.customerfname + ' ' + data.customerlname)),

                        DataCell(Text(data.customerphone)),
                        DataCell(Text(data.action)),

                          DataCell(  ElevatedButton(  onPressed: () {
                         _RejectRide(data.id);
                                              },
                             style: ElevatedButton.styleFrom(
                           primary: Colors.red, // Set the background color to red
                             ),
                          child: Text(
                          'Reject',
                         style: TextStyle(color: Colors.white), // Optional: Change text color to white
                      ),
                      ),
                 ),

                
                      ]),
                    )
                    .toList(),
              ),
            ),
    );
  }
  


     Future<void> _RejectRide(int id) async {
  
    Map<String, dynamic> postData = {
      "recordid": id,
  
      };
    String jsonString = json.encode(postData);
    print('JSON Data Log: $jsonString');

    try {
      final response = await http.post(
        Uri.parse(BaseURL.UPDATEDRIVEREJECT),
        headers: {'Content-Type': 'application/json'},
        body: jsonString,
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode != 200) {
        // Handle failure
 await   _fetchMyRides();
      }
    } catch (e) {
    
    }
  }
  

}
