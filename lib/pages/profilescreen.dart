import 'package:flutter/material.dart';
import 'package:invantory/pages/loginscreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String userId = "12345";
  final String username = "John Doe";
  final String designation = "Software Engineer";
  final String companyName = "TechCorp";
  String deviceId = "r74i88t26u";

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        primaryColor: Colors.indigo[700],
        scaffoldBackgroundColor: Colors.grey[900],
        cardColor: Colors.grey[850],
        colorScheme: ColorScheme.dark(
          primary: Colors.indigo[400]!,
          secondary: Colors.tealAccent,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout,color: Colors.red,),
              onPressed: () {
                _logout(context);
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.grey[900]!, Colors.grey[850]!],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/th(6).jpg'),
                    backgroundColor: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'User Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.tealAccent,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow('User ID', userId),
                      _buildInfoRow('Username', username),
                      _buildInfoRow('Designation', designation),
                      _buildInfoRow('Company Name', companyName),
                      const SizedBox(height: 16),
                      const Text(
                        'System Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.tealAccent,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow('Device ID', deviceId),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.tealAccent,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    // Navigate to Login Screen
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(),));
  }
}
