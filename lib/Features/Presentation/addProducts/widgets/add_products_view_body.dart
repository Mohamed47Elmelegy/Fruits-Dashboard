import 'dart:io';
import 'package:flutter/material.dart';
import 'package:furute_app_dashbord/Features/Presentation/addProducts/widgets/image_field.dart';
import 'package:furute_app_dashbord/Features/Presentation/addProducts/widgets/is_featured_checkbox.dart';
import 'package:furute_app_dashbord/Features/domain/Entity/add_proudcuts_entity.dart';
import 'package:furute_app_dashbord/core/extensions/padding_ext.dart';
import 'package:furute_app_dashbord/core/widgets/butn.dart';
import 'package:furute_app_dashbord/core/widgets/custom_text_field.dart';
import 'package:gap/gap.dart';
import 'dart:developer';

import '../../../../core/errors/validator.dart';
import '../../../../core/theme/colors_theme.dart';

class AddProductsViewBody extends StatefulWidget {
  const AddProductsViewBody({super.key});

  @override
  State<AddProductsViewBody> createState() => _AddProductsViewBodyState();
}

class _AddProductsViewBodyState extends State<AddProductsViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  bool isFeatured = false;
  late String productName;
  late num productPrice;
  late String productCode;
  File? image;
  late String productDescription;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        autovalidateMode: autovalidateMode,
        child: Column(
          children: [
            CustomTextField(
              onValidate: Validator.validate,
              onSaved: (value) {
                productName = value!;
              },
              hint: 'Product Name',
              keyboardType: TextInputType.text,
            ),
            const Gap(16),
            CustomTextField(
              onValidate: Validator.validate,
              onSaved: (value) {
                productPrice = num.parse(value!);
              },
              hint: 'Product Price',
              keyboardType: TextInputType.text,
            ),
            const Gap(16),
            CustomTextField(
              onValidate: Validator.validate,
              onSaved: (value) {
                productCode = value!.toLowerCase();
              },
              hint: 'Product Code',
              keyboardType: TextInputType.text,
            ),
            const Gap(16),
            CustomTextField(
              onValidate: Validator.validate,
              onSaved: (value) {
                productDescription = value!;
              },
              hint: 'Product Description ',
              keyboardType: TextInputType.text,
              maxLines: 5,
            ),
            const Gap(16),
            IsFeaturedCheckbox(onChanged: (value) {
              isFeatured = value;
              setState(() {});
            }),
            const Gap(16),
            ImageField(
              onFileChange: (image) {
                this.image = image;
              },
            ),
            const Gap(16),
            Butn(
                text: 'Add Product',
                color: AppColors.green1_500,
                onPressed: () {
                  if (image != null) {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      AddProductsEntity addProducts = AddProductsEntity(
                          productCode: productCode,
                          productName: productName,
                          productPrice: productPrice,
                          productDescription: productDescription,
                          productImage: image!,
                          isFeatured: isFeatured);
                      log('Product Name: $productName');
                      log('Product Price: $productPrice');
                      log('Product Code: $productCode');
                      log('Product Description: $productDescription');
                      log('Is Featured: $isFeatured');
                      log('Image: $image');
                    } else {
                      autovalidateMode = AutovalidateMode.always;
                      setState(() {});
                    }
                  } else {
                    showError(context);
                  }
                })
          ],
        ),
      ).setHorizontalPadding(context, 16, enableMediaQuery: false),
    );
  }

  void showError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please Add Image'),
      ),
    );
  }
}
