import 'package:flutter/material.dart';
import '../data/productData.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  ProductDetailsScreen({required this.productId});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showStockUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int newStock = 0;
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            'Update Stock',
            style: TextStyle(color: Colors.tealAccent),
          ),
          content: TextField(
            style: TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'New Stock Amount',
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.tealAccent.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.tealAccent),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) => newStock = int.tryParse(value) ?? 0,
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.white70)),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.tealAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Update'),
              onPressed: () {
                // Implement stock update logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.update, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Stock updated successfully!'),
                      ],
                    ),
                    backgroundColor: Colors.green[700],
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productData = ProductData.products[widget.productId];

    if (productData == null) {
      return Theme(
        data: ThemeData.dark(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Product Details'),
            backgroundColor: Colors.red[700],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Product not found!',
                  style: TextStyle(fontSize: 24, color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Theme(
      data: ThemeData.dark().copyWith(
        primaryColor: Colors.indigo[700],
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Product Details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.grey[900]!, Colors.grey[850]!],
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 8,
                      color: Colors.grey[850],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.qr_code, color: Colors.tealAccent),
                                SizedBox(width: 8),
                                Text(
                                  'Product ID: ${widget.productId}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.tealAccent,
                                  ),
                                ),
                              ],
                            ),
                            Divider(color: Colors.tealAccent.withOpacity(0.3)),
                            _buildInfoRow(Icons.inventory, 'Name', productData["name"]),
                            _buildInfoRow(Icons.description, 'Description', productData["description"]),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      elevation: 8,
                      color: Colors.grey[850],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                            child: Image.asset(
                              productData["photoUrl"],
                              fit: BoxFit.cover,
                              height: 200,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 200,
                                color: Colors.grey[800],
                                child: Icon(
                                  Icons.broken_image,
                                  size: 80,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                _buildInfoRow(Icons.calendar_today, 'Inventory Date', productData["inventoryDate"]),
                                _buildInfoRow(Icons.person, 'Supervisor', productData["supervisor"]),
                                _buildInfoRow(Icons.inventory_2, 'Stock', productData["stock"].toString()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.update),
                        label: Text('Update Stock', style: TextStyle(fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black, backgroundColor: Colors.tealAccent,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _showStockUpdateDialog,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.white70),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}