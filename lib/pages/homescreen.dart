import 'package:flutter/material.dart';
import 'package:invantory/pages/productdetailsscreen.dart';
import 'package:invantory/pages/profilescreen.dart';
import 'package:invantory/pages/scanner.dart';
import '../data/productData.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController productIdController = TextEditingController();
  List<String> recentSearches = ['12345', '67890', '54321', '11223', '33445'];

  void navigateToDetails(BuildContext context, String productId) {
    if (productId.isEmpty || productId.length != 5) {
      _showErrorSnackBar('Please enter a valid 5-digit Product ID.');
      return;
    }

    if (ProductData.products.containsKey(productId)) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ProductDetailsScreen(productId: productId),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: child,
            );
          },
        ),
      );
    } else {
      _showErrorSnackBar('Product not found!');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Text(message,style: TextStyle(fontSize: 13.0),),
          ],
        ),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

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
          title: Text('Inventory Management',
              style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                // Handle profile icon press (e.g., navigate to profile page)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()), // Replace with your profile page
                );
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Hero(
                  tag: 'searchField',
                  child: Material(
                    color: Colors.transparent,
                    child: TextField(
                      controller: productIdController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Enter 5-digit Product ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey[850],
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.tealAccent),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => navigateToDetails(
                    context,
                    productIdController.text.trim(),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.tealAccent, padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search),
                      SizedBox(width: 8),
                      Text(
                        'Search Product',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Recent Searches:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: recentSearches.length,
                    itemBuilder: (context, index) {
                      final productId = recentSearches[index];
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(vertical: 4),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.history),
                            title: Text(productId),
                            trailing: Icon(Icons.chevron_right),
                            onTap: () => navigateToDetails(context, productId),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScannerPage()),
            );
          },
          child: Icon(Icons.qr_code_scanner),
          backgroundColor: Colors.tealAccent,
          foregroundColor: Colors.black,
        ),
      ),
    );
  }
}