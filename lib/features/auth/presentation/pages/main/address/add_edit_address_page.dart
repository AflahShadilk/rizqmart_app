

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/services/registeration/register.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/address_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/address/address_form_cubit/address_form_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/address/address_form_cubit/address_form_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/address/widget/address_picker_button.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/address/widget/label_and_selection.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/back_button_common.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/main_heading.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';

class AddEditAddressPage extends StatelessWidget {
  final String userId;
  final AddressEntities? address;

  const AddEditAddressPage({
    super.key,
    required this.userId,
    this.address,
  });

  bool get isEditMode => address != null;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AddressFormCubit(address),
        ),
        BlocProvider(
          create: (context) => AddressBloc(
            getAddressUsecase: sl(),
            addAddressUsecase: sl(),
            updateAddressUsecase: sl(),
            deleteAddressUsecase: sl(),
            setDefaultAddressUsecase: sl(),
            getCurrentLocationUsecase: sl(),
          ),
        ),
      ],
      child: Scaffold(
        backgroundColor: context.cs.surface,
        appBar: AppBar(
          backgroundColor: context.cs.surface,
          elevation: 0,
          leading: BackButtonCommon(colorScheme: context.cs),
          title: AppHeading(
            isEditMode ? 'Edit Address' : 'Add Address',
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<AddressBloc, AddressState>(
          listener: (context, state) {
            if (state is AddressAddedState || state is AddressUpdatedState) {
              Navigator.of(context).pop();
              showToast(
                context,
                isEditMode
                    ? 'Address updated successfully'
                    : 'Address added successfully',
              );
            }
            if (state is AddressErrorState) {
              showToast(context, state.message);
            }
          },
          builder: (context, state) {
            return AddressFormContent(
              userId: userId,
              isEditMode: isEditMode,
              isLoading: state is AddressLoadingState,
            );
          },
        ),
      ),
    );
  }
}

class AddressFormContent extends StatelessWidget {
  final String userId;
  final bool isEditMode;
  final bool isLoading;

