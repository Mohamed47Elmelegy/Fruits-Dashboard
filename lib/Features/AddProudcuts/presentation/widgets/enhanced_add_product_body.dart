import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/enhanced_product_cubit.dart';
import '../../domin/Entity/proudcuts_entity.dart';
import '../../domin/Entity/reviews_entity.dart';
import 'product_image_picker.dart';
import 'product_form_fields.dart';
import 'product_checkboxes.dart';
import '../../../../core/theme/application_theme_manager.dart';
import '../../../../core/widgets/section_container.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/form_header.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';

class EnhancedAddProductBody extends StatefulWidget {
  final Map<String, dynamic>? productToEdit;
  final bool isLoading;

  const EnhancedAddProductBody({
    super.key,
    this.productToEdit,
    required this.isLoading,
  });

  @override
  State<EnhancedAddProductBody> createState() => _EnhancedAddProductBodyState();
}

class _EnhancedAddProductBodyState extends State<EnhancedAddProductBody> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productPriceController = TextEditingController();
  final _productCodeController = TextEditingController();
  final _productDescriptionController = TextEditingController();
  final _expiryDateMonthsController = TextEditingController();
  final _calorieDensityController = TextEditingController();
  final _unitAmountController = TextEditingController();

  File? _selectedImage;
  Uint8List? _webImage;
  bool _isFeatured = false;
  bool _isOrganic = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.productToEdit != null;
    if (_isEditing) {
      _populateForm();
    }
  }

  void _populateForm() {
    final product = widget.productToEdit!;
    _productNameController.text = product['productName'] ?? '';
    _productPriceController.text = product['productPrice']?.toString() ?? '';
    _productCodeController.text = product['productCode'] ?? '';
    _productDescriptionController.text = product['productDescription'] ?? '';
    _expiryDateMonthsController.text =
        product['expiryDateMonths']?.toString() ?? '';
    _calorieDensityController.text =
        product['calorieDensity']?.toString() ?? '';
    _unitAmountController.text = product['unitAmount']?.toString() ?? '';
    _isFeatured = product['isFeatured'] ?? false;
    _isOrganic = product['isOrganic'] ?? false;
  }

  void _onImageSelected(File image) {
    setState(() {
      _selectedImage = image;
      _webImage = null;
    });
  }

  void _onWebImageSelected(Uint8List bytes) {
    setState(() {
      _webImage = bytes;
      _selectedImage = null;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final product = ProductsEntity(
        productName: _productNameController.text,
        productPrice: double.parse(_productPriceController.text),
        productCode: _productCodeController.text,
        productDescription: _productDescriptionController.text,
        isFeatured: _isFeatured,
        imageUrl: widget.productToEdit?['imageUrl'],
        expiryDateMonths: int.parse(_expiryDateMonthsController.text),
        calorieDensity: int.parse(_calorieDensityController.text),
        unitAmount: int.parse(_unitAmountController.text),
        productRating: widget.productToEdit?['productRating'] ?? 0,
        ratingCount: widget.productToEdit?['ratingCount'] ?? 0,
        isOrganic: _isOrganic,
        reviews: widget.productToEdit?['reviews'] != null
            ? (widget.productToEdit!['reviews'] as List)
                .map((e) => ReviewsEntity(
                      name: e['name'] ?? '',
                      image: e['image'] ?? '',
                      rating: e['rating'] ?? 0,
                      date: e['date'] ?? '',
                      description: e['description'] ?? '',
                    ))
                .toList()
            : [],
      );

      if (_isEditing) {
        context.read<EnhancedProductCubit>().updateProduct(
              widget.productToEdit!['id'],
              product,
              kIsWeb ? _webImage : _selectedImage,
            );
      } else {
        context.read<EnhancedProductCubit>().addProduct(
              product,
              kIsWeb ? _webImage : _selectedImage,
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ApplicationThemeManager.backgroundColor,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Product' : 'Add New Product'),
        backgroundColor: ApplicationThemeManager.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Section
                  FormHeader(
                    icon: _isEditing ? Icons.edit : Icons.add_shopping_cart,
                    title: _isEditing ? 'Edit Product' : 'Add New Product',
                    subtitle: _isEditing
                        ? 'Update your product information below'
                        : 'Fill in the details to add a new product',
                  ),
                  const SizedBox(height: 24),

                  // Image Picker Section
                  SectionContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(
                          icon: Icons.photo_camera,
                          title: 'Product Image',
                        ),
                        const SizedBox(height: 16),
                        ProductImagePicker(
                          selectedImage: _selectedImage,
                          onImageSelected: _onImageSelected,
                          onWebImageSelected: _onWebImageSelected,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Form Fields Section
                  SectionContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(
                          icon: Icons.description,
                          title: 'Product Details',
                        ),
                        const SizedBox(height: 20),
                        ProductFormFields(
                          productNameController: _productNameController,
                          productPriceController: _productPriceController,
                          productCodeController: _productCodeController,
                          productDescriptionController:
                              _productDescriptionController,
                          expiryDateMonthsController:
                              _expiryDateMonthsController,
                          calorieDensityController: _calorieDensityController,
                          unitAmountController: _unitAmountController,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Checkboxes Section
                  SectionContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(
                          icon: Icons.settings,
                          title: 'Product Options',
                        ),
                        const SizedBox(height: 20),
                        ProductCheckboxes(
                          isFeatured: _isFeatured,
                          isOrganic: _isOrganic,
                          onFeaturedChanged: (value) {
                            setState(() {
                              _isFeatured = value ?? false;
                            });
                          },
                          onOrganicChanged: (value) {
                            setState(() {
                              _isOrganic = value ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Submit Button
                  CustomButton(
                    onPressed: _submitForm,
                    text: _isEditing ? 'Update Product' : 'Add Product',
                    icon: _isEditing ? Icons.save : Icons.add,
                    isLoading: widget.isLoading,
                    loadingText: _isEditing ? 'Updating...' : 'Adding...',
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // Loading Overlay
          if (widget.isLoading)
            LoadingOverlay(
              message: _isEditing ? 'Updating Product...' : 'Adding Product...',
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productPriceController.dispose();
    _productCodeController.dispose();
    _productDescriptionController.dispose();
    _expiryDateMonthsController.dispose();
    _calorieDensityController.dispose();
    _unitAmountController.dispose();
    super.dispose();
  }
}
