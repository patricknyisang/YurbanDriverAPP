import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  String driverLName = '';
  String driverFName = '';
  String driverPhone = '';
   String driverEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserData(); 
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    setState(() {
      driverPhone = prefs.getString("DRIVERPHONE") ?? ''; 
      driverFName = prefs.getString("DRIVERFNAME") ?? '';   
      driverLName = prefs.getString("DRIVERLNAME") ?? ''; 
      driverEmail = prefs.getString("DRIVEREMAIL") ?? ''; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "First Name: $driverFName",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Last Name: $driverLName",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Phone: $driverPhone",
              style: TextStyle(fontSize: 18),
            ),

              SizedBox(height: 10),
            Text(
              "Phone: $driverEmail",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