  const AddressFormContent({
    super.key,
    required this.userId,
    required this.isEditMode,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(context, 'Address Type'),
              8.h,
              AddressLabelSelector(),
              22.h,
              _buildSectionTitle(context, 'Contact Information'),
              14.h,
              BlocBuilder<AddressFormCubit, AddressFormState>(
                builder: (context, state) {
                  return AddressTextField(
                    initialValue: state.fullName,
                    label: 'Full Name',
                    icon: Icons.person_outline,
                    onChanged: (value) =>
                        context.read<AddressFormCubit>().updateFullName(value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Full name is required';
                      }
                      return null;
                    },
                  );
                },
              ),
              12.h,
              BlocBuilder<AddressFormCubit, AddressFormState>(
                builder: (context, state) {
                  return AddressTextField(
                    initialValue: state.phoneNumber,
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    onChanged: (value) => context
                        .read<AddressFormCubit>()
                        .updatePhoneNumber(value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number is required';
                      }
                      if (value.length != 10) {
                        return 'Enter a valid 10-digit phone number';
                      }
                      return null;
                    },
                  );
                },
              ),
              22.h,
              _buildSectionTitle(context, 'Address Details'),
              14.h,
              BlocBuilder<AddressFormCubit, AddressFormState>(
                builder: (context, state) {
                  return AddressTextField(
                    initialValue: state.address1,
                    label: 'Street Address',
                    icon: Icons.location_on_outlined,
                    onChanged: (value) =>
                        context.read<AddressFormCubit>().updateAddress1(value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Street address is required';
                      }
                      return null;
                    },
                  );
                },
              ),
              12.h,
              BlocBuilder<AddressFormCubit, AddressFormState>(
                builder: (context, state) {
                  return AddressTextField(
                    initialValue: state.address2,
                    label: 'Apartment, suite, etc. (Optional)',
                    icon: Icons.location_on_outlined,
                    onChanged: (value) =>
                        context.read<AddressFormCubit>().updateAddress2(value),
                  );
                },
              ),
              12.h,
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<AddressFormCubit, AddressFormState>(
                      builder: (context, state) {
                        return AddressTextField(
                          initialValue: state.city,
                          label: 'City',
                          icon: Icons.location_city_outlined,
                          onChanged: (value) => context
                              .read<AddressFormCubit>()
                              .updateCity(value),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'City is required';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                  ),
                  10.w,
                  Expanded(
                    child: BlocBuilder<AddressFormCubit, AddressFormState>(
                      builder: (context, state) {
                        return AddressTextField(
                          initialValue: state.state,
                          label: 'State',
                          icon: Icons.map_outlined,
                          onChanged: (value) => context
                              .read<AddressFormCubit>()
                              .updateState(value),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'State is required';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              12.h,
              BlocBuilder<AddressFormCubit, AddressFormState>(
                builder: (context, state) {
                  return AddressTextField(
                    initialValue: state.pincode,
                    label: 'Pincode',
                    icon: Icons.pin_outlined,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    onChanged: (value) =>
                        context.read<AddressFormCubit>().updatePincode(value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pincode is required';
                      }
                      if (value.length != 6) {
                        return 'Enter a valid 6-digit pincode';
                      }
                      return null;
                    },
                  );
                },
              ),
              12.h,
              LocationPickerButton(),
              20.h,
              _buildDefaultAddressSection(context),
              28.h,
              _buildSaveButton(context, isLoading, () => _saveAddress(context, formKey)),
              16.h,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: context.ts.labelLarge?.copyWith(
        color: context.cs.onSurface,
        fontWeight: FontWeight.w600,
        fontSize: 13,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildDefaultAddressSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cs.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.cs.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: BlocBuilder<AddressFormCubit, AddressFormState>(
        builder: (context, state) {
          return CheckboxListTile(
            value: state.isDefault,
            onChanged: (value) =>
                context.read<AddressFormCubit>().toggleDefault(),
            title: Text(
              'Set as default address',
              style: context.ts.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.cs.onSurface,
              ),
            ),
            subtitle: Text(
              'Use this for faster checkout on next order',
              style: context.ts.bodySmall?.copyWith(
                color: context.cs.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: context.cs.primary,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          );
        },
      ),
    );
  }

  Widget _buildSaveButton(
    BuildContext context,
    bool isLoading,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.cs.primary,
          foregroundColor: context.cs.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: isLoading
            ? SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: context.cs.onPrimary,
                ),
              )
            : Text(
                isEditMode ? 'Update Address' : 'Save Address',
                style: context.ts.labelLarge?.copyWith(
                  color: context.cs.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  void _saveAddress(BuildContext context, GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
      final formState = context.read<AddressFormCubit>().state;
      final addressBloc = context.read<AddressBloc>();

      if (isEditMode) {
        final existingAddress =
            (context.findAncestorWidgetOfExactType<AddEditAddressPage>())
                ?.address;

        if (existingAddress != null) {
          final updatedAddress = existingAddress.copyWith(
            label: formState.label,
            fullName: formState.fullName,
            phoneNumber: formState.phoneNumber,
            address1: formState.address1,
            address2: formState.address2,
            city: formState.city,
            state: formState.state,
            pincode: formState.pincode,
            latitude: formState.latitude,
            longitude: formState.longitude,
            isDefault: formState.isDefault,
          );

          addressBloc.add(UpdateAddressEvent(address: updatedAddress));
        }
      } else {
        final newAddress = AddressEntities(
          id: '',
          userId: userId,
          label: formState.label,
          fullName: formState.fullName,
          phoneNumber: formState.phoneNumber,
          address1: formState.address1,
          address2: formState.address2,
          city: formState.city,
          state: formState.state,
          pincode: formState.pincode,
          latitude: formState.latitude,
          longitude: formState.longitude,
          isDefault: formState.isDefault,
          createdAt: DateTime.now(),
        );

        addressBloc.add(AddAddressEvent(address: newAddress));
      }
    }
  }
}

class AddressTextField extends StatelessWidget {
  final String? initialValue;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final int? maxLength;
  final Function(String) onChanged;
  final String? Function(String?)? validator;

  const AddressTextField({
    super.key,
    this.initialValue,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      maxLength: maxLength,
      onChanged: onChanged,
      validator: validator,
      style: context.ts.bodyMedium?.copyWith(
        color: context.cs.onSurface,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: context.ts.bodySmall?.copyWith(
          color: context.cs.onSurfaceVariant,
          fontSize: 12,
        ),
        prefixIcon: Icon(
          icon,
          color: context.cs.onSurfaceVariant,
          size: 18,
        ),
        filled: true,
        fillColor: context.cs.surfaceContainerHighest.withValues(alpha: 0.5),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: context.cs.outlineVariant.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: context.cs.outlineVariant.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: context.cs.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: context.cs.error.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: context.cs.error,
            width: 1.5,
          ),
        ),
        counterText: maxLength != null ? null : '',
        errorStyle: TextStyle(
          color: context.cs.error,
          fontSize: 11,
        ),
      ),
    );
  }
}