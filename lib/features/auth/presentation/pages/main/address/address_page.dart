// ignore_for_file: use_build_context_synchronously, deprecated_member_use

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
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/main_heading.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';

class AddressPage extends StatelessWidget {
  final String userId;

  const AddressPage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddressBloc(
          getAddressUsecase: sl(),
          addAddressUsecase: sl(),
          updateAddressUsecase: sl(),
          deleteAddressUsecase: sl(),
          setDefaultAddressUsecase: sl(),
          getCurrentLocationUsecase: sl())
        ..add(LoadAddressesEvent(userId: userId)),
      child: Scaffold(
        backgroundColor: context.cs.surface,
        appBar: AppBar(
          backgroundColor: context.cs.surface,
          elevation: 0,
          leading: BackButton(),
          title: AppHeading('My Addresses'),
          centerTitle: true,
        ),
        body: BlocConsumer<AddressBloc, AddressState>(
          listener: (context, state) {
            if (state is AddressErrorState) {
              showToast(context, state.message);
            }
            if (state is AddressDeletedState) {
              showToast(context, state.message);
            }
            if (state is DefaultAddressSetState) {
              showToast(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is AddressLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is AddressesLoadedState) {
              if (state.addresses.isEmpty) {
                return EmptyAddressView(
                  onAddAddress: () => _navigateToAddAddress(context),
                );
              }

              return AddressListView(
                addresses: state.addresses,
                userId: userId,
                onAddAddress: () => _navigateToAddAddress(context),
                onEditAddress: (address) =>
                    _navigateToEditAddress(context, address),
              );
            }

            return EmptyAddressView(
              onAddAddress: () => _navigateToAddAddress(context),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _navigateToAddAddress(context),
          backgroundColor: context.cs.primary,
          icon: Icon(Icons.add, color: context.cs.onPrimary),
          label: Text(
            'Add Address',
            style: context.ts.labelLarge?.copyWith(
              color: context.cs.onPrimary,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToAddAddress(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditAddressPage(
          userId: userId,
        ),
      ),
    ).then((_) {
      context.read<AddressBloc>().add(LoadAddressesEvent(userId: userId));
    });
  }

  void _navigateToEditAddress(BuildContext context, AddressEntities address) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditAddressPage(
          userId: userId,
          address: address,
        ),
      ),
    ).then((_) {
      context.read<AddressBloc>().add(LoadAddressesEvent(userId: userId));
    });
  }
}

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
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.cs.onSurface),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            isEditMode ? 'Edit Address' : 'Add Address',
            style: context.ts.titleLarge,
          ),
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
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddressLabelSelector(),
              24.h,
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
              16.h,
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
              16.h,
              BlocBuilder<AddressFormCubit, AddressFormState>(
                builder: (context, state) {
                  return AddressTextField(
                    initialValue: state.address1,
                    label: 'Address Line 1',
                    icon: Icons.location_on_outlined,
                    onChanged: (value) =>
                        context.read<AddressFormCubit>().updateAddress1(value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Address is required';
                      }
                      return null;
                    },
                  );
                },
              ),
              16.h,
              BlocBuilder<AddressFormCubit, AddressFormState>(
                builder: (context, state) {
                  return AddressTextField(
                    initialValue: state.address2,
                    label: 'Address Line 2',
                    icon: Icons.location_on_outlined,
                    onChanged: (value) =>
                        context.read<AddressFormCubit>().updateAddress2(value),
                  );
                },
              ),
              16.h,
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
                  12.w,
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
              16.h,
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
              16.h,
              LocationPickerButton(),
              16.h,
              BlocBuilder<AddressFormCubit, AddressFormState>(
                builder: (context, state) {
                  return CheckboxListTile(
                    value: state.isDefault,
                    onChanged: (value) =>
                        context.read<AddressFormCubit>().toggleDefault(),
                    title: Text(
                      'Set as default address',
                      style: context.ts.bodyLarge,
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: context.cs.primary,
                  );
                },
              ),
              32.h,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      isLoading ? null : () => _saveAddress(context, formKey),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.cs.primary,
                    foregroundColor: context.cs.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: context.cs.onPrimary,
                          ),
                        )
                      : Text(
                          isEditMode ? 'Update Address' : 'Save Address',
                          style: context.ts.titleMedium?.copyWith(
                            color: context.cs.onPrimary,
                          ),
                        ),
                ),
              ),
            ],
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

