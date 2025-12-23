// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/services/registeration/register.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/address_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/address/address_selection_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/address/select_address_cubit.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/address/address_list_view_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/address/widget/empty_address.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/main_heading.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';

class AddressDisplayPage extends StatelessWidget {
  final String userId;
  final bool isSelecting;

  const AddressDisplayPage({
    super.key,
    required this.userId,
    this.isSelecting = false,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AddressBloc(
              getAddressUsecase: sl(),
              addAddressUsecase: sl(),
              updateAddressUsecase: sl(),
              deleteAddressUsecase: sl(),
              setDefaultAddressUsecase: sl(),
              getCurrentLocationUsecase: sl())
            ..add(LoadAddressesEvent(userId: userId)),
        ),
        BlocProvider(
          create: (context) => AddressSelectionCubit(),
        ),
      ],
      child: Scaffold(
        backgroundColor: context.cs.surface,
        appBar: AppBar(
          backgroundColor: context.cs.surface,
          elevation: 0,
          leading: const BackButton(),
          title: AppHeading(isSelecting ? 'Select Address' : 'My Addresses'),
          centerTitle: true,
        ),
        body: BlocConsumer<AddressBloc, AddressState>(
          listener: (context, state) {
            if (state is AddressErrorState) {
              showToast(context, state.message);
            }
            if (state is AddressDeletedState) {
              showToast(context, state.message);
              context.read<AddressBloc>().add(LoadAddressesEvent(userId: userId));
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
                  onAddAddress: () => navigateToAddAddress(context),
                );
              }

              if (isSelecting) {
                return buildSelectableAddressListView(
                  context,
                  state.addresses,
                );
              }

              return AddressListView(
                addresses: state.addresses,
                userId: userId,
                onAddAddress: () => navigateToAddAddress(context),
                onEditAddress: (address) =>
                    navigateToEditAddress(context, address),
                onDeleteAddress: (address) =>
                    deleteAddress(context, address),
              );
            }

            return EmptyAddressView(
              onAddAddress: () => navigateToAddAddress(context),
            );
          },
        ),
        floatingActionButton: isSelecting
            ? null
            : FloatingActionButton.extended(
                onPressed: () => navigateToAddAddress(context),
                backgroundColor: context.cs.primary,
                icon: Icon(Icons.add, color: context.cs.onPrimary),
                label: Text(
                  'Add Address',
                  style: context.ts.labelLarge?.copyWith(
                    color: context.cs.onPrimary,
                  ),
                ),
              ),
        bottomNavigationBar: isSelecting
            ? BlocBuilder<AddressSelectionCubit, AddressSelectionState>(
                builder: (context, state) {
                  return state.selectedAddress != null
                      ? buildConfirmAddressButton(context, state.selectedAddress!)
                      : const SizedBox.shrink();
                },
              )
            : null,
      ),
    );
  }

  Widget buildSelectableAddressListView(
    BuildContext context,
    List<AddressEntities> addresses,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: addresses.length,
      itemBuilder: (context, index) {
        final address = addresses[index];

        return BlocBuilder<AddressSelectionCubit, AddressSelectionState>(
          builder: (context, state) {
            final isSelected = state.selectedAddress?.id == address.id;
            return buildSelectableAddressCard(context, address, isSelected);
          },
        );
      },
    );
  }

  Widget buildSelectableAddressCard(
    BuildContext context,
    AddressEntities address,
    bool isSelected,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? context.cs.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          context.read<AddressSelectionCubit>().selectAddress(address);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildAddressTypeLabel(context, address),
                    const SizedBox(height: 8),
                    buildAddressDetailsText(context, address),
                  ],
                ),
              ),
              Radio<bool>(
                value: true,
                groupValue: isSelected,
                onChanged: (value) {
                  if (value == true) {
                    context.read<AddressSelectionCubit>().selectAddress(address);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAddressTypeLabel(
    BuildContext context,
    AddressEntities address,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.cs.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        address.label,
        style: context.ts.labelSmall?.copyWith(
          color: context.cs.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildAddressDetailsText(
    BuildContext context,
    AddressEntities address,
  ) {
    return Text(
      '${address.city}, ${address.state}',
      style: context.ts.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget buildConfirmAddressButton(
    BuildContext context,
    AddressEntities selectedAddress,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context, selectedAddress.label);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: context.cs.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          'Confirm Address',
          style: context.ts.labelLarge?.copyWith(
            color: context.cs.onPrimary,
          ),
        ),
      ),
    );
  }

  void navigateToAddAddress(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.addAddress,
      arguments: userId,
    ).then((_) {
      context.read<AddressBloc>().add(LoadAddressesEvent(userId: userId));
    });
  }

  void navigateToEditAddress(BuildContext context, AddressEntities address) {
    Navigator.pushNamed(
      context,
      AppRoutes.editAddress,
      arguments: {
        'userId': userId,
        'address': address,
      },
    ).then((_) {
      context.read<AddressBloc>().add(LoadAddressesEvent(userId: userId));
    });
  }

  void deleteAddress(BuildContext context, AddressEntities address) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Address'),
          content: const Text('Are you sure you want to delete this address?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<AddressBloc>().add(
                  DeleteAddressEvent(
                    userId: userId,
                    addressId: address.id,
                  ),
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}