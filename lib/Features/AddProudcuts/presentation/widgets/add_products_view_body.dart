import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/Data/model/reviews_model.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/Entity/reviews_entity.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/presentation/widgets/image_field.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/presentation/widgets/is_featured_checkbox.dart';
import 'package:furute_app_dashbord/core/extensions/padding_ext.dart';
import 'package:furute_app_dashbord/core/widgets/butn.dart';
import 'package:furute_app_dashbord/core/widgets/custom_text_field.dart';
import 'package:gap/gap.dart';
import '../../../../core/errors/validator.dart';
import '../../../../core/theme/colors_theme.dart';
import '../../../../core/utils/app_images.dart';
import '../../domin/Entity/proudcuts_entity.dart';
import '../manager/cubit/add_product_cubit.dart';
import 'is_organic_checkbox.dart';

class AddProductsViewBody extends StatefulWidget {
  const AddProductsViewBody({super.key});

  @override
  State<AddProductsViewBody> createState() => _AddProductsViewBodyState();
}

class _AddProductsViewBodyState extends State<AddProductsViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late String productName, productCode, productDescription;
  late num productPrice,
      calorieDensity,
      caloriesReferenceWeight,
      expiryDateMonths;
  bool isFeatured = false;
  bool isOrganic = false;
  late List<ReviewsModel> reviews = [];
  File? image;
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
              keyboardType: TextInputType.number,
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
                calorieDensity = num.parse(value!);
              },
              hint: 'Calorie Density',
              keyboardType: TextInputType.number,
            ),
            const Gap(16),
            CustomTextField(
              onValidate: Validator.validate,
              onSaved: (value) {
                caloriesReferenceWeight = num.parse(value!);
              },
              hint: 'Calories Reference Weight',
              keyboardType: TextInputType.number,
            ),
            const Gap(16),
            CustomTextField(
              onValidate: Validator.validate,
              onSaved: (value) {
                expiryDateMonths = num.parse(value!);
              },
              hint: 'ExpiryDate Per Months',
              keyboardType: TextInputType.number,
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
            IsOrganicCheckbox(onChanged: (value) {
              isOrganic = value;
              setState(() {});
            }),
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
                    ProductsEntity addProducts = ProductsEntity(
                      productName: productName,
                      productPrice: productPrice,
                      productCode: productCode,
                      productDescription: productDescription,
                      calorieDensity: calorieDensity.toInt(),
                      caloriesReferenceWeight: caloriesReferenceWeight.toInt(),
                      expiryDateMonths: expiryDateMonths.toInt(),
                      isOrganic: isOrganic,
                      isFeatured: isFeatured,
                      productImage: image!,
                      reviews: [
                        ReviewsEntity(
                            name: 'Mohamed',
                            image: Assets.imagesStrawberry,
                            rating: 4.5,
                            date: DateTime.now().toIso8601String(),
                            description: 'Good Product')
                      ],
                    );
                    context.read<AddProductCubit>().addProduct(addProducts);
                  } else {
                    autovalidateMode = AutovalidateMode.always;
                    setState(() {});
                  }
                } else {
                  showError(context);
                }
              },
            )
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
