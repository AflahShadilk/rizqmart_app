// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/services/registeration/register.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/address_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/address/address%20page/address_page_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/address/address%20page/address_page_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/address/address_selection_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/address/select_address_cubit.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/address/address_list_view_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/address/widget/empty_address.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/main_heading.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';

/// Address display page — shows addresses for viewing or selection
class AddressDisplayPage extends StatelessWidget {

  // ---------------- Variables ----------------

  final String userId;
  final bool isSelecting;

  const AddressDisplayPage({
    super.key,
    required this.userId,
    this.isSelecting = false,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    final addressBloc = AddressBloc(
      getAddressUsecase: sl(),
      addAddressUsecase: sl(),
      updateAddressUsecase: sl(),
      deleteAddressUsecase: sl(),
      setDefaultAddressUsecase: sl(),
      getCurrentLocationUsecase: sl(),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<AddressBloc>(
          create: (_) => addressBloc,
        ),
        BlocProvider<AddressPageCubit>(
          create: (_) => AddressPageCubit(
            addressBloc: addressBloc,
            userId: userId,
          ),
        ),
        BlocProvider<AddressSelectionCubit>(
          create: (_) => AddressSelectionCubit(),
        ),
      ],
      child: _AddressDisplayView(userId: userId, isSelecting: isSelecting),
    );
  }
}

/// Internal view that renders the address list with bloc state conditions to show loading, empty, and loaded views.
class _AddressDisplayView extends StatelessWidget {

  // ---------------- Variables ----------------

  final String userId;
  final bool isSelecting;

  const _AddressDisplayView({
    required this.userId,
    required this.isSelecting,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressPageCubit, AddressPageState>(
      listener: (context, state) {
        if (state is AddressPageError) {
          showToast(context, state.message);
        }
        if (state is AddressPageDeleted) {
          showToast(context, state.message);
        }
        if (state is AddressDefaultSet) {
          showToast(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: context.cs.surface,
        appBar: AppBar(
          backgroundColor: context.cs.surface,
          elevation: 0,
          leading: const BackButton(),
          title: AppHeading(isSelecting ? 'Select Address' : 'My Addresses'),
          centerTitle: true,
        ),
        body: BlocBuilder<AddressPageCubit, AddressPageState>(
          builder: (context, state) {
            if (state is AddressPageInitial || state is AddressPageLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AddressPageEmpty) {
              return EmptyAddressView(
                onAddAddress: () => _navigateToAddAddress(context),
              );
            }

            if (state is AddressPageLoaded) {
              if (isSelecting) {
                // Reuse same card design with selection outline
                return BlocBuilder<AddressSelectionCubit, AddressSelectionState>(
                  builder: (context, selectionState) {
                    return AddressListView(
                      addresses: state.addresses,
                      userId: userId,
                      isSelecting: true,
                      selectedAddressId: selectionState.selectedAddress?.id,
                      onSelect: (address) {
                        context.read<AddressSelectionCubit>().selectAddress(address);
                      },
                      onAddAddress: () => _navigateToAddAddress(context),
                    );
                  },
                );
              }
              // Normal address list with actions
              return AddressListView(
                addresses: state.addresses,
                userId: userId,
                onAddAddress: () => _navigateToAddAddress(context),
                onEditAddress: (address) =>
                    _navigateToEditAddress(context, address),
                onDeleteAddress: (address) =>
                    _showDeleteDialog(context, address),
              );
            }

            return EmptyAddressView(
              onAddAddress: () => _navigateToAddAddress(context),
            );
          },
        ),
        // FAB to add address
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _navigateToAddAddress(context),
          backgroundColor: context.cs.primary,
          icon: Icon(Icons.add, color: context.cs.onPrimary),
          label: Text(
            'Add Address',
            style: context.ts.labelLarge?.copyWith(color: context.cs.onPrimary),
          ),
        ),
        // Confirm button when selecting
        bottomNavigationBar: isSelecting
            ? BlocBuilder<AddressSelectionCubit, AddressSelectionState>(
                builder: (context, state) {
                  return state.selectedAddress != null
                      ? _buildConfirmAddressButton(
                          context, state.selectedAddress!)
                      : const SizedBox.shrink();
                },
              )
            : null,
      ),
    );
  }

  // ---------------- Helper Methods ----------------

  void _navigateToAddAddress(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.addAddress,
      arguments: userId,
    ).then((_) {
      context.read<AddressPageCubit>().loadAddresses();
    });
  }

  void _navigateToEditAddress(BuildContext context, AddressEntities address) {
    Navigator.pushNamed(
      context,
      AppRoutes.editAddress,
      arguments: {'userId': userId, 'address': address},
    ).then((_) {
      context.read<AddressPageCubit>().loadAddresses();
    });
  }

  void _showDeleteDialog(BuildContext context, AddressEntities address) {
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
              Navigator.pop(dialogContext);
              context.read<AddressPageCubit>().deleteAddress(address.id);
            },
            child: Text('Delete',
                style: TextStyle(color: context.cs.error)),
          ),
        ],
      ),
    );
  }

  /// Confirm address selection button
  Widget _buildConfirmAddressButton(
    BuildContext context,
    AddressEntities selectedAddress,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context, selectedAddress),
        style: ElevatedButton.styleFrom(
          backgroundColor: context.cs.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          'Confirm Address',
          style: context.ts.labelLarge?.copyWith(color: context.cs.onPrimary),
        ),
      ),
    );
  }
}