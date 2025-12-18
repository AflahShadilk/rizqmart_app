// // ignore_for_file: use_build_context_synchronously, deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rizqmart/core/services/registeration/register.dart';
// import 'package:rizqmart/core/theme/context_theme.dart';
// import 'package:rizqmart/features/auth/domain/entities/main/address_entities.dart';
// import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/address/address_form_cubit/address_form_cubit.dart';
// import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/address/address_form_cubit/address_form_state.dart';
// import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_bloc.dart';
// import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_event.dart';
// import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_state.dart';
// import 'package:rizqmart/features/auth/presentation/pages/address/widget/address_card.dart';
// import 'package:rizqmart/features/auth/presentation/pages/address/widget/address_picker_button.dart';
// import 'package:rizqmart/features/auth/presentation/pages/address/widget/empty_address.dart';
// import 'package:rizqmart/features/auth/presentation/pages/address/widget/label_and_selection.dart';
// import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
// import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/main_heading.dart';
// import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';

// class AddressPage extends StatelessWidget {
//   final String userId;

//   const AddressPage({
//     super.key,
//     required this.userId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => AddressBloc(
//           getAddressUsecase: sl(),
//           addAddressUsecase: sl(),
//           updateAddressUsecase: sl(),
//           deleteAddressUsecase: sl(),
//           setDefaultAddressUsecase: sl(),
//           getCurrentLocationUsecase: sl())
//         ..add(LoadAddressesEvent(userId: userId)),
//       child: Scaffold(
//         backgroundColor: context.cs.surface,
//         appBar: AppBar(
//           backgroundColor: context.cs.surface,
//           elevation: 0,
//           leading: BackButton(),
//           title: AppHeading('My Addresses'),
//           centerTitle: true,
//         ),
//         body: BlocConsumer<AddressBloc, AddressState>(
//           listener: (context, state) {
//             if (state is AddressErrorState) {
//               showToast(context, state.message);
//             }
//             if (state is AddressDeletedState) {
//               showToast(context, state.message);
//             }
//             if (state is DefaultAddressSetState) {
//               showToast(context, state.message);
//             }
//           },
//           builder: (context, state) {
//             if (state is AddressLoadingState) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }

//             if (state is AddressesLoadedState) {
//               if (state.addresses.isEmpty) {
//                 return EmptyAddressView(
//                   onAddAddress: () => _navigateToAddAddress(context),
//                 );
//               }

//               return AddressListView(
//                 addresses: state.addresses,
//                 userId: userId,
//                 onAddAddress: () => _navigateToAddAddress(context),
//                 onEditAddress: (address) =>
//                     _navigateToEditAddress(context, address),
//               );
//             }

//             return EmptyAddressView(
//               onAddAddress: () => _navigateToAddAddress(context),
//             );
//           },
//         ),
//         floatingActionButton: FloatingActionButton.extended(
//           onPressed: () => _navigateToAddAddress(context),
//           backgroundColor: context.cs.primary,
//           icon: Icon(Icons.add, color: context.cs.onPrimary),
//           label: Text(
//             'Add Address',
//             style: context.ts.labelLarge?.copyWith(
//               color: context.cs.onPrimary,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _navigateToAddAddress(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => AddEditAddressPage(
//           userId: userId,
//         ),
//       ),
//     ).then((_) {
//       context.read<AddressBloc>().add(LoadAddressesEvent(userId: userId));
//     });
//   }

//   void _navigateToEditAddress(BuildContext context, AddressEntities address) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => AddEditAddressPage(
//           userId: userId,
//           address: address,
//         ),
//       ),
//     ).then((_) {
//       context.read<AddressBloc>().add(LoadAddressesEvent(userId: userId));
//     });
//   }
// }

// class AddEditAddressPage extends StatelessWidget {
//   final String userId;
//   final AddressEntities? address;

//   const AddEditAddressPage({
//     super.key,
//     required this.userId,
//     this.address,
//   });

