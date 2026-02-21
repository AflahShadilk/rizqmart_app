// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/services/registeration/register.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/address_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/address/address%20card/address_card_expand_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/address/address%20card/address_card_expand_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/address/address%20page/address_page_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/address/address%20page/address_page_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/address/address_selection_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/address/select_address_cubit.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/address/address_list_view_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/address/widget/empty_address.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/main_heading.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

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

class _AddressDisplayView extends StatelessWidget {
  final String userId;
  final bool isSelecting;

  const _AddressDisplayView({
    required this.userId,
    required this.isSelecting,
  });

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
                return _buildSelectableAddressListView(
                    context, state.addresses);
              }
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _navigateToAddAddress(context),
          backgroundColor: context.cs.primary,
          icon: Icon(Icons.add, color: context.cs.onPrimary),
          label: Text(
            'Add Address',
            style: context.ts.labelLarge?.copyWith(color: context.cs.onPrimary),
          ),
        ),
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

  Widget _buildSelectableAddressListView(
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
            return _SelectableAddressCard(
              address: address,
              isSelected: state.selectedAddress?.id == address.id,
            );
          },
        );
      },
    );
  }

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
            child: const Text('Delete',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

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

class _SelectableAddressCard extends StatelessWidget {
  final AddressEntities address;
  final bool isSelected;

  const _SelectableAddressCard({
    required this.address,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddressCardExpandCubit(),
      child: _SelectableAddressCardContent(
        address: address,
        isSelected: isSelected,
      ),
    );
  }
}

class _SelectableAddressCardContent extends StatelessWidget {
  final AddressEntities address;
  final bool isSelected;

  const _SelectableAddressCardContent({
    required this.address,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressCardExpandCubit, AddressCardExpandState>(
      builder: (context, expandState) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildAddressTypeLabel(context),
                            8.h,
                            _buildMainAddressInfo(context),
                            if (expandState.isExpanded)
                              _buildExpandedAddressInfo(context),
                          ],
                        ),
                      ),
                      Radio<bool>(
                        value: true,
                        groupValue: isSelected,
                        onChanged: (value) {
                          if (value == true) {
                            context
                                .read<AddressSelectionCubit>()
                                .selectAddress(address);
                          }
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: () =>
                          context.read<AddressCardExpandCubit>().toggle(),
                      icon: Icon(
                        expandState.isExpanded
                            ? Icons.expand_less
                            : Icons.expand_more,
                        size: 18,
                      ),
                      label: Text(
                          expandState.isExpanded ? 'Show Less' : 'Show More'),
                      style: TextButton.styleFrom(
                        foregroundColor: context.cs.primary,
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddressTypeLabel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.cs.primary.withValues(alpha: 0.1),
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

  Widget _buildMainAddressInfo(BuildContext context) {
    return Text(
      '${address.city}, ${address.state}',
      style: context.ts.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildExpandedAddressInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        12.h,
        _buildInfoText(context, 'Name', address.fullName),
        4.h,
        _buildInfoText(context, 'Phone', address.phoneNumber),
        4.h,
        _buildInfoText(context, 'Address', address.address1),
        if (address.address2.isNotEmpty) ...[
          2.h,
          _buildInfoText(context, '', address.address2),
        ],
        4.h,
        _buildInfoText(context, 'Pincode', address.pincode),
      ],
    );
  }

  Widget _buildInfoText(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          SizedBox(
            width: 70,
            child: Text(
              '$label:',
              style: context.ts.bodySmall?.copyWith(
                color: context.cs.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Expanded(
          child: Text(
            value,
            style: context.ts.bodySmall?.copyWith(color: context.cs.onSurface),
          ),
        ),
      ],
    );
  }
}