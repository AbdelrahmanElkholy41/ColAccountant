import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../edit_Product/Modal/ProductModel.dart';
import '../edit_Product/Logic/ProductCubit.dart';
import '../edit_Product/widget/CustomTextField.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _countController = TextEditingController();
  final _descController = TextEditingController();
  final _costController = TextEditingController();
  File? _selectedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return;

      final file = File(result.files.single.path!);
      final fileSize = await file.length();

      if (fileSize > 5 * 1024 * 1024) { // 5MB max
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maximum image size is 5MB')),
        );
        return;
      }

      setState(() => _selectedImage = file);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: ${e.toString()}')),
      );
    }
  }

  Future<void> _submit() async {
    if (_selectedImage == null ||
        _nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _countController.text.isEmpty ||
        _descController.text.isEmpty||   _costController.text.isEmpty) { // Added description check
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select an image')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final supabase = Supabase.instance.client;
      final imageName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final fileBytes = await _selectedImage!.readAsBytes();

      // Upload image to storage
      await supabase.storage
          .from('product-images')
          .uploadBinary('Product/$imageName', fileBytes);

      // Get public URL
      final imageUrl = supabase.storage
          .from('product-images')
          .getPublicUrl('Product/$imageName');

      // Create product with description
      final product = ProductModel(
        id: 0,
        name: _nameController.text,
        count: int.parse(_countController.text),
        price: double.parse(_priceController.text),
        imageUrl: imageUrl,
        description: _descController.text,
        cost: double.parse(_costController.text)// Added description
      );

      // Add product through Cubit
      await context.read<ProductCubit>().addProduct(product);

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      debugPrint('Error details: $e');
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(child: Text('Add New Product')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),

        child: Column(
          children: [
            SizedBox(height: 30,),
            Row(

              children: [
                Text('Product Name',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                SizedBox(width: 15,),
                SizedBox(
                  width: MediaQuery.of(context).size.width*.36,
                  child: CustomTextField(
                    title: 'Product Name',
                    controller: _nameController,

                  ),
                ),
                SizedBox(width: 50,),
                Text('Product Price',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                SizedBox(width: 15,),
                SizedBox(
                  width: MediaQuery.of(context).size.width*.36,
                  child: CustomTextField(
                    title: 'Product Price',
                    controller: _priceController,

                  ),
                ),
              ],
            ),


            const SizedBox(height: 50),
            Row(

              children: [
                Text('Product Count',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                SizedBox(width: 15,),
                SizedBox(
                  width: MediaQuery.of(context).size.width*.36,
                  child: CustomTextField(
                    title: 'Product Count',
                    controller: _countController,

                  ),
                ),
                SizedBox(width: 50,),
                Text('Product Cost',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                SizedBox(width: 15,),
                SizedBox(
                  width: MediaQuery.of(context).size.width*.36,
                  child: CustomTextField(
                    title: 'Product Cost',
                    controller: _costController,

                  ),
                ),

              ],
            ),
            const SizedBox(height: 50),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Product Description',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                SizedBox(width: 15,),
                SizedBox(
                  width: MediaQuery.of(context).size.width*.36,
                  child: CustomTextField(
                    title: 'Product Description',
                    controller: _descController,

                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: _isUploading ? null : _pickImage,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height*.15,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(_selectedImage!, fit: BoxFit.cover),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image,
                        size: 50,
                        color: _isUploading ? Colors.grey : Colors.black45),
                    const SizedBox(height: 8),
                    Text(
                      _isUploading ? 'Uploading...' : 'Tap to select image',
                      style: TextStyle(
                        color: _isUploading ? Colors.grey : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: _isUploading ? null : _submit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue,
              ),
              child: _isUploading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Add Product', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _countController.dispose();
    _descController.dispose();
    super.dispose();
  }
}