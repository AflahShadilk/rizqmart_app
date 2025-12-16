// ignore_for_file: deprecated_member_use, invalid_use_of_visible_for_testing_member
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/address/address_form_cubit/address_form_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/address/address_form_cubit/address_form_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';

class LocationPickerButton extends StatelessWidget {
  const LocationPickerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressBloc, AddressState>(
      listener: (context, state) {
        if (state is LocationLoadedState) {
          context.read<AddressFormCubit>().updateLocation(
                state.latitude,
                state.longitude,
              );

          _autoFillAddressFromCoordinates(
            context,
            state.latitude,
            state.longitude,
          );

          showToast(context, 'Location fetched successfully');
        }
        if (state is AddressErrorState) {
          showToast(context, state.message);
        }
      },
      child: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, addressState) {
          final isLoadingLocation = addressState is LocationLoadingState;

          return BlocBuilder<AddressFormCubit, AddressFormState>(
            builder: (context, formState) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: formState.latitude != null &&
                            formState.longitude != null
                        ? context.cs.primary.withOpacity(0.5)
                        : context.cs.outlineVariant,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.my_location,
                          color: context.cs.onSurfaceVariant,
                        ),
                        12.w,
                        Text(
                          'Location Coordinates',
                          style: context.ts.bodyMedium?.copyWith(
                            color: context.cs.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    12.h,
                    if (isLoadingLocation)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              context.cs.primaryContainer.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: context.cs.primary,
                              ),
                            ),
                            12.w,
                            Text(
                              'Fetching your location...',
                              style: context.ts.bodySmall?.copyWith(
                                color: context.cs.onPrimaryContainer,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (formState.latitude != null &&
                        formState.longitude != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              context.cs.primaryContainer.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: context.cs.onPrimaryContainer,
                                  size: 20,
                                ),
                                8.w,
                                Expanded(
                                  child: Text(
                                    'Lat: ${formState.latitude!.toStringAsFixed(6)}, '
                                    'Lng: ${formState.longitude!.toStringAsFixed(6)}',
                                    style: context.ts.bodySmall?.copyWith(
                                      color: context.cs.onPrimaryContainer,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                8.w,
                                InkWell(
                                  onTap: () {
                                    context
                                        .read<AddressFormCubit>()
                                        .clearLocation();
                                  },
                                  child: Icon(
                                    Icons.close,
                                    size: 18,
                                    color: context.cs.onPrimaryContainer,
                                  ),
                                ),
                              ],
                            ),
                            if (formState.city.isNotEmpty ||
                                formState.state.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  '${formState.city}, ${formState.state}',
                                  style: context.ts.bodySmall?.copyWith(
                                    color: context.cs.onPrimaryContainer,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: context.cs.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: context.cs.onSurfaceVariant,
                            ),
                            8.w,
                            Text(
                              'No location set (Optional)',
                              style: context.ts.bodySmall?.copyWith(
                                color: context.cs.onSurfaceVariant,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    12.h,
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isLoadingLocation
                            ? null
                            : () {
                                context.read<AddressBloc>().add(
                                      GetCurrentLocationEvent(),
                                    );
                              },
                        icon: isLoadingLocation
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.gps_fixed, size: 18),
                        label: Text(
                          isLoadingLocation
                              ? 'Getting Location...'
                              : 'Use Current Location',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.cs.primary,
                          foregroundColor: context.cs.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _autoFillAddressFromCoordinates(
    BuildContext context,
    double latitude,
    double longitude,
  ) async {
    final formCubit = context.read<AddressFormCubit>();

    try {
      // Perform reverse geocoding
      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks[0];

        // Extract city/locality and state/administrative area
        final city = place.locality ?? place.administrativeArea ?? '';
        final state = place.administrativeArea ?? '';
        final country = place.country ?? 'India';

        // Update city if empty
        if (formCubit.state.city.isEmpty && city.isNotEmpty) {
          formCubit.updateCity(city);
        }

        // Update state if empty
        if (formCubit.state.state.isEmpty && state.isNotEmpty) {
          formCubit.updateState(state);
        }

        // Update country if empty
        if (formCubit.state.country.isEmpty && country.isNotEmpty) {
          formCubit.updateCountry(country);
        }
      } else {
        // Fallback to default values if no placemarks found
        if (formCubit.state.city.isEmpty) {
          formCubit.updateCity('');
        }
        if (formCubit.state.state.isEmpty) {
          formCubit.updateState('');
        }
        if (formCubit.state.country.isEmpty) {
          formCubit.updateCountry('India');
        }
      }
    } catch (e) {
      // Fallback to default values on error
      if (formCubit.state.country.isEmpty) {
        formCubit.updateCountry('India');
      }
    }
  }
}

extension AddressFormCubitExtension on AddressFormCubit {
  void clearLocation() {
    // ignore: invalid_use_of_protected_member
    emit(state.copyWith(latitude: null, longitude: null));
  }

  void updateCountry(String country) {
    // ignore: invalid_use_of_protected_member
    emit(state.copyWith(country: country));
  }
}