class AddressLabelSelector extends StatelessWidget {
  const AddressLabelSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressFormCubit, AddressFormState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Address Type',
              style: context.ts.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            12.h,
            Row(
              children: [
                Expanded(
                  child: AddressLabelOption(
                    label: 'Home',
                    icon: Icons.home_outlined,
                    isSelected: state.label == 'Home',
                    onTap: () =>
                        context.read<AddressFormCubit>().updateLabel('Home'),
                  ),
                ),
                12.w,
                Expanded(
                  child: AddressLabelOption(
                    label: 'Work',
                    icon: Icons.work_outline,
                    isSelected: state.label == 'Work',
                    onTap: () =>
                        context.read<AddressFormCubit>().updateLabel('Work'),
                  ),
                ),
                12.w,
                Expanded(
                  child: AddressLabelOption(
                    label: 'Other',
                    icon: Icons.location_on_outlined,
                    isSelected: state.label == 'Other',
                    onTap: () =>
                        context.read<AddressFormCubit>().updateLabel('Other'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class AddressLabelOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const AddressLabelOption({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? context.cs.primaryContainer
              : context.cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? context.cs.primary : context.cs.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? context.cs.onPrimaryContainer
                  : context.cs.onSurfaceVariant,
              size: 28,
            ),
            8.h,
            Text(
              label,
              style: context.ts.bodyMedium?.copyWith(
                color: isSelected
                    ? context.cs.onPrimaryContainer
                    : context.cs.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
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
      style: context.ts.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: context.ts.bodyMedium?.copyWith(
          color: context.cs.onSurfaceVariant,
        ),
        prefixIcon: Icon(icon, color: context.cs.onSurfaceVariant),
        filled: true,
        fillColor: context.cs.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: context.cs.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: context.cs.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: context.cs.error,
            width: 2,
          ),
        ),
        counterText: maxLength != null ? null : '',
      ),
    );
  }
}

class EmptyAddressView extends StatelessWidget {
  final VoidCallback onAddAddress;

  const EmptyAddressView({
    super.key,
    required this.onAddAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 120,
              color: context.cs.onSurfaceVariant.withOpacity(0.5),
            ),
            24.h,
            Text(
              'No Addresses Yet',
              style: context.ts.headlineSmall?.copyWith(
                color: context.cs.onSurface,
              ),
            ),
            12.h,
            Text(
              'Add your delivery address to get started',
              textAlign: TextAlign.center,
              style: context.ts.bodyMedium?.copyWith(
                color: context.cs.onSurfaceVariant,
              ),
            ),
            32.h,
            ElevatedButton.icon(
              onPressed: onAddAddress,
              icon: const Icon(Icons.add),
              label: const Text('Add Address'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.cs.primary,
                foregroundColor: context.cs.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddressListView extends StatelessWidget {
  final List<AddressEntities> addresses;
  final String userId;
  final VoidCallback onAddAddress;
  final Function(AddressEntities) onEditAddress;

  const AddressListView({
    super.key,
    required this.addresses,
    required this.userId,
    required this.onAddAddress,
    required this.onEditAddress,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: addresses.length,
      separatorBuilder: (context, index) => 16.h,
      itemBuilder: (context, index) {
        final address = addresses[index];
        return AddressCard(
          address: address,
          userId: userId,
          onEdit: () => onEditAddress(address),
        );
      },
    );
  }
}

class AddressCard extends StatelessWidget {
  final AddressEntities address;
  final String userId;
  final VoidCallback onEdit;

  const AddressCard({
    super.key,
    required this.address,
    required this.userId,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: address.isDefault
              ? context.cs.primary
              : context.cs.outlineVariant,
          width: address.isDefault ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: address.isDefault
                        ? context.cs.primaryContainer
                        : context.cs.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getLabelIcon(address.label),
                        size: 16,
                        color: address.isDefault
                            ? context.cs.onPrimaryContainer
                            : context.cs.onSecondaryContainer,
                      ),
                      6.w,
                      Text(
                        address.label,
                        style: context.ts.labelMedium?.copyWith(
                          color: address.isDefault
                              ? context.cs.onPrimaryContainer
                              : context.cs.onSecondaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (address.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: context.cs.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'DEFAULT',
                      style: context.ts.labelSmall?.copyWith(
                        color: context.cs.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            16.h,
            Text(
              address.fullName,
              style: context.ts.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            4.h,
            Text(
              address.phoneNumber,
              style: context.ts.bodyMedium?.copyWith(
                color: context.cs.onSurfaceVariant,
              ),
            ),
            12.h,
            Text(
              '${address.address1}, ${address.address2}',
              style: context.ts.bodyMedium,
            ),
            4.h,
            Text(
              '${address.city}, ${address.state} - ${address.pincode}',
              style: context.ts.bodyMedium,
            ),
            16.h,
            Row(
              children: [
                if (!address.isDefault)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<AddressBloc>().add(
                              SetDefaultAddressEvent(
                                userId: userId,
                                addressId: address.id,
                              ),
                            );
                      },
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text('Set Default'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.cs.primary,
                        side: BorderSide(color: context.cs.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                if (!address.isDefault) 12.w,
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.cs.onSurface,
                      side: BorderSide(color: context.cs.outlineVariant),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                12.w,
                OutlinedButton(
                  onPressed: () => _showDeleteDialog(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.cs.error,
                    side: BorderSide(color: context.cs.error),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Icon(Icons.delete_outline, size: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getLabelIcon(String label) {
    switch (label.toLowerCase()) {
      case 'home':
        return Icons.home_outlined;
      case 'work':
        return Icons.work_outline;
      case 'other':
        return Icons.location_on_outlined;
      default:
        return Icons.location_on_outlined;
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<AddressBloc>().add(
                    DeleteAddressEvent(
                      userId: userId,
                      addressId: address.id,
                    ),
                  );
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(
              foregroundColor: context.cs.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}