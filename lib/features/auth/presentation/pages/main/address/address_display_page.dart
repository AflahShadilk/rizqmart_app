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
import 'package:rizqmart/features/auth/presentation/pages/main/address/address_list_view_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/address/widget/empty_address.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/main_heading.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';

class AddressDisplayPage extends StatelessWidget {
  final String userId;

  const AddressDisplayPage({
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
    Navigator.pushNamed(
      context,
      AppRoutes.addAddress,
      arguments: userId,
    ).then((_) {
      context.read<AddressBloc>().add(LoadAddressesEvent(userId: userId));
    });
  }

  void _navigateToEditAddress(BuildContext context, AddressEntities address) {
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
}