//   bool get isEditMode => address != null;

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => AddressFormCubit(address),
//         ),
//         BlocProvider(
//           create: (context) => AddressBloc(
//             getAddressUsecase: sl(),
//             addAddressUsecase: sl(),
//             updateAddressUsecase: sl(),
//             deleteAddressUsecase: sl(),
//             setDefaultAddressUsecase: sl(),
//             getCurrentLocationUsecase: sl(),
//           ),
//         ),
//       ],
//       child: Scaffold(
//         backgroundColor: context.cs.surface,
//         appBar: AppBar(
//           backgroundColor: context.cs.surface,
//           elevation: 0,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: context.cs.onSurface),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//           title: Text(
//             isEditMode ? 'Edit Address' : 'Add Address',
//             style: context.ts.titleLarge,
//           ),
//         ),
//         body: BlocConsumer<AddressBloc, AddressState>(
//           listener: (context, state) {
//             if (state is AddressAddedState || state is AddressUpdatedState) {
//               Navigator.of(context).pop();
//               showToast(
//                 context,
//                 isEditMode
//                     ? 'Address updated successfully'
//                     : 'Address added successfully',
//               );
//             }
//             if (state is AddressErrorState) {
//               showToast(context, state.message);
//             }
//           },
//           builder: (context, state) {
//             return AddressFormContent(
//               userId: userId,
//               isEditMode: isEditMode,
//               isLoading: state is AddressLoadingState,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class AddressFormContent extends StatelessWidget {
//   final String userId;
//   final bool isEditMode;
//   final bool isLoading;

//   const AddressFormContent({
//     super.key,
//     required this.userId,
//     required this.isEditMode,
//     required this.isLoading,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final formKey = GlobalKey<FormState>();

//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AddressLabelSelector(),
//               24.h,
//               BlocBuilder<AddressFormCubit, AddressFormState>(
//                 builder: (context, state) {
//                   return AddressTextField(
//                     initialValue: state.fullName,
//                     label: 'Full Name',
//                     icon: Icons.person_outline,
//                     onChanged: (value) =>
//                         context.read<AddressFormCubit>().updateFullName(value),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Full name is required';
//                       }
//                       return null;
//                     },
//                   );
//                 },
//               ),
//               16.h,
//               BlocBuilder<AddressFormCubit, AddressFormState>(
//                 builder: (context, state) {
//                   return AddressTextField(
//                     initialValue: state.phoneNumber,
//                     label: 'Phone Number',
//                     icon: Icons.phone_outlined,
//                     keyboardType: TextInputType.phone,
//                     onChanged: (value) => context
//                         .read<AddressFormCubit>()
//                         .updatePhoneNumber(value),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Phone number is required';
//                       }
//                       if (value.length != 10) {
//                         return 'Enter a valid 10-digit phone number';
//                       }
//                       return null;
//                     },
//                   );
//                 },
//               ),
//               16.h,
//               BlocBuilder<AddressFormCubit, AddressFormState>(
//                 builder: (context, state) {
//                   return AddressTextField(
//                     initialValue: state.address1,
//                     label: 'Address Line 1',
//                     icon: Icons.location_on_outlined,
//                     onChanged: (value) =>
//                         context.read<AddressFormCubit>().updateAddress1(value),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Address is required';
//                       }
//                       return null;
//                     },
//                   );
//                 },
//               ),
//               16.h,
//               BlocBuilder<AddressFormCubit, AddressFormState>(
//                 builder: (context, state) {
//                   return AddressTextField(
//                     initialValue: state.address2,
//                     label: 'Address Line 2',
//                     icon: Icons.location_on_outlined,
//                     onChanged: (value) =>
//                         context.read<AddressFormCubit>().updateAddress2(value),
//                   );
//                 },
//               ),
//               16.h,
//               Row(
//                 children: [
//                   Expanded(
//                     child: BlocBuilder<AddressFormCubit, AddressFormState>(
//                       builder: (context, state) {
//                         return AddressTextField(
//                           initialValue: state.city,
//                           label: 'City',
//                           icon: Icons.location_city_outlined,
//                           onChanged: (value) => context
//                               .read<AddressFormCubit>()
//                               .updateCity(value),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'City is required';
//                             }
//                             return null;
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                   12.w,
//                   Expanded(
//                     child: BlocBuilder<AddressFormCubit, AddressFormState>(
//                       builder: (context, state) {
//                         return AddressTextField(
//                           initialValue: state.state,
//                           label: 'State',
//                           icon: Icons.map_outlined,
//                           onChanged: (value) => context
//                               .read<AddressFormCubit>()
//                               .updateState(value),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'State is required';
//                             }
//                             return null;
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               16.h,
//               BlocBuilder<AddressFormCubit, AddressFormState>(
//                 builder: (context, state) {
//                   return AddressTextField(
//                     initialValue: state.pincode,
//                     label: 'Pincode',
//                     icon: Icons.pin_outlined,
//                     keyboardType: TextInputType.number,
//                     maxLength: 6,
//                     onChanged: (value) =>
//                         context.read<AddressFormCubit>().updatePincode(value),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Pincode is required';
//                       }
//                       if (value.length != 6) {
//                         return 'Enter a valid 6-digit pincode';
//                       }
//                       return null;
//                     },
//                   );
//                 },
//               ),
//               16.h,
//               LocationPickerButton(),
//               16.h,
//               BlocBuilder<AddressFormCubit, AddressFormState>(
//                 builder: (context, state) {
//                   return CheckboxListTile(
//                     value: state.isDefault,
//                     onChanged: (value) =>
//                         context.read<AddressFormCubit>().toggleDefault(),
//                     title: Text(
//                       'Set as default address',
//                       style: context.ts.bodyLarge,
//                     ),
//                     controlAffinity: ListTileControlAffinity.leading,
//                     contentPadding: EdgeInsets.zero,
//                     activeColor: context.cs.primary,
//                   );
//                 },
//               ),
//               32.h,
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed:
//                       isLoading ? null : () => _saveAddress(context, formKey),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: context.cs.primary,
//                     foregroundColor: context.cs.onPrimary,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: isLoading
//                       ? SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: context.cs.onPrimary,
//                           ),
//                         )
//                       : Text(
//                           isEditMode ? 'Update Address' : 'Save Address',
//                           style: context.ts.titleMedium?.copyWith(
//                             color: context.cs.onPrimary,
//                           ),
//                         ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _saveAddress(BuildContext context, GlobalKey<FormState> formKey) {
//     if (formKey.currentState!.validate()) {
//       final formState = context.read<AddressFormCubit>().state;
//       final addressBloc = context.read<AddressBloc>();

