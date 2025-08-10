// Feature/edit_Product/editProductPage.dart

import 'dart:io';
import 'package:cal/Feature/Sales/widget/SaleProductButton.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../edit_Product/Modal/ProductModel.dart';
import '../edit_Product/Logic/ProductCubit.dart';
import '../edit_Product/widget/CustomTextField.dart';
import 'package:cal/Feature/edit_Product/Logic/ProductState.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({
    super.key,
    required this.productModel,
    required this.isAdmin,  // هنا حقل isAdmin
  });

  final ProductModel productModel;
  final bool isAdmin;

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _countController = TextEditingController();
  final _descController = TextEditingController();
  final _costController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.productModel.name;
    _priceController.text = widget.productModel.price.toString();
    _countController.text = widget.productModel.count.toString();
    _descController.text = widget.productModel.description;
    _costController.text = widget.productModel.cost.toString();
  }

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileSize = await file.length();

        if (fileSize > 5 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('حجم الصورة كبير جداً (الحد الأقصى 5MB)'),
            ),
          );
          return;
        }

        setState(() => _selectedImage = file);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في اختيار الصورة: ${e.toString()}')),
      );
    }
  }

  Future<void> _submit() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _countController.text.isEmpty ||
        _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;
      String imageUrl = widget.productModel.imageUrl;

      if (_selectedImage != null) {
        final imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        await supabase.storage
            .from('product-images')
            .upload(imageName, _selectedImage!);
        imageUrl = supabase.storage
            .from('product-images')
            .getPublicUrl(imageName);
      }

      final product = ProductModel(
        id: widget.productModel.id,
        name: _nameController.text,
        count: int.tryParse(_countController.text) ?? 0,
        price: double.tryParse(_priceController.text) ?? 0.0,
        imageUrl: imageUrl,
        description: _descController.text,
        cost: double.tryParse(_costController.text) ?? 0.0,
      );

      await context.read<ProductCubit>().updateProduct(product);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Edit Product'),
        centerTitle: true,
        actions: widget.isAdmin
            ? [
                IconButton(
                  onPressed: () {
                    context.read<ProductCubit>().deleteProduct(widget.productModel.id);
                  },
                  icon: const Icon(Icons.delete, color: Colors.black87),
                ),
              ]
            : null,
      ),
      body: widget.isAdmin
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  TwoCustomTextField(
                    context: context,
                    nameController: _nameController,
                    priceController: _priceController,
                  ),
                  const SizedBox(height: 50),
                  TWoCustomText(
                    context: context,
                    countController: _countController,
                    costController: _costController,
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Product Description',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(width: 15),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .36,
                        child: CustomTextField(
                          title: 'Product Description',
                          controller: _descController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  GestureDetector(
                    onTap: _isLoading ? null : _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * .2,
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
                          : Image.network(
                              widget.productModel.imageUrl,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Save Changes',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                  const SizedBox(height: 30),
                  SaleProductButton(
                    productModel: widget.productModel,
                    onSaleSuccess: (soldQuantity) {
                      setState(() {
                        widget.productModel.count -= soldQuantity;
                        _countController.text = widget.productModel.count.toString();
                        context.read<ProductCubit>().updateProduct(widget.productModel);
                      });
                    },
                  ),
                ],
              ),
            )
          : Center(
              child: SaleProductButton(
                productModel: widget.productModel,
                onSaleSuccess: (soldQuantity) {
                  setState(() {
                    widget.productModel.count -= soldQuantity;
                    _countController.text = widget.productModel.count.toString();
                    context.read<ProductCubit>().updateProduct(widget.productModel);
                  });
                },
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductCubit, ProductState>(
      listener: (context, state) {
        if (state is ProductSuccessfully) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product updated successfully')),
          );
          Navigator.pop(context);
        } else if (state is ProductError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: _buildForm(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _countController.dispose();
    _descController.dispose();
    _costController.dispose();
    super.dispose();
  }
}

class TWoCustomText extends StatelessWidget {
  const TWoCustomText({
    super.key,
    required this.context,
    required TextEditingController countController,
    required TextEditingController costController,
  })  : _countController = countController,
        _costController = costController;

  final BuildContext context;
  final TextEditingController _countController;
  final TextEditingController _costController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Product Count',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(width: 15),
        SizedBox(
          width: MediaQuery.of(context).size.width * .36,
          child: CustomTextField(
            title: 'Product Count',
            controller: _countController,
          ),
        ),
        const SizedBox(width: 50),
        const Text(
          'Product Cost',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(width: 15),
        SizedBox(
          width: MediaQuery.of(context).size.width * .36,
          child: CustomTextField(title: 'Cost', controller: _costController),
        ),
      ],
    );
  }
}

class TwoCustomTextField extends StatelessWidget {
  const TwoCustomTextField({
    super.key,
    required this.context,
    required TextEditingController nameController,
    required TextEditingController priceController,
  })  : _nameController = nameController,
        _priceController = priceController;

  final BuildContext context;
  final TextEditingController _nameController;
  final TextEditingController _priceController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Product Name',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(width: 15),
        SizedBox(
          width: MediaQuery.of(context).size.width * .36,
          child: CustomTextField(
            title: 'Product Name',
            controller: _nameController,
          ),
        ),
        const SizedBox(width: 50),
        const Text(
          'Product Price',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(width: 15),
        SizedBox(
          width: MediaQuery.of(context).size.width * .36,
          child: CustomTextField(
            title: 'Product Price',
            controller: _priceController,
          ),
        ),
      ],
    );
  }
}
