import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/presentation/cubits/delivery/delivery_partner_state.dart';

/// Cubit mocking or assigning a delivery partner name and avatar.
class DeliveryPartnerCubit extends Cubit<DeliveryPartnerState> {
  DeliveryPartnerCubit() : super(_generatePartner());

  static DeliveryPartnerState _generatePartner() {
    final random = Random();
    const names = [
      'Rahul Kumar',
      'Amit Singh',
      'Vikram Patel',
      'Suresh Reddy',
      'Mohd. Ali',
    ];
    return DeliveryPartnerState(
      name: names[random.nextInt(names.length)],
      avatarIndex: random.nextInt(5) + 1,
    );
  }
}