//       if (isEditMode) {
//         final existingAddress =
//             (context.findAncestorWidgetOfExactType<AddEditAddressPage>())
//                 ?.address;

//         if (existingAddress != null) {
//           final updatedAddress = existingAddress.copyWith(
//             label: formState.label,
//             fullName: formState.fullName,
//             phoneNumber: formState.phoneNumber,
//             address1: formState.address1,
//             address2: formState.address2,
//             city: formState.city,
//             state: formState.state,
//             pincode: formState.pincode,
//             latitude: formState.latitude,
//             longitude: formState.longitude,
//             isDefault: formState.isDefault,
//           );

//           addressBloc.add(UpdateAddressEvent(address: updatedAddress));
//         }
//       } else {
//         final newAddress = AddressEntities(
//           id: '',
//           userId: userId,
//           label: formState.label,
//           fullName: formState.fullName,
//           phoneNumber: formState.phoneNumber,
//           address1: formState.address1,
//           address2: formState.address2,
//           city: formState.city,
//           state: formState.state,
//           pincode: formState.pincode,
//           latitude: formState.latitude,
//           longitude: formState.longitude,
//           isDefault: formState.isDefault,
//           createdAt: DateTime.now(),
//         );

//         addressBloc.add(AddAddressEvent(address: newAddress));
//       }
//     }
//   }
// }

// class AddressTextField extends StatelessWidget {
//   final String? initialValue;
//   final String label;
//   final IconData icon;
//   final TextInputType keyboardType;
//   final int? maxLength;
//   final Function(String) onChanged;
//   final String? Function(String?)? validator;

//   const AddressTextField({
//     super.key,
//     this.initialValue,
//     required this.label,
//     required this.icon,
//     this.keyboardType = TextInputType.text,
//     this.maxLength,
//     required this.onChanged,
//     this.validator,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       initialValue: initialValue,
//       keyboardType: keyboardType,
//       maxLength: maxLength,
//       onChanged: onChanged,
//       validator: validator,
//       style: context.ts.bodyLarge,
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: context.ts.bodyMedium?.copyWith(
//           color: context.cs.onSurfaceVariant,
//         ),
//         prefixIcon: Icon(icon, color: context.cs.onSurfaceVariant),
//         filled: true,
//         fillColor: context.cs.surfaceContainerHighest,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             color: context.cs.primary,
//             width: 2,
//           ),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             color: context.cs.error,
//             width: 1,
//           ),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             color: context.cs.error,
//             width: 2,
//           ),
//         ),
//         counterText: maxLength != null ? null : '',
//       ),
//     );
//   }
// }



// class AddressListView extends StatelessWidget {
//   final List<AddressEntities> addresses;
//   final String userId;
//   final VoidCallback onAddAddress;
//   final Function(AddressEntities) onEditAddress;

//   const AddressListView({
//     super.key,
//     required this.addresses,
//     required this.userId,
//     required this.onAddAddress,
//     required this.onEditAddress,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       padding: const EdgeInsets.all(16),
//       itemCount: addresses.length,
//       separatorBuilder: (context, index) => 16.h,
//       itemBuilder: (context, index) {
//         final address = addresses[index];
//         return AddressCard(
//           address: address,
//           userId: userId,
//           onEdit: () => onEditAddress(address),
//         );
//       },
//     );
//   }
// }

