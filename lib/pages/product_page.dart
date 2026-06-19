import 'package:flutter/material.dart';
import 'package:pertemuan10_2306048/models/product_model.dart';
import 'package:pertemuan10_2306048/pages/product_detail_page.dart';
import 'package:pertemuan10_2306048/widget/product_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  List<ProductModel> products = [];

    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      loadProducts();
    }
  
  Future<void> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> productList = prefs.getStringList('products') ?? [];
    setState(() {
      products = productList
          .map((item) => ProductModel.fromJson(item))
          .toList();
    });
  }

    Future<void> saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> productList = products.map((item) => item.toJson()).toList();
    await prefs.setStringList('products', productList);
  }

  Future<void> addProduct(ProductModel product) async {
    setState(() {
      products.add(product);
    });
    await saveProducts();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produk berhasil ditambahkan')),
    );
  }

  Future<void> updateProduct(int index, ProductModel product) async {
    setState(() {
      products[index] = product;
    });
    await saveProducts();
  }

  Future<void> deleteProduct(int index) async {
    setState(() {
      products.removeAt(index);
    });
    await saveProducts();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Produk berhasil dihapus")));
  }

    void showFrom({ProductModel? product, int? index}) {
    TextEditingController nameController = TextEditingController(
      text: product?.name ?? "",
    );
    TextEditingController descriptionController = TextEditingController(
      text: product?.description ?? "",
    );
    TextEditingController priceController = TextEditingController(
      text: product?.price.toString() ?? "",
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(product == null ? "Tambah Produk" : "Edit Produk"),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Nama"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nama wajib diisi";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: "Deskripsi"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Deskripsi wajib diisi";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: "Harga"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Harga wajib diisi";
                  }
                if (int.tryParse(value) == null) {
                    return "Harga harus berupa angka";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final newProduct = ProductModel(
                  name: nameController.text,
                  description: descriptionController.text,
                  price: int.parse(priceController.text)
                );
                if (product == null) {
                  addProduct(newProduct);
                } else {
                  updateProduct(index!, newProduct);
                }
                Navigator.pop(context);
              }
            },
            child: Text(
              product == null ? "Simpan" : "Perbarui"
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Produk", style: TextStyle(
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
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: products.isEmpty
                  ? const Center(child: Text("Belum ada produk"))
                  : ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          product: product,
                          onEdit: () => showFrom(product: product, index: index),
                          onDelete: () => deleteProduct(index),
                        );
                      },
                    )
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showFrom,
        child: Icon(Icons.add)
      ),
    );
  }
}