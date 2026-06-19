import 'package:flutter/material.dart';
import 'package:pertemuan10_2306048/models/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Produk", style: TextStyle(
            color: Colors.white,
            fontWeight: .bold
          ),
        ),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(product.name, style: TextStyle(
              fontSize: 24,
              fontWeight: .bold
              ),
            ),
            SizedBox(height: 30,),
            Text("Rp ${product.price}"),
            SizedBox(height: 10,),
            Text(product.description)
          ],
        ),
      ),
    );
  }
}