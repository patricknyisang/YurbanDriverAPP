import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:yurbandrivers/BaseURL.dart';

import 'package:yurbandrivers/models/ConstituenciesModel.dart';
import 'package:yurbandrivers/models/CountiesModel.dart';
import 'package:yurbandrivers/screens/LoginScreen.dart';
class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  String? _selectedGender;
   List<CountiesModel> counties = [];
    String? selectedCounty;
 List<ConstituenciesModel> constituencies = [];
  String? selectedConstituency;
int selectedCountyId = 0;
int selectedConstituencyId = 0;
  bool _isPinVisible = false;

    @override
  void initState() {
    super.initState();
    fetchCounties();
  
  }
 Future<void> fetchCounties() async {
    final response = await http.get(Uri.parse(BaseURL.COUNTIES ));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        counties = data.map((json) => CountiesModel.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load counties');
    }
  }

  
  Future<void> fetchConstituencies(String countyId) async {
    final response = await http.get(Uri.parse(BaseURL.CONSTITUENCIES + '/$countyId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        constituencies = data.map((json) => ConstituenciesModel.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load constituencies');
    }
  }
  void _togglePinVisibility() {
    setState(() {
      _isPinVisible = !_isPinVisible;
    });
  }



   Future<void> _register() async {

    String? firstName = firstNameController.text; 
     String? lastName = lastNameController.text; 
    String? phoneNumber = phoneController.text; 
  
      String? emailAddress = emailController.text; 
          String? pinNumber = pinController.text; 
    int? county = selectedCountyId;
    int? constituency = selectedConstituencyId ;

   
 
    // Construct JSON object
    Map<String, dynamic> postData = {
    
      "firstname": firstName,
      "lastname": lastName,
      "phonenumber": phoneNumber,
      "gender": _selectedGender,
      "email": emailAddress,
      "pass1": pinNumber,
      "County": county,
      "SubCounty": constituency,
      
    };
    
    // Convert JSON to string
    String jsonString = json.encode(postData);
        print('JSON Data  Log: $jsonString');
    // Send HTTP POST request
    final response = await http.post(
      Uri.parse(BaseURL.REGISTER_DRIVER),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonString,
    );
      print(response.statusCode);
        print(response.body);
    // Handle response
    if (response.statusCode == 200) {
      // If successful, navigate to dashboard screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      // If failed, show an error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to submit data."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  _buildFirstNameField(),
                  SizedBox(height: 20),
                  _buildLastNameField(),
                  SizedBox(height: 20),
                  _buildPhoneField(),
                  SizedBox(height: 20),
                  _buildEmailField(),
                  SizedBox(height: 20),
                  _buildPinField(),
                  SizedBox(height: 20),
                  _buildGenderDropdown(),
                  SizedBox(height: 20),
                  _buildCountyDropdown(),
                  SizedBox(height: 20),
                  _buildSubCountyDropdown(),
                  SizedBox(height: 30),
                  _buildRegisterButton(),
                  SizedBox(height: 20),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFirstNameField() {
    return TextFormField(
      controller: firstNameController,
      decoration: InputDecoration(
        labelText: 'First Name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person, color: Colors.redAccent),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your first name';
        }
        return null;
      },
    );
  }

  Widget _buildLastNameField() {
    return TextFormField(
      controller: lastNameController,
      decoration: InputDecoration(
        labelText: 'Last Name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person, color: Colors.redAccent),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your last name';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: phoneController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.phone, color: Colors.redAccent),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.email, color: Colors.redAccent),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPinField() {
    return TextFormField(
      controller: pinController,
      obscureText: !_isPinVisible,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: '4-Digit PIN',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock, color: Colors.redAccent),
        suffixIcon: IconButton(
          icon: Icon(color: Colors.redAccent,
            _isPinVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: _togglePinVisibility,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your PIN';
        }
        if (value.length != 4) {
          return 'PIN must be 4 digits';
        }
        return null;
      },
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      decoration: InputDecoration(
        labelText: 'Gender',
        border: OutlineInputBorder(),
      ),
      items: ['Male', 'Female', 'Other'].map((String gender) {
        return DropdownMenuItem(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedGender = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select your gender';
        }
        return null;
      },
    );
  }

  Widget _buildCountyDropdown() {
    return   DropdownButtonFormField<CountiesModel>(
                value: selectedCounty != null
                    ? counties.firstWhere((element) => element.counties == selectedCounty)
                    : null,
                onChanged: (CountiesModel? newValue) {
                  setState(() {
                    selectedCountyId = newValue!.id;
                    selectedCounty = newValue!.counties;
                    fetchConstituencies(newValue.id.toString());
                    selectedConstituency = null;
                   
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Select County',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                style: TextStyle(color: Colors.black, fontSize: 18.0),
                icon: Icon(Icons.arrow_drop_down),
                elevation: 2,
                isExpanded: true,
                items: counties.map((CountiesModel county) {
                  return DropdownMenuItem<CountiesModel>(
                    value: county,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1.0, horizontal: 10.0),
                      child: Text(
                        county.counties,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  );
                }).toList(),
              );
  }

  Widget _buildSubCountyDropdown() {
    return   DropdownButtonFormField<ConstituenciesModel>(
                value: selectedConstituency != null
                    ? constituencies.firstWhere((element) => element.constituency == selectedConstituency)
                    : null,
                onChanged: (ConstituenciesModel? newValue) {
                  setState(() {
                    selectedConstituencyId = newValue!.id;
                    selectedConstituency = newValue!.constituency;
                   
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Select Constituency',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                style: TextStyle(color: Colors.black, fontSize: 18.0),
                icon: Icon(Icons.arrow_drop_down),
                elevation: 2,
                isExpanded: true,
                items: constituencies.map((ConstituenciesModel constituency) {
                  return DropdownMenuItem<ConstituenciesModel>(
                    value: constituency,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1.0, horizontal: 10.0),
                      child: Text(
                        constituency.constituency,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  );
                }).toList(),
              );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _register,
        child: Text(
          'Register',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          primary: Colors.red,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Have an account? "),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate to LoginScreen
                );
              },
              child: Text(
                'Login',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
